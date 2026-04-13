trigger AccountTrigger on Account (before insert, before update, after insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
    }
}