@isTest
public class ClientControllerTest {

    @testSetup
    static void setupTestData() {
        // Insert multiple test Client__c records
        List<Client__c> clients = new List<Client__c>{
            new Client__c(
                Name = 'Test Client 1',
                Company_Name__c = 'Company A',
                Contact_Person__c = 'John Doe',
                Email__c = 'john@example.com',
                Industry__c = 'Technology',
                Phone__c = '123-456-7890'
            ),
            new Client__c(
                Name = 'Test Client 2',
                Company_Name__c = 'Company B',
                Contact_Person__c = 'Jane Smith',
                Email__c = 'jane@example.com',
                Industry__c = 'Finance',
                Phone__c = '987-654-3210'
            )
        };
        insert clients;
    }

    @isTest
    static void testFetchClientRecords() {
        // Call the method
        List<Client__c> results = ClientController.fetchClientRecords();

        // Verify results are returned
        System.assertNotEquals(null, results, 'Expected non-null result');
        System.assert(results.size() >= 2, 'Expected at least 2 client records');

        // Optional: Verify data correctness
        Set<String> names = new Set<String>();
        for (Client__c c : results) {
            names.add(c.Name);
        }
        System.assert(names.contains('Test Client 1'), 'Result should include Test Client 1');
        System.assert(names.contains('Test Client 2'), 'Result should include Test Client 2');
    }
}
