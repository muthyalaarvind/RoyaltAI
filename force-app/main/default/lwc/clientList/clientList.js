import { LightningElement, wire, track } from 'lwc';
import fetchClientRecords from '@salesforce/apex/ClientController.fetchClientRecords';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Company Name', fieldName: 'Company_Name__c' },
    { label: 'Contact Person', fieldName: 'Contact_Person__c' },
    { label: 'Email', fieldName: 'Email__c', type: 'email' },
    { label: 'Industry', fieldName: 'Industry__c' },
    { label: 'Phone', fieldName: 'Phone__c', type: 'phone' }
];

export default class ClientList extends LightningElement {
    @track clientRecords = [];
    @track filteredClients = [];
    @track error;
    columns = COLUMNS;

    @wire(fetchClientRecords)
    wiredClients({ error, data }) {
        if (data) {
            this.clientRecords = data;
            this.filteredClients = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.clientRecords = [];
            this.filteredClients = [];
        }
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.filteredClients = this.clientRecords.filter(client =>
            client.Name.toLowerCase().includes(searchKey)
        );
    }
}
