@IsTest
public class OpportunityTriggerTest {

    @TestSetup
    static void setupData() {
    
        PermissionSet ps = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'PruebaTest'
            LIMIT 1
        ];
    
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];
    
        User u = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'Europe/Berlin',
            ProfileId = p.Id,
            UserName = 'testuser.' + System.currentTimeMillis() + '@example.com'
        );
        insert u;
    
        insert new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );
    }



    //1. Insert con fecha futura
    @IsTest
    static void testInsertFutureDate() {
    
        User u = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
    
        System.runAs(u) {
    
            Account acc = new Account(Name = 'Test Account');
            insert acc;
    
            Opportunity opp = new Opportunity(
                Name = 'Future Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(10),
                AccountId = acc.Id
            );
    
            Test.startTest();
            insert opp;
            Test.stopTest();
    
            System.assertNotEquals(null, opp.Id);
        }
    }


    //2. Insert con fecha pasada
    @IsTest
    static void testInsertPastDateError() {
    
        User u = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
    
        System.runAs(u) {
    
            Account acc = new Account(Name = 'Test Account');
            insert acc;
            
            Opportunity opp = new Opportunity(
                Name = 'Past Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(-1),
                AccountId = acc.Id
            );
    
            Test.startTest();
            try {
                insert opp;
                System.assert(false, 'Debió lanzar error por fecha pasada');
            } catch (DmlException e) {
                System.assert(
                    e.getMessage().contains(
                        'La fecha de cierre no puede ser menor al día de hoy'
                    ),
                    'Debe mostrar mensaje de error correcto'
                );
            }
            Test.stopTest();
        }
    }

    // 3. Update con fecha pasada
    @IsTest
    static void testUpdatePastDateError() {
		User u = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
    
        System.runAs(u) {
            Account acc = new Account(Name = 'Test Account');
            insert acc;
            
            Opportunity opp = new Opportunity(
                Name = 'Update Opp',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(5),
                AccountId = acc.Id
            );
            insert opp;
    
            opp.CloseDate = Date.today().addDays(-3);
    
            Test.startTest();
            try {
                update opp;
                System.assert(false, 'Debió fallar el update');
            } catch (DmlException e) {
                System.assert(
                    e.getMessage().contains('La fecha de cierre no puede ser menor al día de hoy'),
                    'Debe validar fecha pasada en update'
                );
            }
            Test.stopTest();
        }
    }
}