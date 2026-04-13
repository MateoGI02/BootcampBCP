public with sharing class BC_CaseTriggerHelper {
   
    public static void syncDescriptionByPriority(List<Case> newList) {
        for (Case c : newList) {
            if (c.Priority == 'High' && String.isBlank(c.Description)) {
                c.Description = 'Caso de alta prioridad - requiere atención inmediata';
            }
        }
    }
}