public class ProyectoService {

    // Método para insertar un nuevo proyecto
    public static Proyecto__c crearProyecto(String nombre, Decimal presupuesto) {
        Proyecto__c nuevoP = new Proyecto__c();
        // Usamos .Name porque así aparece en tu configuración
        nuevoP.Name = nombre; 
        nuevoP.Presupuesto__c = presupuesto;
        nuevoP.Estado__c = 'Planificado';
        
        insert nuevoP;
        return nuevoP;
    }

    // Método para buscar proyectos por presupuesto mínimo usando SOQL
    public static List<Proyecto__c> buscarPorPresupuesto(Decimal minimo) {
        // Eliminamos Proyecto_Name__c de la consulta porque no existe
        return [SELECT Name, Presupuesto__c, Estado__c 
                FROM Proyecto__c 
                WHERE Presupuesto__c >= :minimo 
                ORDER BY Presupuesto__c DESC];
    }
}