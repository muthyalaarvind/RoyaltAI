import { LightningElement, api, wire } from 'lwc';
import getLicensesForContent from '@salesforce/apex/LicenseController.getLicensesForContent';

export default class LicensingTimeline extends LightningElement {
  @api recordId;
  licenses = [];
  filteredLicenses = [];

  columns = [
    { label: 'Client', fieldName: 'Client__c', type: 'text' },
    { label: 'Content', fieldName: 'Content__c', type: 'text' },
    { label: 'Currency', fieldName: 'Currency__c', type: 'currency' },
    { label: 'End Date', fieldName: 'End_Date__c', type: 'date' },
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'License Type', fieldName: 'License_Type__c', type: 'text' },
    { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date' }
  ];

  @wire(getLicensesForContent, { contentId: '$recordId' })
  wiredLicenses({ data, error }) {
    if (data) {
      this.licenses = data;
      this.filteredLicenses = data;
    } else if (error) {
      console.error('Error loading licenses:', error);
    }
  }

  handleSearch(event) {
    const term = event.target.value.toLowerCase();
    this.filteredLicenses = this.licenses.filter(
      record => record.Name?.toLowerCase().includes(term)
    );
  }
}