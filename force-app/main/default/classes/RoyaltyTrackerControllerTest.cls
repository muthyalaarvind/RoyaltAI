@isTest
private class RoyaltyTrackerControllerTest {

    @isTest static void testGetRoyaltiesByLicense() {
        License__c license = new License__c(
            Start_Date__c = Date.today(),
            Status__c = 'Draft'
        );
        insert license;

        Royalty__c royalty = new Royalty__c(
            License__c = license.Id,
            Rate_Per_Unit__c = 5,
            Total_Views__c = 100,
            Status__c = 'Draft'
        );
        insert royalty;

        Test.startTest();
        List<Royalty__c> result = RoyaltyTrackerController.getAllRoyalties(license.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Should return exactly one Royalty record');
        System.assertEquals(royalty.Id, result[0].Id, 'Returned Royalty Id should match the inserted one');
    }

    @isTest static void testGetRoyaltiesByLicense_NoRoyalties() {
        License__c license = new License__c(
            Start_Date__c = Date.today(),
            Status__c = 'Draft'
        );
        insert license;

        Test.startTest();
        List<Royalty__c> result = RoyaltyTrackerController.getAllRoyalties(license.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Should return no Royalty records');
    }

    @isTest static void testGetAllRoyaltiesWithNullLicenseId() {
        Test.startTest();
        List<Royalty__c> result = RoyaltyTrackerController.getAllRoyalties(null);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Should return empty list when licenseId is null');
    }
}
