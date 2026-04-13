@isTest
private class TaskUtilTests {

    @isTest
    static void testGetTaskPriorityNormal() {
        // GIVEN: Un estado que no es CA
        String inputState = 'NY';
        
        Test.startTest();
        String priority = TaskUtil.getTaskPriority(inputState);
        Test.stopTest();
        
        // THEN: Validamos el resultado
        System.assertEquals('Normal', priority, 'La prioridad debería ser Normal para estados distintos a CA');
    }

    @isTest
    static void testGetTaskPriorityHigh() {
        // GIVEN: El estado de California
        String inputState = 'CA';
        
        Test.startTest();
        String priority = TaskUtil.getTaskPriority(inputState);
        Test.stopTest();
        
        // THEN: Validamos el resultado
        System.assertEquals('High', priority, 'La prioridad debería ser High para el estado CA');
    }

    @isTest
    static void testGetTaskPriorityInvalid() {
        // GIVEN: Una entrada que supera los 2 caracteres
        String inputState = 'CAL';
        
        Test.startTest();
        String priority = TaskUtil.getTaskPriority(inputState);
        Test.stopTest();
        
        // THEN: Validamos que retorne null por la validación de longitud
        System.assertEquals(null, priority, 'La prioridad debería ser null para entradas de más de 2 caracteres');
    }
}