/**
 * @author Support
 * @date 
 *
 * @description caseClose
 */

import {LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
//import multilineToastCSS from '@salesforce/resourceUrl/multilineToastCSS';
import CASE_RESOLUTION from '@salesforce/schema/Case.UPF_CaseResolution__c';
import CASE_SUBTYPE from '@salesforce/schema/Case.UPF_CaseSubtype__c';
import STATUS from '@salesforce/schema/Case.Status';
import RESOLUTION_DESCRIPTION from '@salesforce/schema/Case.UPF_CaseResolutionDescription__c';

import save from '@salesforce/label/c.Case_Save';
import closeCase from '@salesforce/label/c.Case_Close_Card_Title';
import completeThisField from '@salesforce/label/c.Case_Complete_Field';
import caseResolutionLabel from '@salesforce/label/c.Case_Resolution_Label';
import none_Option from '@salesforce/label/c.None_Option';

const FIELDS = [CASE_RESOLUTION, CASE_SUBTYPE, RESOLUTION_DESCRIPTION, STATUS];

export default class CaseClose extends LightningElement {
    label = {
        save,
        closeCase,
        completeThisField,
        caseResolutionLabel,
        none_Option
    };

    fields = {
        CASE_RESOLUTION,
        RESOLUTION_DESCRIPTION,
        CASE_SUBTYPE
    };

    @track errorVisibility = {
        [CASE_RESOLUTION.fieldApiName]: false,
        [RESOLUTION_DESCRIPTION.fieldApiName]: false
    };

    caseResolution;
    @track caseResolutionOptions = [];

    STATUS_CLOSED = 'Closed';

    @api recordId;
    @track recordTypeId;

    @track isSpinnerShown = false;
    @track isClosed = false;
    case;
    picklistValues;

  /*  renderedCallback() {
        loadStyle(this, multilineToastCSS);
    }*/

    onLoad(event) {
        let caseRecord = event.detail.records[this.recordId];
        let newRecordType = caseRecord.recordTypeInfo.recordTypeId;

        this.recordTypeId = newRecordType;

        this.isClosed = caseRecord.fields.Status === this.STATUS_CLOSED;

        if (!this.caseResolution) {
            this.caseResolution = caseRecord.fields.UPF_CaseResolution__c.value;
        }

        this.case = caseRecord;

        if (!this.recordTypeId || this.recordTypeId !== newRecordType) {
            this.recordTypeId = newRecordType;
        }

        if (event.detail.picklistValues) {
            this.picklistValues = event.detail.picklistValues;
            this.populateCaseResolutionOptions();
        }
    }

    populateCaseResolutionOptions() {
        if (this.case && this.picklistValues) {
            let resolutionPicklistValues = this.picklistValues.UPF_CaseResolution__c;
            let caseResolutionOptions = [];
            let oldCaseResolutionOptions = caseResolutionOptions;
            let subType = this.case.fields.UPF_CaseSubtype__c.value;

            let controllingValue = resolutionPicklistValues.controllerValues[subType];

            resolutionPicklistValues.values.forEach(pv => {
                if (pv.validFor.includes(controllingValue)) {
                    caseResolutionOptions.push(pv);
                }
            });

            if (!this.compareArrays(this.caseResolutionOptions, caseResolutionOptions)) {
                this.caseResolutionOptions = caseResolutionOptions;
            }
        }
    }

    compareArrays(firstArray, secondArray) {
        let areEqualLength = firstArray && secondArray && firstArray.length === secondArray.length;

        if (areEqualLength) {
            let areEqual = true;
            for (let i = 0, l = firstArray.length; i < l; i++) {
                if (firstArray[i].value !== secondArray[i].value) {
                    areEqual = false;
                    break;
                }
            }

            return areEqual;
        }

        return areEqualLength;
    }

    populateCaseResolution(event) {
        this.caseResolution = event.target.value;
    }

    handleSubmit(event) {
        this.showSpinner();
        event.preventDefault();

        let hasErrors = false;

        let inputCmps = this.template.querySelectorAll("lightning-input-field");

        hasErrors = this.checkIfErrorsExist(inputCmps);

        this.errorVisibility[CASE_RESOLUTION.fieldApiName] = !this.caseResolution;
        hasErrors = hasErrors && !this.caseResolution;

        if (hasErrors) {
            this.hideSpinner();
            return;
        }

        const fields = event.detail.fields;
        fields.Status = this.STATUS_CLOSED;
        fields.UPF_CaseResolution__c = this.caseResolution;
        delete fields.UPF_CaseSubtype__c;

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    checkIfErrorsExist(inputCmps) {
        let hasErrors = false;
        inputCmps.forEach(cmp => {
            if(cmp.fieldName !== CASE_RESOLUTION.fieldApiName) {
                this.errorVisibility[cmp.fieldName] = !cmp.value;

                if(!cmp.value) {
                    hasErrors = true;
                }
            }
        });

        return hasErrors;
    }

    get hasResolutionError() {
        return this.errorVisibility[CASE_RESOLUTION.fieldApiName];
    }

    get hasResolutionDescError() {
        return this.errorVisibility[RESOLUTION_DESCRIPTION.fieldApiName];
    }

    handleError(event) {
        this.hideSpinner();
        const msg = event.detail.detail;
        this.showToast(msg, false);
    }

    handleSuccess(event) {
        this.hideSpinner();
    }

    showToast(message, isSuccess) {
        const isInfo = isSuccess === null;
        const evt = new ShowToastEvent({
            title: isInfo ? 'Info' : isSuccess ? 'Success' : 'Error',
            message: message,
            variant: isInfo ? 'info' : isSuccess ? 'success' : 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showSpinner() {
        this.isSpinnerShown = true;
    }

    hideSpinner() {
        this.isSpinnerShown = false;
    }
}