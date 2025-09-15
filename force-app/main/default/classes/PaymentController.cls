public with sharing class PaymentController {
    
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getAllPayments() {
        return [
            SELECT Id, Name, Amount_Paid__c, Mode_of_Payment__c, Payment_Date__c,
                   Remarks__c, Client__c, Client__r.Name
            FROM Payment__c
            ORDER BY Payment_Date__c DESC
            LIMIT 100
        ];
    }

    @AuraEnabled
    public static String getReceipt(Id paymentId) {
        Payment__c payment = [
            SELECT Name, Amount_Paid__c, Mode_of_Payment__c, Payment_Date__c,
                   Remarks__c, Client__r.Name
            FROM Payment__c
            WHERE Id = :paymentId
            LIMIT 1
        ];

        String receipt = '--- Payment Receipt ---\n';
        receipt += 'Client: ' + (payment.Client__r != null ? payment.Client__r.Name : 'N/A') + '\n';
        receipt += 'Payment Name: ' + payment.Name + '\n';
        receipt += 'Amount Paid: ₹' + payment.Amount_Paid__c + '\n';
        receipt += 'Mode: ' + payment.Mode_of_Payment__c + '\n';
        receipt += 'Date: ' + payment.Payment_Date__c.format() + '\n';
        receipt += 'Remarks: ' + payment.Remarks__c + '\n';
        receipt += '------------------------';

        return receipt;
    }
}
