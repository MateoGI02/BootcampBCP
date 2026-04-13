public with sharing class TaskUtil {
    public static String getTaskPriority(String leadState) {
        // Validar entrada
        if(String.isBlank(leadState) || leadState.length() > 2) {
            return null;
        }
        
        String taskPriority;
        if(leadState == 'CA') {
            taskPriority = 'High';
        } else {
            taskPriority = 'Normal';
        }
        return taskPriority;
    }
}