public with sharing class OpportunityTriggerHandler {
    
    public static void beforeInsert(List<Opportunity> newList) {
        OpportunityService.validateEstimatedHours(newList);
        OpportunityService.validateAmount(newList); 
        OpportunityService.markStrategicOpportunities(newList); 
        OpportunityService.validateContactEmail(newList);
    }

    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        OpportunityService.validateAmount(newList); 
        OpportunityService.markStrategicOpportunities(newList); 
        OpportunityService.preventAmountChangeOnWon(newList, oldMap); 
        OpportunityService.validateContactEmail(newList);
    }

    public static void afterInsert(List<Opportunity> newList) {
        OpportunityService.createFollowUpTasks(newList);
    }


}