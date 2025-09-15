import { LightningElement, wire, track } from 'lwc';
import getAllPayments from '@salesforce/apex/PaymentController.getAllPayments';
import getReceipt from '@salesforce/apex/PaymentController.getReceipt';


const COLUMNS = [
  { label: 'Name', fieldName: 'Name' },
  { label: 'Amount', fieldName: 'Amount_Paid__c', type: 'currency' },
  { label: 'Client', fieldName: 'ClientName', type: 'text' },
  { label: 'Mode', fieldName: 'Mode_of_Payment__c' },
  { label: 'Date', fieldName: 'Payment_Date__c', type: 'date' },
  { label: 'Remarks', fieldName: 'Remarks__c' },
  { label: 'Action', type: 'button', typeAttributes: { label: 'Generate Receipt', name: 'generate' } }
];

export default class PaymentList extends LightningElement {
  @track payments;
  @track filteredPayments;
  @track error;
  @track receipt;
  columns = COLUMNS;
  searchTerm = '';

  @wire(getAllPayments)
  wiredPayments({ error, data }) {
    if (data) {
      this.payments = data.map(row => ({
        ...row,
        ClientName: row.Client__r?.Name
      }));
      this.filteredPayments = this.payments;
      this.error = undefined;
    } else if (error) {
      this.error = error.body.message;
      this.payments = undefined;
      this.filteredPayments = undefined;
    }
  }

  handleRowAction(event) {
    const action = event.detail.action.name;
    const row = event.detail.row;
    if (action === 'generate') {
      this.getReceipt(row.Id);
    }
  }

  getReceipt(paymentId) {
    getReceipt({ paymentId })
      .then(result => {
        this.receipt = result;
      })
      .catch(error => {
        this.error = error.body.message;
      });
  }

  handleSearch(event) {
    const term = event.target.value.toLowerCase();
    this.filteredPayments = this.payments.filter(record =>
      record.Name && record.Name.toLowerCase().includes(term)
    );
  }
}