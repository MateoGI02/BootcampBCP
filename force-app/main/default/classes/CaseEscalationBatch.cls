public without sharing class CaseEscalationBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Escenario "Boundary": Usamos <= para que sea inclusivo (exactamente 48h o más)
        DateTime threshold = System.now().addHours(-48);
        
        // Escenario "Negative": Filtramos por Status = 'Open'
        // Esto garantiza que Casos 'Closed' o ya 'Escalated' NO se procesen.
        return Database.getQueryLocator([
            SELECT Id, Status, OwnerId 
            FROM Case 
            WHERE Status = 'Open'   //Aqui se excluye aquellos con status no open (los negative)
            AND CreatedDate <= :threshold //Se incuye el boundary y happy path 
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        CaseService.escalateCases(scope);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch de Escalación finalizado exitosamente.');
    }
}