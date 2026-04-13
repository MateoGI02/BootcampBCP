public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(String stageName) {
        return [
            SELECT Id, Name, Account.Name, StageName, CreatedDate, Probability
            FROM Opportunity
            WHERE AccountId != null 
            AND Amount < 1000000 
            AND IsClosed = false 
            AND Probability > 10
            AND StageName = :stageName
            WITH USER_MODE
        ];
    }
}