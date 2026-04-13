Feature: Motor de Escalación de Casos
  Como un Service Cloud Manager
  Quiero que los casos con más de 48 horas de creados sean escalados automáticamente
  Para garantizar el cumplimiento de los SLA y la trazabilidad de auditoría

  Scenario: Happy Path - Caso Abierto > 48h
    Given un Caso con Status 'Open' creado hace 50 horas
    When el proceso CaseEscalationBatch se ejecuta
    Then el Status del Caso debe cambiar a 'Escalated'
    And una Task con Subject 'SLA Breach Review' debe ser creada
    And un registro en EscalationLog__c debe ser registrado

  Scenario: Negative - Caso Cerrado > 72h
    Given un Caso con Status 'Closed' creado hace 72 horas
    When el proceso CaseEscalationBatch se ejecuta
    Then el Status del Caso debe permanecer como 'Closed'
    And ninguna Task ni EscalationLog__c deben ser creados

  Scenario: Negative - Caso ya escalado > 48h
    Given un Caso con Status 'Escalated' creado hace 48 horas
    When el proceso CaseEscalationBatch se ejecuta
    Then el proceso no debe crear duplicados de Task ni de EscalationLog__c

  Scenario: Boundary - Caso abierto exactamente en el límite de 48h
    Given un Caso con Status 'Open' creado hace exactamente 48 horas
    When el proceso CaseEscalationBatch se ejecuta
    Then el Status del Caso debe cambiar a 'Escalated'

  Scenario: Bulk - 200 Casos Abiertos > 48h
    Given 200 Casos con Status 'Open' creados hace 49 horas
    When el proceso CaseEscalationBatch se ejecuta
    Then los 200 Casos deben estar en Status 'Escalated'
    And no se deben exceder los Governor Limits de Salesforce