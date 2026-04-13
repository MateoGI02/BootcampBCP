import { LightningElement } from 'lwc';

export default class OpportunityParent extends LightningElement {
    selectedStage = '';
    selectedOppName = '';

    stageOptions = [
        { label: 'Prospecting', value: 'Prospecting' },
        { label: 'Qualification', value: 'Qualification' },
        { label: 'Needs Analysis', value: 'Needs Analysis' },
        { label: 'Value Proposition', value: 'Value Proposition' },
        { label: 'Negotiation/Review', value: 'Negotiation/Review' }
    ];

    handleStageChange(event) {
        this.selectedStage = event.detail.value;
        this.selectedOppName = '';
    }

    handleRowSelected(event) {
        this.selectedOppName = event.detail.oppName;
    }
}