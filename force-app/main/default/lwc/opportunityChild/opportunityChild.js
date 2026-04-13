import { LightningElement, api, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Nombre Oportunidad', fieldName: 'Name', editable: true },
    // Aplanamos el campo Account.Name en JS como 'AccountName' para que el datatable lo lea
    { label: 'Nombre de la Cuenta', fieldName: 'AccountName', editable: false },
    { label: 'Estado', fieldName: 'StageName', editable: true },
    { label: 'Fecha de Creación', fieldName: 'CreatedDate', type: 'date', editable: false },
    { label: 'Probabilidad (%)', fieldName: 'Probability', type: 'number', editable: true }
];

export default class OpportunityChild extends LightningElement {
    @api selectedStage; 
    columns = COLUMNS;
    
    @track opportunities;
    error;
    draftValues = [];
    wiredOppsResult;

    @wire(getOpportunities, { stageName: '$selectedStage' })
    wiredOpportunities(result) {
        this.wiredOppsResult = result;
        const { data, error } = result;
        
        if (data) {
            this.opportunities = data.map(record => {
                return {
                    ...record,
                    AccountName: record.Account ? record.Account.Name : 'Sin Cuenta'
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.opportunities = undefined;
        }
    }

    // Dispara el Custom Event hacia el padre cuando se selecciona un registro
    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        if (selectedRows.length > 0) {
            const oppName = selectedRows[0].Name;
            
            const customEvent = new CustomEvent('rowselected', {
                detail: { oppName: oppName }
            });
            this.dispatchEvent(customEvent);
        }
    }

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;

        const promises = updatedFields.map(draft => {
            const fields = Object.assign({}, draft);
            return updateRecord({ fields });
        });

        try {
            await Promise.all(promises);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Éxito',
                    message: 'Oportunidades actualizadas correctamente',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            return refreshApex(this.wiredOppsResult);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error al actualizar',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}