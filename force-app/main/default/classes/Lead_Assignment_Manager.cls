public class Lead_Assignment_Manager {
    // The sales team data
    private SalesTeam ste_team;


    public Lead_Assignment_Manager() {
        this.ste_team = new SalesTeam();
    }


    @TestVisible
    private User stb_assign_type(Lead newLead) {
        User newOwner;

        if(newLead.Lead_Type__c == 'STB') {
            switch on Math.mod(Integer.valueOf(newLead.RoundRobin_Number__c), 3) {
                when 0 {
                    newOwner = this.ste_team.getMemberByName('Mark Robertson').getUser();
                }

                when 1 {
                    newOwner = this.ste_team.getMemberByName('Terry Wilson').getUser();
                }

                when 2 {
                    newOwner = this.ste_team.getMemberByName('Nick Fuemmeler').getUser();
                }

                when else {
                    newOwner = this.ste_team.getMemberByName('Sondra Kirby').getUser();
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

        if(this.ste_team.getMemberByName('Dan DeAces').containsState(newLead.State) || this.ste_team.getMemberByName('Dan DeAces').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Dan DeAces').getUser();
        }else if(this.ste_team.getMemberByName('Brian Wiest').containsState(newLead.State) || this.ste_team.getMemberByName('Brian Wiest').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Brian Wiest').getUser();
        }else if(this.ste_team.getMemberByName('Todd Mohler').containsState(newLead.State) || this.ste_team.getMemberByName('Todd Mohler').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Todd Mohler').getUser();
        }else if(this.ste_team.getMemberByName('Dustin Sonderegger').containsState(newLead.State) || this.ste_team.getMemberByName('Dustin Sonderegger').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Dustin Sonderegger').getUser();
        }else if(this.ste_team.getMemberByName('Kenneth Johnson').containsState(newLead.State) || this.ste_team.getMemberByName('Kenneth Johnson').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Kenneth Johnson').getUser();
        }else if(this.ste_team.getMemberByName('Dennis Weiler').containsState(newLead.State) || this.ste_team.getMemberByName('Dennis Weiler').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Dennis Weiler').getUser();
        }else if(this.ste_team.getMemberByName('Nick Schafer').containsState(newLead.State) || this.ste_team.getMemberByName('Nick Schafer').containsPostalCode(newLead.PostalCode)) {
            newOwner = this.ste_team.getMemberByName('Nick Schafer').getUser();
        }else {
            newOwner = this.ste_team.getMemberByName('Dan DeAces').getUser();
        }

        return newOwner;
    }



    public void assign_owner(Lead newLead) {
        User newOwner = this.stb_assign_type(newLead);

        if(newOwner == null) {
            newOwner = this.ste_assign_territory(newLead);
        }

        newLead.OwnerId = newOwner.Id;
    }
}
