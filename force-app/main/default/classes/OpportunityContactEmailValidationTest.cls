@IsTest
private class OpportunityContactEmailValidationTest {

    // Contact sin email
    @IsTest
    static void givenContactNoEmail_whenOppInserted_thenThrowError() {
        // GIVEN
        Contact con = new Contact(
            LastName = 'Test No Email',
            Email = null 
        );
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Opp BDD No Email',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Contact__c = con.Id 
        );

        // WHEN
        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            insert opp;
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 
                'BDD FAIL: El error debe ser de validación');
            }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 
            'BDD FAIL: El sistema debió bloquear la creación de la Opportunity porque el Contact no tiene email.');
    }

    //Contact con email inválido/espacios
    @IsTest
    static void givenContactInvalidEmail_whenOppInserted_thenThrowError() {
        Contact con = new Contact(
            LastName = 'Test Invalid Email',
            Email = 'test@gail.com' 
        );
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Opp BDD Invalid Email',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Contact__c = con.Id
        );

        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            insert opp;
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 
            'BDD FAIL: El sistema debió bloquear la creación de la Opportunity por extensión de correo inválida.');
    }

    // Contact con email válido 
    @IsTest
    static void givenContactValidEmail_whenOppInserted_thenSuccess() {
        Contact con = new Contact(
            LastName = 'Test Valid Email',
            Email = 'test@empresa.com'
        );
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Opp BDD Success',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Contact__c = con.Id
        );

        Test.startTest();
        insert opp; 
        Test.stopTest();

        System.assertNotEquals(null, opp.Id, 
            'BDD FAIL: La Opportunity debió guardarse exitosamente ya que el Contact tiene un email válido.');
    }
}