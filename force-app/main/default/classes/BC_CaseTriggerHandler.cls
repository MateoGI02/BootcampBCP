public with sharing class BC_CaseTriggerHandler {
    
    public static void beforeInsert(List<Case> newList) {
        BC_CaseTriggerHelper.syncDescriptionByPriority(newList);
    }

    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) {
        BC_CaseTriggerHelper.syncDescriptionByPriority(newList);
    }
}