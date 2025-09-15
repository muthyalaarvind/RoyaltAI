public with sharing class PaymentService {

    public static String generateReceipt(Id paymentId) {
        Payment__c pay = [
            SELECT Name, Amount_Paid__c, Payment_Date__c, Mode_of_Payment__c,
                   Client__r.Name, Royalty__r.Name, Remarks__c
            FROM Payment__c
            WHERE Id = :paymentId
            LIMIT 1
        ];

        String receipt = '*** Payment Receipt ***\n';
        receipt += 'Name: ' + pay.Name + '\n';
        receipt += 'Client: ' + (pay.Client__r != null ? pay.Client__r.Name : 'N/A') + '\n';
        receipt += 'Royalty: ' + (pay.Royalty__r != null ? pay.Royalty__r.Name : 'N/A') + '\n';
        receipt += 'Amount Paid: ₹' + pay.Amount_Paid__c + '\n';
        receipt += 'Payment Date: ' + pay.Payment_Date__c.format() + '\n';
        receipt += 'Mode: ' + pay.Mode_of_Payment__c + '\n';
        receipt += 'Remarks: ' + pay.Remarks__c + '\n';
        return receipt;
    }

public static Decimal calculateTotalRoyaltyPayments(Id royaltyId) {
    List<AggregateResult> result = Database.query(
        'SELECT SUM(Amount_Paid__c) totalPaid FROM Payment__c WHERE Royalty__c = :royaltyId'
    );
    
    if (!result.isEmpty()) {
        return (Decimal) result[0].get('totalPaid');
    } else {
        return 0;
    }
}
}