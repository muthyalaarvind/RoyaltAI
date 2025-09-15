public class RoyaltyTriggerHandler {

    // BEFORE INSERT: Validate required fields and default values
    public static void handleBeforeInsert(List<Royalty__c> newList) {
        for (Royalty__c royalty : newList) {
            validateRoyaltyFields(royalty);
        }
    }

    // BEFORE UPDATE: Prevent edits if Status is Finalized and validate required fields
    public static void handleBeforeUpdate(List<Royalty__c> newList, Map<Id, Royalty__c> oldMap) {
        for (Royalty__c royalty : newList) {
            Royalty__c oldRecord = oldMap.get(royalty.Id);

            if (oldRecord != null && oldRecord.Status__c == 'Finalized' && royalty.Status__c != 'Finalized') {
                royalty.addError('Cannot change Status from Finalized to another status.');
            }
            validateRoyaltyFields(royalty);
        }
    }

    // Helper method to validate Royalty__c fields
    private static void validateRoyaltyFields(Royalty__c royalty) {
        if (royalty.Total_Royality__c == null || royalty.Total_Royality__c <= 0) {
            royalty.addError('Total Royalty must be greater than zero.');
        }

        if (royalty.License__c == null) {
            royalty.addError('License is required.');
        }

        if (royalty.Status__c == null ||
            !(royalty.Status__c == 'Draft' || royalty.Status__c == 'Finalized' ||
              royalty.Status__c == 'Ready for Payment' || royalty.Status__c == 'Paid')) {
            royalty.addError('Status must be Draft, Finalized, Ready for Payment, or Paid.');
        }
    }

    // AFTER INSERT: (Optional)
    public static void handleAfterInsert(List<Royalty__c> newList) {
        // No actions currently needed
    }

    // AFTER UPDATE: Auto-create Payment__c when Status is changed to Paid
    public static void handleAfterUpdate(List<Royalty__c> newList, Map<Id, Royalty__c> oldMap) {
        List<Payment__c> paymentsToInsert = new List<Payment__c>();

        Set<Id> licenseIds = new Set<Id>();
        for (Royalty__c royalty : newList) {
            if (royalty.License__c != null) {
                licenseIds.add(royalty.License__c);
            }
        }

        Map<Id, License__c> licenseMap = new Map<Id, License__c>(
            [SELECT Id, Client__c FROM License__c WHERE Id IN :licenseIds]
        );

        for (Royalty__c royalty : newList) {
            Royalty__c oldRoyalty = oldMap.get(royalty.Id);
            if (royalty.Status__c == 'Paid' && oldRoyalty.Status__c != 'Paid') {
                License__c relatedLicense = licenseMap.get(royalty.License__c);

                if (relatedLicense != null && relatedLicense.Client__c != null) {
                    paymentsToInsert.add(new Payment__c(
                        Royalty__c = royalty.Id,
                        Client__c = relatedLicense.Client__c,
                        Amount_Paid__c = royalty.Total_Royality__c,
                        Mode_of_Payment__c = 'Bank Transfer',
                        Payment_Date__c = Date.today(),
                        Remarks__c = 'Auto-payment created after royalty payment'
                    ));
                }
            }
        }

        if (!paymentsToInsert.isEmpty()) {
            insert paymentsToInsert;
        }
    }

    // AFTER DELETE: No logic yet
    public static void handleAfterDelete(List<Royalty__c> oldList) {
        // Optional cleanup
    }
}
