@IsTest
private class OpportunityServiceTest {
    @IsTest
    static void testDeleteOpportunityNoAccess() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(
            Alias = 'noDel', Email='testnodell@test.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testnodell' + DateTime.now().getTime() + '@test.com'
        );

        Opportunity opp = new Opportunity(Name='Test Opp', StageName='Prospecting', CloseDate=Date.today());
        insert opp;

        System.runAs(u) {
            Test.startTest();
            try {
                OpportunityService.deleteOpportunity(opp.Id);
                System.assert(false, 'Debería haber lanzado una AuraHandledException');
            } catch (Exception e) {
                // Validamos que sea el tipo correcto o que el mensaje sea el de sistema
                System.debug('Mensaje real recibido: ' + e.getMessage());
                Boolean isAuraException = e.getTypeName().contains('AuraHandledException');
                Boolean isScriptError = e.getMessage().contains('Script-thrown exception');
                
                System.assert(isAuraException || isScriptError, 'Se esperaba una AuraHandledException');
            }
            Test.stopTest();
        }
    }
}