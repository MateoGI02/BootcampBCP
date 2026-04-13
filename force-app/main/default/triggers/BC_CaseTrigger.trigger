trigger BC_CaseTrigger on Case (before insert, before update) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            BC_CaseTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            BC_CaseTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}