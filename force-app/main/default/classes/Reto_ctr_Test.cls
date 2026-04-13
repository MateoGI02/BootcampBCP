@IsTest
public class Reto_ctr_Test {

    //Test ENTERPRISE + descuento completo
    @IsTest
    static void testBuildEnterpriseSegment() {

        Account acc = Apex_TestDataFactory.createAccountWithData(
            1200000, 
            60       
        );

        Test.startTest();
        String result = Reto_ctr.build(acc.Id, 25000);
        Test.stopTest();

        System.assertEquals('ENTERPRISE|0.12', result,
            'Debe retornar ENTERPRISE con 12% de descuento');
    }

    // Test MID segment + descuento parcial
    @IsTest
    static void testBuildMidSegment() {

        Account acc = Apex_TestDataFactory.createAccountWithData(
            300000, 
            10
        );

        Test.startTest();
        String result = Reto_ctr.build(acc.Id, 15000);
        Test.stopTest();

        System.assertEquals('MID|0.00', result,
            'Debe retornar MID sin descuento');
    }

    // Test SMB sin descuento
    @IsTest
    static void testBuildSmbSegment() {

        Account acc = Apex_TestDataFactory.createAccountWithData(
            100000,
            5
        );

        Test.startTest();
        String result = Reto_ctr.build(acc.Id, 5000);
        Test.stopTest();

        System.assertEquals('SMB|0.00', result,
            'Debe retornar SMB sin descuento');
    }

    // Test descuento por revenue solamente
    @IsTest
    static void testDiscountByRevenueOnly() {

        Account acc = Apex_TestDataFactory.createAccountWithData(
            600000, 
            10
        );

        Test.startTest();
        String result = Reto_ctr.build(acc.Id, 5000);
        Test.stopTest();

        System.assertEquals('MID|0.02', result,
            'Debe aplicar solo descuento por revenue');
    }

    // Test valores nulos y negativos
    @IsTest
    static void testNullAndNegativeValues() {

        Account acc = new Account(Name = 'Null Test');
        insert acc;

        Test.startTest();
        String result = Reto_ctr.computeSummary(acc, -1000);
        Test.stopTest();

        System.assertEquals('SMB|0.00', result,
            'Debe manejar valores nulos y negativos');
    }
}