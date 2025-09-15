import { LightningElement, wire } from 'lwc';
import getContracts from '@salesforce/apex/ContractController.getContracts';

export default class contractList extends LightningElement {
    contracts;
    error;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Start Date', fieldName: 'Contract_Start_Date__c', type: 'date' },
        { label: 'End Date', fieldName: 'Contract_End_Date__c', type: 'date' },
        { label: 'License Type', fieldName: 'License_Type__c' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Remarks', fieldName: 'Remarks__c' }
    ];

    @wire(getContracts)
    wiredContracts({ error, data }) {
        if (data) {
            this.contracts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.contracts = undefined;
        }
    }
}