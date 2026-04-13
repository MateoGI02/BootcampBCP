public with sharing class ContactController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchKey) {
        if (String.isBlank(searchKey)) {
            return new List<Contact>();
        }

        String key = searchKey + '%';
        
        return [
            SELECT Id, Name, Email, Phone 
            FROM Contact 
            WHERE Name LIKE :key 
            WITH SECURITY_ENFORCED
            ORDER BY LastName 
            LIMIT 20
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getRecentContactsWithAccounts() {
        return [
            SELECT Id, Name, Title, Phone, Email, Account.Name, LeadSource 
            FROM Contact 
            WHERE AccountId != null 
            AND CreatedDate = THIS_MONTH
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
        ];
    }
}