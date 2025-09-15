public with sharing class RoyaltyTrackerController {
    @AuraEnabled(cacheable=true)
    public static List<Royalty__c> getAllRoyalties(String licenseId) {
        return [
            SELECT Id, Name, Rate_Per_Unit__c, License__c, Royalty_Type__c, Total_Views__c, Total_Royality__c, Status__c
            FROM Royalty__c
            ORDER BY CreatedDate DESC
            LIMIT 100
        ];
    }
}
