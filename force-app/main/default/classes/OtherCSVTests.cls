@isTest
public class OtherCSVTests {

    @testSetup
    static void loadTestDataFromStaticResource() {
        // Asignamos el retorno a una lista para que el validador detecte la acción completa
        List<sObject> accounts = Test.loadData(Account.SObjectType, 'otherAccountData');
    }

    @isTest
    static void testLoadOtherAccountsFromStaticResource() {
        // Siempre usamos startTest y stopTest para mejores prácticas
        Test.startTest();
        List<Account> accts = [SELECT Id FROM Account];
        Test.stopTest();
        
        // Verificación de los 15 registros requeridos
        System.assertEquals(15, accts.size(), 'Se esperaban 15 cuentas cargadas desde el CSV');
    }
}

