public class AccountSegmentationService {
    
    public String getSegmentation(Account acc) {
        
        Decimal revenue = acc.AnnualRevenue != null ? acc.AnnualRevenue : 0;
        
        if (revenue >= 1000000) {
            return 'Premium';
        } else if (revenue >= 100000) {
            return 'Gold';
        } else {
            return 'Standard';
        }
    }
    
}