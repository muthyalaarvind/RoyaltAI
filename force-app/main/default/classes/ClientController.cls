public with sharing class ClientController {
    @AuraEnabled(cacheable=true)
    public static List<Client__c> fetchClientRecords() {
        // Query only necessary fields from Client__c custom object
        return [
            SELECT Id, Name, Company_Name__c, Contact_Person__c, Email__c, Industry__c, Phone__c
            FROM Client__c
            ORDER BY Name
            LIMIT 100
        ];
    }
}
