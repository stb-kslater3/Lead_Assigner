public class SalesTeam {
    private List<SalesTeamMember> members;
    private Map<String, Integer> memberNameMap;

    public SalesTeam() {
        this.members = new List<SalesTeamMember>();

        this.memberNameMap = new Map<String, Integer>();

        User[] queriedMembers;

        // Get STE Team User Records
        queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE ProfileId='00e1I000000qg9WQAQ'
            AND IsActive=true
        ];

        for(User queriedMember : queriedMembers) {
            if(queriedMember.Name != 'Brad Outersky') {
                this.members.add(new SalesTeamMember(queriedMember));

                this.memberNameMap.put(queriedMember.Name, this.members.size() - 1);
            }
        }


        // Get Dan's User Record
        queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE FirstName='Dan'
            AND LastName='DeAces'
            AND IsActive=true
        ];

        this.members.add(new SalesTeamMember(queriedMembers[0]));

        this.memberNameMap.put(queriedMembers[0].Name, this.members.size() - 1);


        // Get STB Team User Records
        queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE ProfileId='00e1I000001vfKAQAY'
            AND IsActive=true
        ];

        for(User queriedMember : queriedMembers) {
            this.members.add(new SalesTeamMember(queriedMember));

            this.memberNameMap.put(queriedMember.Name, this.members.size() - 1);
        }


        // Get Sondra's User Record
        queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE FirstName='Sondra'
            AND LastName='Kirby'
            AND IsActive=true
        ];

        this.members.add(new SalesTeamMember(queriedMembers[0]));

        this.memberNameMap.put(queriedMembers[0].Name, this.members.size() - 1);
    }

    
    public SalesTeamMember getMemberByName(String name) {
        return this.members[this.memberNameMap.get(name)];
    }
}