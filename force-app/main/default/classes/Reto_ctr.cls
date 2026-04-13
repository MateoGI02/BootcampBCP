public with sharing class Reto_ctr {
    // Método principal: consulta Account y devuelve un resumen simple
    // Retorna: "SEGMENT|DISCOUNT"
    public static String build(Id accountId, Decimal lastInvoiceAmount) {
        Account acc = [
            SELECT Id, AnnualRevenue, NumberOfEmployees
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return computeSummary(acc, lastInvoiceAmount);
    }

    // Helper: calcula segmento y descuento en base a Account + monto
    @testvisible
    private static String computeSummary(Account acc, Decimal lastInvoiceAmount) {
        Decimal revenue = (acc.AnnualRevenue == null) ? 0 : acc.AnnualRevenue;
        Integer employees = (acc.NumberOfEmployees == null) ? 0 : Integer.valueOf(acc.NumberOfEmployees);
        Decimal invoice = (lastInvoiceAmount == null || lastInvoiceAmount < 0) ? 0 : lastInvoiceAmount;

        String segment = 'SMB';
        if (revenue >= 1000000 && employees >= 50 && invoice >= 10000) {
            segment = 'ENTERPRISE';
        } else if (revenue >= 250000 || employees >= 20) {
            segment = 'MID';
        }

        Decimal discount = 0;
        if (invoice >= 20000) discount += 0.10;
        if (revenue >= 500000) discount += 0.02;

        return segment + '|' + discount.setScale(2);
    }
}