import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getRequest from '@salesforce/apex/bootcampController.getRequest';
import updateRequests from '@salesforce/apex/bootcampController.updateRequests';
import deleteRequest from '@salesforce/apex/bootcampController.deleteRequest';
import USER_ID from '@salesforce/user/Id';

const COLUMNS = [
    { label: 'Subject', fieldName: 'Subject__c', type: 'text', editable: true },
    { label: 'Status', fieldName: 'Status__c', type: 'text', editable: true },
    { label: 'Priority', fieldName: 'Priority__c', type: 'text', editable: true },
    { label: 'Due Date', fieldName: 'Due_Date__c', type: 'date', editable: true },
    { label: 'Description', fieldName: 'Description__c', type: 'text', editable: true },
    { label: 'Requester', fieldName: 'Requester__c', type: 'text' }, 
    { label: 'Owner ID', fieldName: 'OwnerId', type: 'text' },
    { type: 'action', typeAttributes: { rowActions: actions }}
];

const actions = [
    { label: 'Delete', name: 'delete' }
];

export default class BootcampCRUD extends LightningElement {
    columns = COLUMNS;
    data = [];
    error;
    wiredResult;
    
    @track isModalOpen = false;
    @track draftValues = []; 
    currentUserId = USER_ID;

    @wire(getRequest)
    wiredRequests(result) {
        this.wiredResult = result;
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = [];
        }
    }

    openModal() { this.isModalOpen = true; }
    closeModal() { this.isModalOpen = false; }
    
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        if (fields.Priority__c === 'High' && !fields.Due_Date__c) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error de Validación',
                message: 'Si la prioridad es High, la Fecha de Vencimiento es obligatoria.',
                variant: 'error'
            }));
            return; 
        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.dispatchEvent(new ShowToastEvent({ title: 'Éxito', message: 'Request creada con éxito', variant: 'success' }));
        this.closeModal(); 
        return refreshApex(this.wiredResult); 
    }

    async handleSave(event) {
        const draftValues = event.detail.draftValues;
        let isValid = true;

        for (let i = 0; i < draftValues.length; i++) {
            const draft = draftValues[i];
            
            const originalRecord = this.data.find(record => record.Id === draft.Id);
            nal
            const finalRecord = { ...originalRecord, ...draft };

            if (finalRecord.Priority__c === 'High' && !finalRecord.Due_Date__c) {
                isValid = false;
                break;
            }
        }

        if (!isValid) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error al actualizar',
                message: 'Si cambias la prioridad a High, debes asignar una Fecha de Vencimiento.',
                variant: 'error'
            }));
            return;
        }

        try {
            await updateRequests({ recordsToUpdate: draftValues });
            
            this.dispatchEvent(new ShowToastEvent({
                title: 'Éxito',
                message: 'Registros actualizados correctamente',
                variant: 'success'
            }));
            
            this.draftValues = [];
            return refreshApex(this.wiredResult);
            
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error en la base de datos',
                message: error.body.message,
                variant: 'error'
            }));
        }
    }

    async handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            default:
        }
    }

    async deleteRow(row) {
        try {
            await deleteRequest({ recordId: row.Id });
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Éxito',
                    message: `Request "${row.Subject__c}" eliminada correctamente`,
                    variant: 'success'
                })
            );
            
            return refreshApex(this.wiredResult);
            
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error al eliminar',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}