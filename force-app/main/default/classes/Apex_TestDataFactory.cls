@isTest
public class Apex_TestDataFactory {

    public static Account createAccountWithData(Decimal annualRevenue, Integer employees) {
        Account accountRecord = new Account(
            Name = 'Bootcamp Account',
            AnnualRevenue = annualRevenue,
            NumberOfEmployees = employees
        );
        insert accountRecord;

        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            contactList.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                AccountId = accountRecord.Id,
                Email = 'test' + i + '@example.com'
            ));
        }
        insert contactList;
        return accountRecord;
    }

    public static User createTestUser(String uniqueKey) {
        Profile profileRecord = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard User'
            LIMIT 1
        ];

        String orgIdPart = String.valueOf(UserInfo.getOrganizationId()).left(5);
        String usernameValue = 'bootcamp.' + uniqueKey + '.' + orgIdPart + '@example.com';
        User userRecord = new User(
            Alias = ('u' + uniqueKey).left(8),
            Email = 'bootcamp.' + uniqueKey + '@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Bootcamp',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'Europe/Berlin',
            ProfileId = profileRecord.Id,
            UserName = usernameValue
        );

        insert userRecord;
        return userRecord;
    }

    @future
    public static void assignPermissionSetToUser(Id userId, String permissionSetDeveloperName) {
        List<PermissionSet> permissionSetList = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = :permissionSetDeveloperName
            LIMIT 1
        ];

        if (permissionSetList.isEmpty()) {
            return;
        }

        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = userId,
            PermissionSetId = permissionSetList[0].Id
        );

        insert psa;
    }
}