public with sharing class OpportunityService {
    

    public static void validateEstimatedHours(List<Opportunity> oppList) {
        for (Opportunity opp : oppList) {
            if (opp.Estimated_Hours__c == null) {
                opp.Estimated_Hours__c.addError('Las horas estimadas son obligatorias para crear una oportunidad.');
            } 
            else if (opp.Estimated_Hours__c <= 0) {
                opp.Estimated_Hours__c.addError('Las horas estimadas deben ser mayores a cero.');
            }
        }
    }

    public static void validateAmount(List<Opportunity> newList) {
        for (Opportunity opp : newList) {
            if (opp.Amount == null || opp.Amount <= 0) {
                opp.Amount.addError('El monto debe ser mayor a 0.');
            }
        }
    }

    public static void markStrategicOpportunities(List<Opportunity> newList) {
        for (Opportunity opp : newList) {
            if (opp.Amount != null && opp.Amount >= 100000 && String.isBlank(opp.Description)) {
                opp.Description = 'Oportunidad estratégica';
            }
        }
    }

    public static void preventAmountChangeOnWon(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        for (Opportunity opp : newList) {
            Opportunity oldOpp = oldMap.get(opp.Id);
          
            if (oldOpp.StageName == 'Closed Won' && opp.Amount != oldOpp.Amount) {
                opp.Amount.addError('No se puede modificar el monto de una oportunidad ya ganada.');
            }
        }
    }

    public static void createFollowUpTasks(List<Opportunity> newList) {
        List<Task> tasksToInsert = new List<Task>();

        for (Opportunity opp : newList) {

            if (opp.Amount != null && opp.Umbral_Seguimiento__c != null) {
                
                if (opp.Amount > opp.Umbral_Seguimiento__c) {
                    Task newTask = new Task();
                    newTask.Subject = 'Seguimiento a oportunidad estratégica: ' + opp.Name;
                    newTask.WhatId = opp.Id; 
                    newTask.OwnerId = opp.OwnerId; 
                    newTask.Priority = 'High';
                    newTask.Status = 'Not Started';
                    newTask.ActivityDate = Date.today().addDays(1);
                    
                    tasksToInsert.add(newTask);
                }
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public static void validateContactEmail(List<Opportunity> newOpps) {
        Set<Id> contactIds = new Set<Id>();
        for (Opportunity opp : newOpps) {
            if (opp.Contact__c != null) {
                contactIds.add(opp.Contact__c);
            }
        }

        if (contactIds.isEmpty()) {
            return;
        }

        Map<Id, Contact> contactsMap = new Map<Id, Contact>(
            [SELECT Id, Email FROM Contact WHERE Id IN :contactIds]
        );

        List<String> invalidExtensions = new List<String>{
            '@gail.com', 
            '@gmail.co', 
            '@outlook.e', 
            '@outlok.es'
        };

        for (Opportunity opp : newOpps) {
            if (opp.Contact__c != null && contactsMap.containsKey(opp.Contact__c)) {
                String contactEmail = contactsMap.get(opp.Contact__c).Email;

                if (String.isBlank(contactEmail)) {
                    opp.addError('El Contacto asociado a la Opportunity debe tener un correo electrónico.');
                    continue;
                }

                String emailLower = contactEmail.toLowerCase();
                Boolean hasInvalidExtension = false;
                
                for (String invalidExt : invalidExtensions) {
                    if (emailLower.endsWith(invalidExt)) {
                        hasInvalidExtension = true;
                        break;
                    }
                }

                if (hasInvalidExtension) {
                    opp.addError('El correo del Contacto asociado tiene una extensión inválida reconocida (ej. gail.com). Por favor, corrígelo en el registro del Contacto antes de crear la Opportunity.');
                }
            }
        }
    }
}