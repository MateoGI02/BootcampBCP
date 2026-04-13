public with sharing class bootcampController {
    @AuraEnabled(cacheable=true)
    public static List<Request__c> getRequest() {
        try {
            return [
                SELECT Id, Name, Status__c, Subject__c, Priority__c, Due_Date__c, Description__c, Requester__c, OwnerId 
                FROM Request__c 
                ORDER BY CreatedDate DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching requests: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateRequests(List<Request__c> recordsToUpdate) {
        try {
            update recordsToUpdate;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating requests: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteRequest(Id recordId) {
        try {
            // Creamos una referencia en memoria con el ID y la borramos
            Request__c recordToDelete = new Request__c(Id = recordId);
            delete recordToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting request: ' + e.getMessage());
        }
    }
}