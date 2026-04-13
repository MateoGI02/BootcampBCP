public with sharing class ContactSearch {
    /**
     * Busca contactos basados en el apellido y el código postal de envío.
     * @param lastName Apellido a buscar.
     * @param postalCode Código postal de envío (MailingPostalCode).
     * @return Una lista de contactos con los campos Id y Name.
     */
    public static List<Contact> searchForContacts(String lastName, String postalCode) {
        
        // Realizamos la consulta SOQL con los filtros solicitados
        List<Contact> contactList = [
            SELECT Id, Name 
            FROM Contact 
            WHERE LastName = :lastName 
            AND MailingPostalCode = :postalCode
        ];

        // Retornamos la lista de resultados
        return contactList;
    }
}