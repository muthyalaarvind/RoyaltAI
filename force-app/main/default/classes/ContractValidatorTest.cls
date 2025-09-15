@isTest
private class ContractValidatorTest {

    @isTest
    static void testValidContractPasses() {
        Contract__c contract = new Contract__c(
            Contract_Date__c = Date.today(),
            Status__c = 'Active',
            File_Link__c = 'https://example.com/doc.pdf'
        );

        Test.startTest();
        ContractValidator.validateContract(contract);
        Test.stopTest();
    }

    @isTest
    static void testMissingContractDateFails() {
        Contract__c contract = new Contract__c(
            Status__c = 'Active',
            File_Link__c = 'https://example.com/doc.pdf'
        );

        Test.startTest();
        try {
            ContractValidator.validateContract(contract);
            System.assert(false, 'Expected exception for missing Contract_Date__c');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Contract Date is required.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testMissingStatusFails() {
        Contract__c contract = new Contract__c(
            Contract_Date__c = Date.today(),
            File_Link__c = 'https://example.com/doc.pdf'
        );

        Test.startTest();
        try {
            ContractValidator.validateContract(contract);
            System.assert(false, 'Expected exception for missing Status__c');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Status is required.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testInvalidFileLinkFails() {
        Contract__c contract = new Contract__c(
            Contract_Date__c = Date.today(),
            Status__c = 'Active',
            File_Link__c = 'ftp://invalid-link.com'
        );

        Test.startTest();
        try {
            ContractValidator.validateContract(contract);
            System.assert(false, 'Expected exception for invalid File_Link__c');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('File Link must be a valid URL.'));
        }
        Test.stopTest();
    }
}
