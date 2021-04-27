@isTest
private class Lead_Assignment_Manager_TEST {
    private static String leads_fieldString;
    private static Integer check_limit;

    static {
        leads_fieldString = 'Name, FirstName, LastName, Company, Industry__c, OwnerId, Lead_Type__c, LeadSource, Address, PostalCode, State, Country, RoundRobin_Number__c';

        check_limit = 1;
    }


    // -----------------------------------------------------------------------------------
    // ---------------------------- stb_assign_type Tests --------------------------------
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


        // Make sure if Postal Code is 78772 then it goes to Kenneth
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


        // Make sure if lead type is null it goes to sondra
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Sondra Kirby'
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

            System.assertEquals(newOwner.Id, userUnderTest.Id); // Sondra
        }
    }
    


    // -----------------------------------------------------------------------------------
    // ---------------------------- assign_owner Tests -----------------------------------
    // -----------------------------------------------------------------------------------
    @isTest(SeeAllData=true)
    static void testAssignOwner_BaseCase() {
        Lead[] leadData;

        User userUnderTest;

        User[] usersQueried;

        String queryString;

        Lead_Assignment_Manager lam = new Lead_Assignment_Manager();


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


        // . . .
        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Todd Mohler'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE PostalCode=\'59911\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            lam.assign_owner(leadData[i]);

            System.assertEquals(leadData[i].OwnerId, userUnderTest.Id); // Todd Mohler
        }


        usersQueried = [
            SELECT Id
            FROM User
            WHERE Name='Dustin Sonderegger'
        ];

        userUnderTest = usersQueried[0];

        queryString = 
            'SELECT ' + leads_fieldString +
            ' FROM Lead ' +
            ' WHERE State=\'MO\'' +
            ' LIMIT ' + check_limit
        ;

        leadData = Database.Query(queryString);

        for(Integer i = 0; i < Math.min(check_limit, leadData.size()); i++) {
            lam.assign_owner(leadData[i]);

            System.assertEquals(leadData[i].OwnerId, userUnderTest.Id); // Dustin Sonderegger
        }
    }
}
