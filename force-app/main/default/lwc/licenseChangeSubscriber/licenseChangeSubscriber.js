import { LightningElement, wire, track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
const CHANNEL = '/data/License__cChangeEvent';
import getLicensesForContent from '@salesforce/apex/LicenseController.getLicensesForContent';

export default class LicenseChangeSubscriber extends LightningElement {
    channelName = CHANNEL;
    subscription = null;
    @track licenses = [];

    connectedCallback() {
        this.registerErrorListener();
        this.handleSubscribe();
        this.loadLicenses();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    loadLicenses() {
        getLicensesForContent()
            .then(data => {
                this.licenses = data;
            })
            .catch(error => {
                console.error('Error loading license data:', error);
            });
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('✅ License ChangeEvent received:', JSON.stringify(response));
            this.loadLicenses(); // Refresh data
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('✅ Subscribed to channel:', response.channel);
            this.subscription = response;
        });
    }

    handleUnsubscribe() {
        if (this.subscription) {
            unsubscribe(this.subscription, response => {
                console.log('❎ Unsubscribed from channel:', response);
            });
        }
    }

    registerErrorListener() {
        onError(error => {
            console.error('🚨 EMP API Error:', error);
        });
    }
}