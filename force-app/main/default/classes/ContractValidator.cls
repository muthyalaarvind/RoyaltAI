public class ContractValidator {

    // Custom Exception Class
    public class ContractValidationException extends Exception {}

    public static void validateContract(SObject contract) {
        if (contract.get('Contract_Date__c') == null) {
            throw new ContractValidationException('Contract Date is required.');
        }

        if (String.isBlank((String)contract.get('Status__c'))) {
            throw new ContractValidationException('Status is required.');
        }

        String fileLink = (String)contract.get('File_Link__c');
        if (fileLink != null && !fileLink.startsWith('http')) {
            throw new ContractValidationException('File Link must be a valid URL.');
        }
    }
}
