public with sharing class AccountSearchController {
    public Account cuentaActual { get; set; }
    public List<Contact> contactosRelacionados { get; set; }
    
    public AccountSearchController(ApexPages.StandardController stdController) {
        cuentaActual = new Account();
        contactosRelacionados = new List<Contact>();
    }
    
    public void buscarCuenta() {
        String nombreBuscado = cuentaActual.Name; 
        
        if (String.isNotBlank(nombreBuscado)) {
            List<Account> resultados = [
                SELECT Id, Name, Phone, Website, Industry, Type,
                       (SELECT Name, Email, Phone, Title FROM Contacts)
                FROM Account 
                WHERE Name = :nombreBuscado 
                LIMIT 1
            ];
            
            if (!resultados.isEmpty()) {
                cuentaActual = resultados[0];
                contactosRelacionados = resultados[0].Contacts;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Cuenta cargada correctamente.'));
            } else {
                cuentaActual = new Account(Name = nombreBuscado);
                contactosRelacionados = new List<Contact>();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se encontró la cuenta. Compruebe el nombre.'));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor, ingrese un Account Name antes de buscar.'));
        }
    }
    
    public void guardarCambios() {
        if (cuentaActual != null && cuentaActual.Id != null) {
            try {
                update cuentaActual;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Datos actualizados correctamente.'));
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error al guardar: ' + e.getMessage()));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Primero busque una cuenta válida antes de guardar.'));
        }
    }
}