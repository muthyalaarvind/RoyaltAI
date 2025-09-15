import { createElement } from '@lwc/engine-dom';
import RoyaltyTracker from 'c/royaltyTracker';
import { getAllRoyalties } from '@salesforce/apex/RoyaltyTrackerController';

// Mock the Apex method
jest.mock('@salesforce/apex/RoyaltyTrackerController', () => ({
    getAllRoyalties: jest.fn()
}), { virtual: true });

describe('c-royalty-tracker', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should render the component', () => {
        const element = createElement('c-royalty-tracker', {
            is: RoyaltyTracker
        });
        document.body.appendChild(element);
        const card = element.shadowRoot.querySelector('lightning-card');
        expect(card).not.toBeNull();
    });

    it('should display the datatable', () => {
        const element = createElement('c-royalty-tracker', {
            is: RoyaltyTracker
        });
        document.body.appendChild(element);
        const datatable = element.shadowRoot.querySelector('lightning-datatable');
        expect(datatable).not.toBeNull();
    });

    it('should filter the datatable based on search input', async () => {
        const mockData = [
            { Id: '1', Name: 'Test Royalty 1', Rate_Per_Unit__c: 100, License__c: 'Test License', Royalty_Type__c: 'Test Type', Total_Views__c: 10, Total_Royality__c: 1000, Status__c: 'Active' },
            { Id: '2', Name: 'Test Royalty 2', Rate_Per_Unit__c: 200, License__c: 'Test License', Royalty_Type__c: 'Test Type', Total_Views__c: 20, Total_Royality__c: 2000, Status__c: 'Active' }
        ];
        getAllRoyalties.mockResolvedValue(mockData);

        const element = createElement('c-royalty-tracker', {
            is: RoyaltyTracker
        });
        document.body.appendChild(element);

        // Wait for the datatable to be rendered
        await Promise.resolve();

        const datatable = element.shadowRoot.querySelector('lightning-datatable');
        expect(datatable.data).toHaveLength(2);

        // Simulate search input
        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = 'Test Royalty 1';
        input.dispatchEvent(new CustomEvent('change'));

        // Wait for the datatable to be filtered
        await Promise.resolve();

        expect(datatable.data).toHaveLength(1);
        expect(datatable.data[0].Name).toBe('Test Royalty 1');
    });
});