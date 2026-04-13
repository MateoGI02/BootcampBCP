trigger CaseTrigger on Case (before insert, after insert, after update) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.beforeInsert(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.afterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            CaseTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}