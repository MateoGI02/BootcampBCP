trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    // 1. Creamos una lista para almacenar las tareas que vamos a crear.
    // Esto es lo que permite que el trigger sea MASIVO (Bulk).
    List<Task> taskList = new List<Task>();

    // 2. Iteramos sobre las oportunidades que activaron el trigger.
    for (Opportunity opp : Trigger.new) {
        
        // 3. Condición: La etapa debe ser 'Closed Won'.
        if (opp.StageName == 'Closed Won') {
            
            // 4. Creamos la instancia de la Tarea con los datos solicitados.
            Task newTask = new Task(
                Subject = 'Follow Up Test Task',
                WhatId = opp.Id // Asociamos la tarea a la oportunidad.
            );
            
            // 5. Agregamos la tarea a la lista (NO la insertamos aquí todavía).
            taskList.add(newTask);
        }
    }

    // 6. Una vez fuera del bucle, verificamos si hay tareas para insertar.
    // Realizamos una única operación DML para todos los registros (Bulkified).
    if (taskList.size() > 0) {
        insert taskList;
    }
}