public with sharing class ContentController {
    @AuraEnabled(cacheable=true)
    public static List<Content__c> fetchContentRecords() {
        return [
            SELECT Id, Name, Title__c, Genre__c, Release_Date__c, Duration__c, Language__c, Ready_To_License__c
            FROM Content__c
            LIMIT 100
        ];
    }
}
