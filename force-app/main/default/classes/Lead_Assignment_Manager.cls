public class Lead_Assignment_Manager {
    // The sales team data
    private SalesTeam sales_team;


    public Lead_Assignment_Manager() {
        this.sales_team = new SalesTeam();
    }


    @TestVisible
    private User stb_assign_type(Lead newLead) {
        User newOwner;

        if(newLead.Lead_Type__c == 'STB') {
            switch on Math.mod(Integer.valueOf(newLead.RoundRobin_Number__c), 3) {
                when 0 {
                    newOwner = this.sales_team.getMemberByName('Mark Robertson').getUser();
                }

                when 1 {
                    newOwner = this.sales_team.getMemberByName('Terry Wilson').getUser();
                }

                when 2 {
                    newOwner = this.sales_team.getMemberByName('Nick Fuemmeler').getUser();
                }

                when else {
                    newOwner = this.sales_team.getMemberByName('Sondra Kirby').getUser();
                }
            }
        }else {
            newOwner = null;
        }

        return newOwner;
    }

    @TestVisible
    private User ste_assign_territory(Lead newLead) {
        User newOwner;
        
        if(this.sales_team.getMemberByName('Brian Wiest').containsState(newLead.State) || this.sales_team.getMemberByName('Brian Wiest').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Brian Wiest').getUser();
        }else if(this.sales_team.getMemberByName('Todd Mohler').containsState(newLead.State) || this.sales_team.getMemberByName('Todd Mohler').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Todd Mohler').getUser();
        }else if(this.sales_team.getMemberByName('Dustin Sonderegger').containsState(newLead.State) || this.sales_team.getMemberByName('Dustin Sonderegger').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Dustin Sonderegger').getUser();
        }else if(this.sales_team.getMemberByName('Kenneth Johnson').containsState(newLead.State) || this.sales_team.getMemberByName('Kenneth Johnson').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Kenneth Johnson').getUser();
        }else if(this.sales_team.getMemberByName('David Thornberry').containsState(newLead.State) || this.sales_team.getMemberByName('David Thornberry').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('David Thornberry').getUser();
        }else if(this.sales_team.getMemberByName('Dennis Weiler').containsState(newLead.State) || this.sales_team.getMemberByName('Dennis Weiler').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Dennis Weiler').getUser();
        }else if(this.sales_team.getMemberByName('Nick Schafer').containsState(newLead.State) || this.sales_team.getMemberByName('Nick Schafer').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.sales_team.getMemberByName('Nick Schafer').getUser();
        }else if(newLead.Lead_Type__c == null || newLead.LeadSource == 'Web' || newLead.Address == null || (newLead.State == null && newLead.country == null)) { // if there isn't an address give it to Sondra
            newOwner = this.sales_team.getMemberByName('Sondra Kirby').getUser();
        }else { // if there is an address give it to dan
            newOwner = this.sales_team.getMemberByName('Dan DeAces').getUser();
        }
        /*
        //Old Version, now Sondra will be default otherwise
        else if(newLead.LeadSource == 'Web') {
            newOwner = this.sales_team.getMemberByName('Sondra Kirby').getUser();
        }else {
            newOwner = this.sales_team.getMemberByName('Dan DeAces').getUser();
        }
        */

        return newOwner;
    }



    public void assign_owner(Lead newLead) {
        User newOwner;

        newOwner = this.stb_assign_type(newLead);

        if(newOwner == null) {
            newOwner = this.ste_assign_territory(newLead);
        }

        newLead.OwnerId = newOwner.Id;

        if(newLead.Industry__c == null) {
            newLead.Industry__c = 'Other';
        }
    }
}


/*
// To test out the logic in the Apex Execute Anonymous Window

!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!
// Note that when in trigger no dml like update or insert is needed because the trigger has before insert/update
// but otherwise when just running the method alone you need to also manually update or insert 
!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!


String leads_fieldString = 'Id, Name, FirstName, LastName, Company, Industry__c, OwnerId, Owner.Name, Lead_Type__c, LeadSource, Address, PostalCode, State, Country, RoundRobin_Number__c';

Lead_Assignment_Manager lam = new Lead_Assignment_Manager();

String queryString = 
    'SELECT ' + leads_fieldString +
    ' FROM Lead ' +
    ' WHERE State=null' +
    ' AND Country=null' +
    ' LIMIT 10'
;

Lead[] leadData = Database.query(queryString);

System.debug('Owner Before: ' + leadData[0].Owner.Name);

lam.assign_owner(leadData[0]);
System.debug('Lead Name: ' + leadData[0].Name);

queryString = 
    'SELECT ' + leads_fieldString +
    ' FROM Lead ' +
    ' WHERE Id=\'' + leadData[0].Id + '\'' +
    ' LIMIT 1'
;

Lead[] newLead = Database.query(queryString);

System.debug('Owner After: ' + newLead[0].Owner.Name);




*/
