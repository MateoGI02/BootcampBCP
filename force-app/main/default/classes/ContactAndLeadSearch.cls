public with sharing class ContactAndLeadSearch {
    /**
     * Busca contactos y candidatos que coincidan con la cadena proporcionada.
     * @param searchWord Palabra o nombre a buscar en los registros.
     * @return Una lista de listas de sObjects (Contactos y Candidatos).
     */
    public static List<List<sObject>> searchContactsAndLeads(String searchWord) {
        
        // SOSL busca la cadena en todos los campos de nombre (NAME FIELDS) 
        // y devuelve los campos especificados para cada objeto
        List<List<sObject>> searchList = [
            FIND :searchWord IN NAME FIELDS 
            RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)
        ];

        return searchList;
    }
}