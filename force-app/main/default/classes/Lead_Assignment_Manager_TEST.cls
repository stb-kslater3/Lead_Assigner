@isTest
private class Lead_Assignment_Manager_TEST {
    private static String leads_fieldString;
    private static Integer check_limit;

    static {
        leads_fieldString = 'Name, FirstName, LastName, Company, OwnerId, Lead_Type__c, LeadSource, PostalCode, State, RoundRobin_Number__c';

        check_limit = 10;
    }


    // -----------------------------------------------------------------------------------
    // ---------------------------- stb_assign_type Tests ------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testSTBAssignType_BaseCase() {
        User[] userQueried;

        User tWilson, mRobertson, nFuemmeler;
        
        userQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Terry'
            AND LastName='Wilson'
        ];

        tWilson = userQueried[0];


        userQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Mark'
            AND LastName='Robertson'
        ];

        mRobertson = userQueried[0];


        userQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Nick'
            AND LastName='Fuemmeler'
        ];

        nFuemmeler = userQueried[0];


        Lead[] leadData;

        Lead_Assignment_Manager lam = new Lead_Assignment_Manager();
        User newOwner;

        String queryString;

        // If the type is STB it should give me the new Owner according to the Round Robin
        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE Lead_Type__c=\'STB\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.stb_assign_type(leadData[i]);

            Integer roundRobin = Integer.valueOf(leadData[i].RoundRobin_Number__c);
            if( Math.mod(roundRobin, 3) == 0 ) {
                System.assertEquals(newOwner.Id, mRobertson.Id);
            }else if( Math.mod(roundRobin, 3) == 1 ) {
                System.assertEquals(newOwner.Id, tWilson.Id);
            }else {
                System.assertEquals(newOwner.Id, nFuemmeler.Id);
            }
        }


        // If the type is Not STB it should give me null
        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE Lead_Type__c!=\'STB\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.stb_assign_type(leadData[i]);

            System.assertEquals(newOwner, null);
        }
    }


    // -----------------------------------------------------------------------------------
    // ----------------------------- ste_assign_territory Tests -------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testSTEAssignTerritory_BaseCase() {
        Lead[] leadData;

        User userUnderTest;

        User[] usersQueried;

        String queryString;

        Lead_Assignment_Manager lam = new Lead_Assignment_Manager();
        User newOwner;


        // Make sure if State is WA or ID or if Postal Code is 59219 or 59222 then it goes to Dan
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Dan DeAces'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'WA\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }


        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'CA\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }


        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'59219\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'59258\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }


        // Make sure if State is WY then it goes to Brian
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Brian Wiest'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'WY\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Brian Wiest
        }


        // Make sure if State is OH then it goes to David
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='David Thornberry'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'OH\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // David Thornberry
        }


        // Make sure if Postal Code is 78772 or 77703 then it goes to Kenneth
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Kenneth Johnson'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'78772\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Kenneth Johnson
        }


        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'77703\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Kenneth Johnson
        }


        // Make sure if State or PostalCode are Something Else, then it goes to Dan
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Dan DeAces'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'AL\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }


        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'64463\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }
    }


    // -----------------------------------------------------------------------------------
    // ---------------------------- assign_owner Tests ---------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testAssignOwner_BaseCase() {
        Lead[] leadData;

        User userUnderTest;

        User[] usersQueried;

        String queryString;

        Lead_Assignment_Manager lam = new Lead_Assignment_Manager();
        User newOwner;


        User tWilson, mRobertson, nFuemmeler;
        
        usersQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Terry'
            AND LastName='Wilson'
        ];

        tWilson = usersQueried[0];


        usersQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Mark'
            AND LastName='Robertson'
        ];

        mRobertson = usersQueried[0];


        usersQueried = [
            SELECT Id
            FROM User
            WHERE FirstName='Nick'
            AND LastName='Fuemmeler'
        ];

        nFuemmeler = usersQueried[0];


        // Make sure it is caught by STB if it is type STB
        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE Lead_Type__c=\'STB\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.stb_assign_type(leadData[i]);

            Integer roundRobin = Integer.valueOf(leadData[i].RoundRobin_Number__c);
            if( Math.mod(roundRobin, 3) == 0 ) {
                System.assertEquals(newOwner.Id, mRobertson.Id);
            }else if( Math.mod(roundRobin, 3) == 1 ) {
                System.assertEquals(newOwner.Id, tWilson.Id);
            }else {
                System.assertEquals(newOwner.Id, nFuemmeler.Id);
            }
        }



        // Make sure it is caught by STE if not STB
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Kenneth Johnson'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'78772\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Kenneth Johnson
        }


        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Dan DeAces'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'AL\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            newOwner = lam.ste_assign_territory(leadData[i]);

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Dan DeAces
        }
    }
}
