@isTest
public class ContentControllerTest {

    @testSetup
    static void setupTestData() {
        List<Content__c> contents = new List<Content__c>();
        for (Integer i = 1; i <= 5; i++) {
            contents.add(new Content__c(
                Name = 'Test Content ' + i,
                Title__c = 'Title ' + i,
                Genre__c = 'Genre ' + i,
                Release_Date__c = Date.today().addDays(-i),
                Duration__c = 120 + i,
                Language__c = 'English',
                Ready_To_License__c = true
            ));
        }
        insert contents;
    }

    @isTest
    static void testFetchContentRecords() {
        Test.startTest();
        List<Content__c> results = ContentController.fetchContentRecords();
        Test.stopTest();

        System.assertNotEquals(null, results, 'Results should not be null');
        System.assert(results.size() > 0, 'Should return some content records');

        Content__c first = results[0];
        System.assertNotEquals(null, first.Name, 'Name should not be null');
        System.assertNotEquals(null, first.Title__c, 'Title should not be null');
    }
}
