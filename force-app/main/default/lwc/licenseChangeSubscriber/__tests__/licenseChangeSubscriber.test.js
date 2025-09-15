import { createElement } from 'lwc';
import LicenseChangeSubscriber from 'c/licenseChangeSubscriber';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import getLicensesForContent from '@salesforce/apex/LicenseController.getLicensesForContent';

// Mock the Apex method
jest.mock('@salesforce/apex/LicenseController.getLicensesForContent', () => ({
    default: jest.fn()
}), { virtual: true });

describe('c-license-change-subscriber', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should render the component in new mode', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });
        element.recordId = '000001';
        element.isNew = true;

        // Act
        document.body.appendChild(element);

        // Assert
        const contentDiv = element.shadowRoot.querySelector('.content');
        expect(contentDiv).not.toBeNull();
        expect(contentDiv.textContent).toContain('New Mode');
    });

    it('should render the component in edit mode', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });
        element.recordId = '000001';
        element.isNew = false;

        // Act
        document.body.appendChild(element);

        // Assert
        const contentDiv = element.shadowRoot.querySelector('.content');
        expect(contentDiv).not.toBeNull();
        expect(contentDiv.textContent).toContain('Edit Mode');
    });

    it('should show an error when the API name is invalid', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });
        element.recordId = '000001';
        element.isNew = true;

        // Act
        document.body.appendChild(element);
        element.apiName = 'Invalid API Name';

        // Assert
        const errorDiv = element.shadowRoot.querySelector('.error');
        expect(errorDiv).not.toBeNull();
        expect(errorDiv.textContent).toContain('Invalid API Name');
    });

    it('should show an error when the URL is not valid', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });
        element.recordId = '000001';
        element.isNew = true;

        // Act
        document.body.appendChild(element);
        element.url = 'invalid-url';

        // Assert
        const errorDiv = element.shadowRoot.querySelector('.error');
        expect(errorDiv).not.toBeNull();
        expect(errorDiv.textContent).toContain('Invalid URL');
    });

    it('should display default values on initial load', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });

        // Act
        document.body.appendChild(element);

        // Assert
        const contentDiv = element.shadowRoot.querySelector('.content');
        expect(contentDiv).not.toBeNull();
        expect(contentDiv.textContent).toContain('Default Values');
    });

    it('should handle license changes and update the UI accordingly', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });

        // Mock the license data loading function
        getLicensesForContent.mockResolvedValue({
            Id: '000002',
            Name: 'Updated License',
            Status__c: 'Active',
            Region__c: 'EU'
        });

        // Act
        document.body.appendChild(element);

        // Simulate a license change event
        const changeEvent = {
            data: {
                payload: {
                    ChangeEventHeader: {
                        recordIds: ['000002']
                    }
                }
            }
        };
        element.handleLicenseChange(changeEvent);

        // Assert
        const contentDiv = element.shadowRoot.querySelector('.content');
        expect(contentDiv).not.toBeNull();
        expect(contentDiv.textContent).toContain('Updated License');
        expect(contentDiv.textContent).toContain('Active');
        expect(contentDiv.textContent).toContain('EU');
    });

    it('should handle errors during license data loading', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });

        // Mock the license data loading function to return an error
        getLicensesForContent.mockRejectedValue(new Error('Failed to load license data'));

        // Act
        document.body.appendChild(element);

        // Simulate a license change event
        const changeEvent = {
            data: {
                payload: {
                    ChangeEventHeader: {
                        recordIds: ['000002']
                    }
                }
            }
        };
        element.handleLicenseChange(changeEvent);

        // Assert
        const errorDiv = element.shadowRoot.querySelector('.error');
        expect(errorDiv).not.toBeNull();
        expect(errorDiv.textContent).toContain('Failed to load license data');
    });

    it('should handle subscription errors', () => {
        // Arrange
        const element = createElement('c-license-change-subscriber', {
            is: LicenseChangeSubscriber
        });

        // Mock the subscription function to return an error
        subscribe.mockImplementation((channel, replayId, callback) => {
            callback({
                data: {
                    payload: {
                        ChangeEventHeader: {
                            recordIds: ['000002']
                        }
                    }
                }
            });
            return Promise.reject(new Error('Failed to subscribe'));
        });

        // Act
        document.body.appendChild(element);

        // Assert
        const errorDiv = element.shadowRoot.querySelector('.error');
        expect(errorDiv).not.toBeNull();
        expect(errorDiv.textContent).toContain('Failed to subscribe');
    });
});