public with sharing class AccountTriggerHandler {   
    public static void beforeInsert(List<Account> newList) {
        AccountService.validatePriority(newList);
        AccountService.checkVipStatus(newList);
    }
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {       
        AccountService.validatePriority(newList);
        AccountService.validateIndustryChangeForVip(newList, oldMap);
        AccountService.checkVipStatus(newList);
    }
    public static void afterInsert(List<Account> newList) {
        AccountService.createVipTasks(newList);
    }
}