public with sharing class OpportunityComponentController {
    public Id accountId { get; set; }

    public List<Opportunity> getOpportunities {
        get {
            if (accountId == null) {
                return new List<Opportunity>();
            }

            return [
                SELECT Name, Amount, CloseDate, StageName 
                FROM Opportunity 
                WHERE AccountId = :accountId 
                AND Amount > 100
                WITH USER_MODE
                ORDER BY CreatedDate DESC
            ];
        }
        set;
    }

    public Integer getTotalOpps {
        get {
            return getOpportunities.size();
        }
        set;
    }
}