@isTest
public class PaymentTest {

    @isTest
    static void testGenerateReceiptAndTotals() {
        // Step 1: Create test Client
        Account client = new Account(Name = 'Test Client');
        insert client;

        // Step 2: Create License__c linked to Client
        License__c license = new License__c(
            Start_Date__c = Date.today(),
            Status__c = 'Draft',
            Client__c = client.Id
        );
        insert license;

        // Step 3: Create Royalty__c with required License__c
        Royalty__c royalty = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 100,
            Rate_Per_Unit__c = 5,
            Status__c = 'Draft'
        );
        insert royalty;

        // Step 4: Create Payment__c
        Payment__c payment = new Payment__c(
            Client__c = client.Id,
            Royalty__c = royalty.Id,
            Amount_Paid__c = 500,
            Payment_Date__c = Date.today(),
            Mode_of_Payment__c = 'Bank Transfer',
            Remarks__c = 'Test Payment'
        );
        insert payment;

        // Step 5: Run test methods
        Test.startTest();
        String receipt = PaymentService.generateReceipt(payment.Id);
        Decimal total = PaymentService.calculateTotalRoyaltyPayments(royalty.Id);
        Test.stopTest();

        // Step 6: Assert output
        System.assertNotEquals(null, receipt, 'Receipt should not be null');
        System.assert(receipt.contains('Client: Test Client'), 'Receipt should include client name');
        System.assertEquals(500, total, 'Total royalty payments should match inserted value');
    }

    @isTest
    static void testGenerateReceiptWithNullClientAndRoyalty() {
        // Required: Create dummy Royalty to pass required field validation
        Account dummyClient = new Account(Name = 'Dummy Client');
        insert dummyClient;

        License__c license = new License__c(
            Start_Date__c = Date.today(),
            Status__c = 'Draft',
            Client__c = dummyClient.Id
        );
        insert license;

        Royalty__c dummyRoyalty = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 50,
            Rate_Per_Unit__c = 2,
            Status__c = 'Draft'
        );
        insert dummyRoyalty;

        // Insert Payment__c with Royalty__c but null Client__c
        Payment__c payment = new Payment__c(
            Royalty__c = dummyRoyalty.Id,
            Amount_Paid__c = 100,
            Payment_Date__c = Date.today(),
            Mode_of_Payment__c = 'Bank Transfer',
            Remarks__c = 'Test without client'
        );
        insert payment;

        Test.startTest();
        String receipt = PaymentService.generateReceipt(payment.Id);
        Test.stopTest();

        System.assertNotEquals(null, receipt, 'Receipt should not be null');
        System.assert(receipt.contains('Client: N/A'), 'Should show Client: N/A');
    }
}
