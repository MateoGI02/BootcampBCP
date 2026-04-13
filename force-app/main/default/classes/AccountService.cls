public with sharing class AccountService {
    
    public static void validatePriority(List<Account> newList) {
        for (Account acc : newList) {
            if (String.isBlank(acc.Priority__c)) {
                //acc.Priority__c.addError('El campo Prioridad es obligatorio.');
            }
        }
    }
    
    public static void checkVipStatus(List<Account> accountList) {
        for (Account acc : accountList) {
            if (acc.AnnualRevenue != null && acc.AnnualRevenue > 1000000) {
                acc.Type = 'VIP';
            }
        }
    }

    public static void validateIndustryChangeForVip(List<Account> newList, Map<Id, Account> oldMap) {
        for (Account acc : newList) {
            Account oldAcc = oldMap.get(acc.Id);

            if (oldAcc.Type == 'VIP' && acc.Industry != oldAcc.Industry) {
                acc.Industry.addError('No se puede cambiar la Industria de una cuenta VIP.');
            }
        }
    }

    public static void createVipTasks(List<Account> newList) {
        List<Task> tasksToInsert = new List<Task>();
        
        for (Account acc : newList) {
            if (acc.AnnualRevenue != null && acc.AnnualRevenue > 1000000) {
                Task t = new Task();
                t.Subject = 'Seguimiento a nueva cuenta VIP ' + acc.Name;
                t.WhatId = acc.Id;
                t.Priority = 'High';
                t.Status = 'Not Started';
                t.ActivityDate = Date.today().addDays(2);   
                tasksToInsert.add(t);
            }
        }
        
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}