import { LightningElement, wire, track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import getContracts from '@salesforce/apex/ContractController.getContracts';

export default class ContractChangeSubscriber extends LightningElement {
    channelName = '/data/Contract__cChangeEvent';
    subscription = null;
    @track contracts = [];

    connectedCallback() {
        this.registerErrorListener();
        this.handleSubscribe();
        this.loadContracts();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    loadContracts() {
        getContracts()
            .then(data => {
                this.contracts = data;
            })
            .catch(error => {
                console.error('Error loading contracts:', error);
            });
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('Change event received:', response);
            this.loadContracts(); // Refresh contract list
        };

        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Subscribed to channel:', response.channel);
            this.subscription = response;
        });
    }

    handleUnsubscribe() {
        if (this.subscription) {
            unsubscribe(this.subscription, response => {
                console.log('Unsubscribed from channel:', response);
            });
        }
    }

    registerErrorListener() {
        onError(error => {
            console.error('EMP API Error:', error);
        });
    }
}