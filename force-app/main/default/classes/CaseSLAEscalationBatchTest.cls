@IsTest
public class CaseSLAEscalationBatchTest {

    @TestSetup
    static void setupData() {

        // Account
        Account acc = new Account(Name = 'SLA Test Account');
        insert acc;

        // User Support Manager
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        User mgr = new User(
            Alias = 'mgr',
            Email = 'manager@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Manager',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'Europe/Berlin',
            ProfileId = p.Id,
            UserName = 'manager.' + System.currentTimeMillis() + '@test.com',
            Title = 'Support Manager'
        );
        insert mgr;

        // Case 1 - HIGH priority 
        Case c1 = new Case(
            AccountId = acc.Id,
            Status = 'New',
            Priority = 'High',
            Origin = 'Phone',
            Subject = 'High Priority SLA'
        );
        insert c1;

        // Case 2 - Normal priority
        Case c2 = new Case(
            AccountId = acc.Id,
            Status = 'New',
            Priority = 'Medium',
            Origin = 'Email',
            Subject = 'Normal SLA'
        );
        insert c2;

        // Forzar CreatedDate a más de 4 horas atrás
        Test.setCreatedDate(c1.Id, DateTime.now().addHours(-5));
        Test.setCreatedDate(c2.Id, DateTime.now().addHours(-6));
    }

    // Test principal del Batch
    @IsTest
    static void testBatchExecution() {

        Test.startTest();
        CaseSLAEscalationBatch batch = new CaseSLAEscalationBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Validar resultados
        List<Case> results = [
            SELECT Status, Priority
            FROM Case
            WHERE Status = 'Escalated'
        ];

        System.assertEquals(
            2,
            results.size(),
            'Deben existir 2 casos escalados'
        );

        Boolean foundCritical = false;

        for (Case c : results) {
            if (c.Priority == 'Critical') {
                foundCritical = true;
            }
        }

        System.assert(
            foundCritical,
            'Debe existir al menos un caso CRITICAL'
        );
    }
}