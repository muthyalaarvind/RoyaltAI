/**
 * RoyaltyValidator
 * Utility class for validating Royalty__c records before insert or update.
 */
public class RoyaltyValidator {
    /**
     * Validates a list of Royalty__c records.
     * @param royalties List of SObject (Royalty__c) records to validate.
     * @param isInsert True if called during insert, false for update.
     */
    public static void validateRoyalty(List<SObject> royalties, Boolean isInsert) {
        for (SObject sObj : royalties) {
            Royalty__c royaltyRecordLocal = (Royalty__c)sObj;

            // Validation 1: Total Views must be non-negative
            if (royaltyRecordLocal != null && royaltyRecordLocal.Total_Views__c != null && royaltyRecordLocal.Total_Views__c < 0) {
                sObj.addError('Total Views cannot be negative.');
            }

            // Validation 2: Status must be Finalized before insert
            if (royaltyRecordLocal != null && isInsert && royaltyRecordLocal.Status__c != 'Finalized') {
                sObj.addError('Royalty must be Finalized before inserting.');
            }

            // Validation 3: Total Royalty must be greater than zero
            if (royaltyRecordLocal != null && (royaltyRecordLocal.Total_Royality__c == null || royaltyRecordLocal.Total_Royality__c <= 0)) {
                sObj.addError('Total Royalty must be greater than zero.');
            }

            // Validation 4: License__c is required
            if (royaltyRecordLocal != null && royaltyRecordLocal.License__c == null) {
                sObj.addError('License is required.');
            }

            // Validation 5: Status__c allowed values
            if (royaltyRecordLocal != null &&
                (royaltyRecordLocal.Status__c == null ||
                 !(royaltyRecordLocal.Status__c == 'Draft' ||
                   royaltyRecordLocal.Status__c == 'Finalized' ||
                   royaltyRecordLocal.Status__c == 'Ready for Payment' ||
                   royaltyRecordLocal.Status__c == 'Paid'))) {
                sObj.addError('Status must be Draft, Finalized, Ready for Payment, or Paid.');
            }
        }
    }
}