trigger Lead_Assigner on Lead (before insert, before update) {
    Lead_Assignment_Manager lam = new Lead_Assignment_Manager();

    Boolean runAssigner;

    for(Integer i = 0; i < Trigger.size; i++) {
        runAssigner = false;

        // Every time a new one is created go ahead and run it, and then they can update it if needed
        if(Trigger.isInsert) {
            runAssigner = true;
        }else if(Trigger.isUpdate) { // Necessary because Trigger.old is only available for updates, not inserts
            if(Trigger.old[i].Lead_Type__c != 'STB' && Trigger.new[i].Lead_Type__c == 'STB') {
                runAssigner = true;
            }
        }

        if(runAssigner) {
            lam.assign_owner(Trigger.new[i]);
        }
    }
}