@isTest
private class Lead_Assignment_Manager_TEST {
    // -----------------------------------------------------------------------------------
    // ---------------------------- stb_assign_type Tests ------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest
    static void testSTBAssignType_BaseCase() {
        List<User> userData = TestDataGenerator.loadUsers();
        List<Lead> leadData = TestDataGenerator.loadLeads();

        // This test uses the test data we created in the static resource so double check that you have an stb
        // and a round robin number before we do this test.
        System.assertEquals(userData[5].Name, 'Terry Wilson');
        System.assertEquals(leadData[0].Lead_Type__c, 'STB');
        System.assertEquals(Integer.valueOf(leadData[0].RoundRobin_Number__c), 6235);

        Lead_Assignment_Manager lam = new Lead_Assignment_Manager();
        
        lam.stb_assign_type();

        // 6235 mod 3 is 1 so it should be Terry Wilson
        System.assertEquals(leadData[0].OwnerId, userData[5].Id);
    }

/*
    // -----------------------------------------------------------------------------------
    // ----------------------------- ste_assign_territory Tests -------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest
    static void testSTEAssignTerritory_BaseCase() {

    }


    // -----------------------------------------------------------------------------------
    // ---------------------------- assign_owner Tests ---------------------------------------
    // -----------------------------------------------------------------------------------
    @isTest
    static void testAssignOwner_BaseCase() {

    }
*/
}
