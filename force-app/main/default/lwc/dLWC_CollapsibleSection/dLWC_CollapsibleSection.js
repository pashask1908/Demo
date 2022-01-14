import { LightningElement, track, wire } from 'lwc';
// importing apex class method to get the accounts
import getAccounts  from '@salesforce/apex/DLWC_CollapsibleSection.getAccounts';
// imported to show toast messages
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class DLWC_Collapsible extends LightningElement {
    @track accounts;

    // wire service to fetch the slesforce account data
    @wire(getAccounts)
    wiredAccount({ error, data }) {
        if(data) {
            this.accounts = data;
            this.error = undefined;
        }
        else if(error) {
            this.error = error;
            this.accounts = undefined;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        }
    }
}