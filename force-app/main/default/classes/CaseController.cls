public with sharing class CaseController {
    // Obtiene todas las cuentas para el combobox del padre
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account ORDER BY Name];
    }

    // Obtiene casos: relacionados, abiertos y de este año
    @AuraEnabled(cacheable=true)
    public static List<Case> getOpenCasesByAccount(Id accountId) {
        Integer currentYear = Date.today().year();
        return [
            SELECT Id, CaseNumber, Subject, CreatedDate, Status
            FROM Case
            WHERE AccountId = :accountId 
            AND IsClosed = false 
            AND CALENDAR_YEAR(CreatedDate) = :currentYear
            ORDER BY CreatedDate DESC
        ];
    }
}