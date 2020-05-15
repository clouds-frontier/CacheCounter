public with sharing class taskCounter {
    @AuraEnabled (cacheable=true)
    public static integer getOpenTaskCount() {
        
        integer counter=0;
       
        string userId= userinfo.getUserId();
       
Cache.OrgPartition orgPart = Cache.Org.getPartition('local.counter');
        if(!orgPart.contains(userId)){
            	
            counter = [select count() from task where OwnerId=:userId and status in ('Not Started', 'In Progress')];
             
             if(counter!=NULL)
            {
				orgPart.put(userId, counter );
             }
                
            else
            {
              orgPart.put(userId, 0 );  
            }
                
            }
        else{
            counter = (integer)orgPart.get(userId); 
            
        }
        return counter;

    }
}