import { createElement } from '@lwc/engine-dom';
import ContentList from 'c/contentList';

describe('c-content-list', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should render the component', () => {
        const element = createElement('c-content-list', {
            is: ContentList
        });
        document.body.appendChild(element);

        const card = element.shadowRoot.querySelector('lightning-card');
        expect(card).not.toBeNull();
    });

    it('should display the content list with correct columns and data', () => {
        const element = createElement('c-content-list', {
            is: ContentList
        });
        document.body.appendChild(element);

        const datatable = element.shadowRoot.querySelector('lightning-datatable');
        expect(datatable).not.toBeNull();
        expect(datatable.columns).toHaveLength(6);
        expect(datatable.data).toHaveLength(3);
        expect(datatable.data[0].Title__c).toBe('Movie 1');
        expect(datatable.data[1].Title__c).toBe('Movie 2');
        expect(datatable.data[2].Title__c).toBe('Movie 3');
    });

    it('should filter content list based on search input', async () => {
        const element = createElement('c-content-list', {
            is: ContentList
        });
        document.body.appendChild(element);

        const input = element.shadowRoot.querySelector('lightning-input');
        const datatable = element.shadowRoot.querySelector('lightning-datatable');

        input.value = 'Movie 2';
        input.dispatchEvent(new CustomEvent('change'));

        await Promise.resolve();

        expect(datatable.data).toHaveLength(1);
        expect(datatable.data[0].Title__c).toBe('Movie 2');
    });
});