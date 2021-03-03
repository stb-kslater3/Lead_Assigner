public class SalesTeamMember {
    private User member;
    private SalesTeamTerritory__c territory;


    public SalesTeamMember(User member) {
        this.member = member;

        SalesTeamTerritory__c[] queriedTerritories = [
            SELECT PostalCodes__c, States__c
            FROM SalesTeamTerritory__c
            WHERE User__c=:this.member.Id
            LIMIT 1
        ];

        this.territory = queriedTerritories[0];
    }


    public User getUser() {
        return this.member;
    }


    public Boolean containsState(String state) {
        return ( !String.isEmpty(state) && this.territory.States__c.contains(state) );
    }

    public Boolean containsPostalCode(String postalCode) {
        return ( !String.isEmpty(postalCode) && this.territory.PostalCodes__c.contains(postalCode) );
    }
}
