trigger AccountAddressTrigger on Account (before insert, before update) {
    // Iteramos sobre los registros que están entrando al sistema
    for (Account acc : Trigger.new) {
        
        // Verificamos si la casilla Match_Billing_Address__c está marcada
        // Y nos aseguramos de que el código postal de facturación no esté vacío
        if (acc.Match_Billing_Address__c == true && acc.BillingPostalCode != null) {
            
            // Establecemos el código de envío igual al de facturación
            acc.ShippingPostalCode = acc.BillingPostalCode;
        }
    }
}