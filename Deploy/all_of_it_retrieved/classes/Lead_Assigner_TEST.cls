@isTest
private class Lead_Assigner_TEST {
    @isTest(SeeAllData=true)
    static void testLeadAssigner_AllInOne() {
        Lead dummy;

        Lead[] newLeads;
        User[] userQuery;

        User dummyOwner;


    // Will be used for Leads that involve STB
        userQuery = [
            SELECT Id
            FROM User
            WHERE Name='Terry Wilson'
            LIMIT 1
        ];

        User tWilson = userQuery[0];

        userQuery = [
            SELECT Id
            FROM User
            WHERE Name='Mark Robertson'
            LIMIT 1
        ];

        User mRobertson = userQuery[0];

        userQuery = [
            SELECT Id
            FROM User
            WHERE Name='Nick Fuemmeler'
            LIMIT 1
        ];

        User nFuemmeler = userQuery[0];




    // Make sure default lead runs by setting the State to MO and seeing if Dustin was Assigned to it
        dummy = new Lead();

        // LastName and Company are required fields for insert
        dummy.LastName = 'Santiago';
        dummy.Company = 'Santiago Heating and Cooling';

        dummy.State = 'MO';

        insert dummy;

        userQuery = [
            SELECT Id
            FROM User
            WHERE Name='Dustin Sonderegger'
            LIMIT 1
        ];

        dummyOwner = userQuery[0];

        // Requery dummy Lead after insert
        newLeads = [
            SELECT OwnerId
            FROM Lead
            WHERE Id = :dummy.Id
        ];

        dummy = newLeads[0];

        System.assertEquals(dummyOwner.Id, dummy.OwnerId);



    // Make sure that if you change the type of a Non STB lead it will assign one of the STB People
        // get a non stb lead
        newLeads = [
            SELECT OwnerId
            FROM Lead
            WHERE Lead_Type__c != 'STB'
        ];

        dummy = newLeads[0];

        // Needed to satisfy validation rule
        dummy.Industry__c = 'Other';

        dummy.Lead_Type__c = 'STB';

        update dummy;


        // requery for updated value of dummy
        newLeads = [
            SELECT OwnerId
            FROM Lead
            WHERE Id = :dummy.Id
        ];

        dummy = newLeads[0];


        System.assert( (dummy.OwnerId == tWilson.Id) || (dummy.OwnerId == mRobertson.Id) || (dummy.OwnerId == nFuemmeler.Id) );



    // Make sure that if you change the Owner of an already STB lead it will not reassign the owner
        // get an already stb lead
        newLeads = [
            SELECT OwnerId
            FROM Lead
            WHERE Lead_Type__c = 'STB'
        ];

        dummy = newLeads[0];

        // Needed to satisfy validation rule
        dummy.Industry__c = 'Other';

        dummy.State = 'New Mexico';

        Id oldDummyOwner = dummy.OwnerId;

        update dummy;


        // requery for updated value of dummy
        newLeads = [
            SELECT OwnerId
            FROM Lead
            WHERE Id = :dummy.Id
        ];

        dummy = newLeads[0];


        System.assertEquals(oldDummyOwner, dummy.OwnerId);
    }
}