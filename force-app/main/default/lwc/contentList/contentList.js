import { LightningElement, wire } from 'lwc';
import fetchContentRecords from '@salesforce/apex/ContentController.fetchContentRecords';

export default class ContentList extends LightningElement {
    contentRecords;
    columns = [
        { label: 'Title', fieldName: 'Title__c' },
        { label: 'Genre', fieldName: 'Genre__c' },
        { label: 'Ready To License', fieldName: 'Ready_To_License__c' },
        { label: 'Duration', fieldName: 'Duration__c', type: 'number' },
        { label: 'Language', fieldName: 'Language__c', type: 'Text' },
        { label: 'Release Date', fieldName: 'Release_Date__c', type: 'date' }
    ];

    @wire(fetchContentRecords)
    wiredContent({ data, error }) {
        if (data) this.contentRecords = data;
        else if (error) console.error(error);
    }
}