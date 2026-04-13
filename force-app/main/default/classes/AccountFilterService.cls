public class AccountFilterService {
    
    public List<Account> filterAccounts(List<Account> accountList, Decimal minimumRevenue) {
        
        List<Account> filteredAccounts = new List<Account>();
        
        for (Account acc : accountList) {

            if (acc.AnnualRevenue != null && acc.AnnualRevenue > minimumRevenue) {
                filteredAccounts.add(acc);
            }
        }
        
        return filteredAccounts;
    }
}