public without sharing class CaseService {
    
    public static void escalateCases(List<Case> scope) {
        List<Task> tasksToCreate = new List<Task>();
        List<EscalationLog__c> logsToProcess = new List<EscalationLog__c>();

        for (Case c : scope) {
            c.Status = 'Escalated';

            tasksToCreate.add(new Task(
                Subject = 'SLA Breach Review',
                Status = 'Not Started',
                Priority = 'High',
                WhatId = c.Id,
                OwnerId = c.OwnerId
            ));

            logsToProcess.add(new EscalationLog__c(
                CaseId__c = c.Id,
                EscalatedAt__c = System.now(),
                EscalatedBy__c = UserInfo.getUserId()
            ));
        }

        if (!scope.isEmpty()) {
            if (Schema.sObjectType.Case.isUpdateable()) {
                update scope;
            }
            if (Schema.sObjectType.Task.isCreateable()) {
                insert tasksToCreate;
            }
            System.enqueueJob(new EscalationLogQueueable(logsToProcess));
        }
    }
}