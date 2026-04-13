@IsTest
private class CaseEscalationBatchTest {

    @IsTest
    static void testDelEjercicio() {
        // GIVEN: 200 casos abiertos y 1 cerrado
        List<Case> testCases = new List<Case>();
        for(Integer i=0; i<200; i++) {
            testCases.add(new Case(Subject = 'Test Bulk ' + i, Status = 'Open'));
        }
        testCases.add(new Case(Subject = 'Test Closed', Status = 'Closed'));
        insert testCases;

        // Simular que fueron creados hace 50 horas
        DateTime fiftyHoursAgo = System.now().addHours(-48);
        for(Case c : testCases) {
            Test.setCreatedDate(c.Id, fiftyHoursAgo);
        }

        // WHEN
        Test.startTest();
        CaseEscalationBatch batch = new CaseEscalationBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest(); 

        // THEN
        List<Case> escalatedCases = [SELECT Id FROM Case WHERE Status = 'Escalated'];
        List<Task> createdTasks = [SELECT Id FROM Task WHERE Subject = 'SLA Breach Review'];
        
        System.assertEquals(200, escalatedCases.size(), 'Deben haberse escalado 200 casos');
        System.assertEquals(200, createdTasks.size(), 'Deben haberse creado 200 tareas');
        
        // Verificar Queueable (Auditoría)
        List<EscalationLog__c> logs = [SELECT Id FROM EscalationLog__c];
        System.assertEquals(200, logs.size(), 'Deben existir 200 logs de auditoría');
    }
}