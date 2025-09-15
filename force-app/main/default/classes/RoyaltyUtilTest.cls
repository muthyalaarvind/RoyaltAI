@isTest
public class RoyaltyUtilTest {
    
    @testSetup
    static void setupData() {
        // Create a test Client
        Account client = new Account(Name = 'Test Client');
        insert client;

        // Create a test Content
        Content__c content = new Content__c(Name = 'Test Movie');
        insert content;

        // Create a test Contract
        Contract__c contract = new Contract__c();
        insert contract;

        // Create a test License
    License__c license = new License__c(
    Client__c = client.Id,
    Content__c = content.Id,
    Start_Date__c = Date.today(),             // 🟢 likely required
    Status__c = 'Draft',                      // 🟢 if there's a picklist with validation
    License_Type__c = 'flat'                  // 🟢 optional, if required
);
insert license;

    }

    @isTest
    static void testCalculateRoyaltySuccess() {
        License__c lic = [SELECT Id FROM License__c LIMIT 1];
        Decimal rate = 3;
        Decimal views = 4000;

        Decimal result = RoyaltyUtil.calculatedRoyalty(rate, views);
        System.assertEquals(12000, result, 'Royalty calculation should be correct');
    }

    @isTest
    static void testCreateRoyaltyRecordSuccess() {
        License__c lic = [SELECT Id FROM License__c LIMIT 1];
        Decimal rate = 2;
        Integer views = 500;

        Decimal result = RoyaltyUtil.createRoyaltyRecord(lic.Id, rate, views);
        System.assertEquals(1000, result, 'Royalty record creation should be correct');
    }

    @isTest
    static void testCalculatedRoyalty_NullInputs() {
        try {
            RoyaltyUtil.calculatedRoyalty(null, 100);
            System.assert(false, 'Should have thrown error for null rate');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('cannot be null'));
        }

        try {
            RoyaltyUtil.calculatedRoyalty(10, null);
            System.assert(false, 'Should have thrown error for null views');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('cannot be null'));
        }
    }

    @isTest
    static void testCreateRoyaltyRecord_NullInputs() {
        License__c lic = [SELECT Id FROM License__c LIMIT 1];
        try {
            RoyaltyUtil.createRoyaltyRecord(null, 2, 100);
            System.assert(false, 'Should have thrown error for null license');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('cannot be null'));
        }

        try {
            RoyaltyUtil.createRoyaltyRecord(lic.Id, null, 100);
            System.assert(false, 'Should have thrown error for null rate');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('cannot be null'));
        }

        try {
            RoyaltyUtil.createRoyaltyRecord(lic.Id, 2, null);
            System.assert(false, 'Should have thrown error for null views');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('cannot be null'));
        }
    }

    @isTest
    static void testProcessRoyalty() {
        License__c lic = [SELECT Id FROM License__c LIMIT 1];
        Royalty__c royalty = new Royalty__c(
            License__c = lic.Id,
            Rate_Per_Unit__c = 5,
            Total_Views__c = 100,
            Status__c = 'Finalized'
        );
        insert royalty;

        Test.startTest();
        RoyaltyUtil.processRoyalty(royalty);
        Test.stopTest();
        // No assert needed, just ensure no error and debug output
    }
}