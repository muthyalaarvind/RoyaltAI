import { LightningElement, track, wire } from 'lwc';
import getAllRoyalties from '@salesforce/apex/RoyaltyTrackerController.getAllRoyalties';

const COLUMNS = [
    { label: 'Royalty Name', fieldName: 'Name' },
    { label: 'Rate Per Unit', fieldName: 'Rate_Per_Unit__c', type: 'number' },
    { label: 'License', fieldName: 'LicenseName' },
    { label: 'Royalty Type', fieldName: 'Royalty_Type__c' },
    { label: 'Total Views', fieldName: 'Total_Views__c', type: 'number' },
    { label: 'Total Royality', fieldName: 'Total_Royality__c', type: 'currency' },
    { label: 'Status', fieldName: 'Status__c' }
];

export default class RoyaltyTracker extends LightningElement {
    @track royalties = [];
    @track filteredRoyalties = [];
    @track error;
    columns = COLUMNS;

 @wire(getAllRoyalties, { licenseId: '$recordId' })
wiredRoyalties({ error, data }) {
    if (data) {
        console.log('Fetched royalties:', data);
        this.royalties = data;
        this.filteredRoyalties = data;
    } else if (error) {
        console.error('Error:', error);
    }
}
    

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.filteredRoyalties = this.royalties.filter(royalty =>
            royalty.Name.toLowerCase().includes(searchKey)
        );
    }

    refreshList() {
        return refreshApex(this.wiredRoyaltyRecords);
    }
}
