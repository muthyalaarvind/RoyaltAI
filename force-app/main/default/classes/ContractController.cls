public with sharing class ContractController {
    
    @AuraEnabled(cacheable=true)
    // Ensure that the object API name is correct and exists in your org.
    // If the object is actually named 'Contract' (standard object), remove the '__c' suffix.
    public static List<Contract__c> getContracts() {
        return [
            SELECT 
                Contract_Date__c,
                Status__c,
                File_Link__c,
                License__c
            FROM Contract__c
            ORDER BY LastModifiedDate DESC
            LIMIT 10
        ];
    }
}