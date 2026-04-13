trigger OpportunityTrigger on Opportunity (before insert, before update, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        OpportunityTriggerHandler.afterInsert(Trigger.new);
    }
}