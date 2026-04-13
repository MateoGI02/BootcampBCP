public without sharing class EscalationLogQueueable implements Queueable {
    private List<EscalationLog__c> logsToInsert;

    public EscalationLogQueueable(List<EscalationLog__c> logs) {
        this.logsToInsert = logs;
    }

    public void execute(QueueableContext context) {
        if (logsToInsert != null && !logsToInsert.isEmpty()) {
            insert logsToInsert;
        }
    }
}