global class CaseSLAEscalationBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer escalatedCount = 0;
    global Integer criticalCount = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        DateTime slaLimit = DateTime.now().addHours(-4);
        return Database.getQueryLocator([
                                            SELECT Id, Status, Priority FROM Case
                                            WHERE Status = 'New' AND CreatedDate < :slaLimit AND IsClosed = false
                                    ]);
    }

    global void execute(Database.BatchableContext bc, List<Case> cases) {
        List<Case> toUpdate = new List<Case>();
        for (Case c : cases) {
            c.Status = 'Escalated';

            if (c.Priority == 'High') { 
                c.Priority = 'Critical'; 
                criticalCount++; 
            }

            escalatedCount++;
            toUpdate.add(c);
        }
        update toUpdate;
    }

    global void finish(Database.BatchableContext bc) {
        if (criticalCount > 0) {
            User mgr = [SELECT Email FROM User WHERE Title = 'Support Manager' AND IsActive = true LIMIT 1];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ mgr.Email });
            mail.setSubject('SLA Breach: ' + criticalCount + ' críticos');
            mail.setPlainTextBody(escalatedCount + ' escalados.');
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        }
    }
}