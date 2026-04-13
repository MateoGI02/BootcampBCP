public with sharing class AccountHandler {
    /**
     * Inserta una nueva cuenta con el nombre proporcionado.
     * @param accountName El nombre que se asignará a la cuenta.
     * @return El registro de la Cuenta si tiene éxito; null si ocurre un error DML.
     */
    public static Account insertNewAccount(String accountName) {
        try {
            // Creamos la instancia de la cuenta con el parámetro recibido
            Account newAcc = new Account(Name = accountName);
            
            // Intentamos insertar el registro en Salesforce
            insert newAcc;
            
            // Si la inserción es exitosa, retornamos el objeto completo
            return newAcc;
            
        } catch (DmlException e) {
            // Si el nombre es una cadena vacía o falla la validación, 
            // capturamos el error y devolvemos nulo
            System.debug('Se produjo un error DML: ' + e.getMessage());
            return null;
        }
    }
}