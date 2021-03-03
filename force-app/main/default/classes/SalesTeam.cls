public class SalesTeam {
    private List<SalesTeamMember> members;
    private Map<String, Integer> memberNameMap;

    public SalesTeam() {
        this.members = new List<SalesTeamMember>();

        this.memberNameMap = new Map<String, Integer>();


        // Get Sales Team User Records
        User[] queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE ProfileId='00e1I000000qg9W'
            AND IsActive=true
        ];

        Integer index = 0;
        for(User queriedMember : queriedMembers) {
            if(queriedMember.Name != 'Brad Outersky') {
                this.members.add(new SalesTeamMember(queriedMember));

                this.memberNameMap.put(queriedMember.Name, index);

                index += 1;
            }
        }


        // Get Dan's User Record
        queriedMembers = [
            SELECT Id, FirstName, LastName, Name
            FROM User
            WHERE Name='Dan DeAces'
            AND IsActive=true
        ];

        this.members.add(new SalesTeamMember(queriedMembers[0]));

        this.memberNameMap.put(queriedMembers[0].Name, this.members.size() - 1);
    }

    
    public SalesTeamMember getMemberByName(String name) {
        return this.members[this.memberNameMap.get(name)];
    }
}
