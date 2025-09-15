@isTest
public class RoyaltyValidatorTest {
    @isTest
    static void testNegativeViews() {
        License__c license = new License__c(
            Status__c = 'Draft',
            Start_Date__c = Date.today()
        );
        insert license;

        Royalty__c r = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = -5,
            Rate_Per_Unit__c = 1,
            Status__c = 'Finalized'
        );
        Test.startTest();
        try {
            insert r;
            System.assert(false, 'Should have thrown error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Total Views cannot be negative'));
        }
        Test.stopTest();
    }

    @isTest
    static void testUnfinalizedRoyalty() {
        License__c license = new License__c(
            Status__c = 'Draft',
            Start_Date__c = Date.today()
        );
        insert license;

        Royalty__c r = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 10,
            Rate_Per_Unit__c = 1,
            Status__c = 'Draft'
        );
        Test.startTest();
        try {
            insert r;
            System.assert(false, 'Should have thrown error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Royalty must be Finalized before inserting.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testMissingLicense() {
        Royalty__c r = new Royalty__c(
            Total_Views__c = 10,
            Rate_Per_Unit__c = 1,
            Status__c = 'Finalized'
        );
        Test.startTest();
        try {
            insert r;
            System.assert(false, 'Should have thrown error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('License is required'));
        }
        Test.stopTest();
    }

    @isTest
    static void testInvalidStatus() {
        License__c license = new License__c(
            Status__c = 'Draft',
            Start_Date__c = Date.today()
        );
        insert license;

        Royalty__c r = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 10,
            Rate_Per_Unit__c = 1,
            Status__c = 'Finalized'
        );
        Test.startTest();
        try {
            insert r;
            System.assert(false, 'Should have thrown error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Status must be Draft, Finalized, Ready for Payment, or Paid.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testTotalRoyaltyZero() {
        License__c license = new License__c(
            Status__c = 'Draft',
            Start_Date__c = Date.today()
        );
        insert license;

        // Set Rate_Per_Unit__c and Total_Views__c so formula will be zero
        Royalty__c r = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 0,
            Rate_Per_Unit__c = 0,
            Status__c = 'Finalized'
        );
        Test.startTest();
        try {
            insert r;
            System.assert(false, 'Should have thrown error');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Total Royalty must be greater than zero.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testValidRoyaltyInsert() {
        License__c license = new License__c(
            Status__c = 'Draft',
            Start_Date__c = Date.today()
        );
        insert license;

        Royalty__c r = new Royalty__c(
            License__c = license.Id,
            Total_Views__c = 10,
            Rate_Per_Unit__c = 1,
            Status__c = 'Finalized'
        );
        Test.startTest();
        insert r;
        Test.stopTest();
        System.assertNotEquals(null, r.Id, 'Royalty__c record should have been inserted successfully');
    }
}