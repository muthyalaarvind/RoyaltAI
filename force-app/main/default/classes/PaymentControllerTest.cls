@isTest
private class PaymentControllerTest {

    @isTest
    static void testGetAllPayments() {
        Client__c client = new Client__c(Name = 'Test Client');
        insert client;

        List<Payment__c> payments = new List<Payment__c>();
        for (Integer i = 1; i <= 3; i++) {
            payments.add(new Payment__c(
                Name = 'Payment ' + i,
                Amount_Paid__c = 1000 * i,
                Mode_of_Payment__c = 'Cash',
                Payment_Date__c = Date.today().addDays(-i),
                Remarks__c = 'Test Payment ' + i,
                Client__c = client.Id
            ));
        }
        insert payments;

        Test.startTest();
        List<Payment__c> result = PaymentController.getAllPayments();
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assert(result.size() >= 3);
    }

    @isTest
    static void testGetReceipt() {
        Client__c client = new Client__c(Name = 'Test Client');
        insert client;

        Payment__c payment = new Payment__c(
            Name = 'Payment 1',
            Amount_Paid__c = 1500,
            Mode_of_Payment__c = 'Card',
            Payment_Date__c = Date.today(),
            Remarks__c = 'Paid in full',
            Client__c = client.Id
        );
        insert payment;

        Test.startTest();
        String receipt = PaymentController.getReceipt(payment.Id);
        Test.stopTest();

        System.assertNotEquals(null, receipt);
        System.assert(receipt.contains('Test Client'));
    }
}
