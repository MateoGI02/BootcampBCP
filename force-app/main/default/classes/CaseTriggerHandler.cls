public with sharing class CaseTriggerHandler {
    
    public static void beforeInsert(List<Case> newList) {
        //CaseService.handleBeforeInsert(newList);
    }

    public static void afterInsert(List<Case> newList) {
        //CaseService.handleAfterInsert(newList);
    }

    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) {
        //CaseService.handleAfterUpdate(newList, oldMap);
    }
}