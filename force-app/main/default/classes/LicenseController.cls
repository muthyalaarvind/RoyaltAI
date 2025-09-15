/**
 * LicenseController
 * Exposes methods to fetch License__c records for a given Content__c.
 */
public with sharing class LicenseController {
    /**
     * Fetches License__c records for a specific Content__c.
     * @param contentId The Id of the Content__c record.
     * @return List<License__c> - List of License__c records related to the content.
     */
    @AuraEnabled(cacheable=true)
    public static List<License__c> getLicensesForContent(Id contentId) {
        return [
            SELECT Id, Start_Date__c, End_Date__c, Status__c, Currency__c, Content__c, Client__c, License_Type__c
            FROM License__c
            WHERE Content__c = :contentId
            ORDER BY Start_Date__c ASC
        ];
    }
}