trigger insertCounttoCache on Task (after insert,after update, after delete, after undelete ) 
{
    Cache.OrgPartition orgPart = Cache.Org.getPartition('local.counter');
                 
	if(trigger.isAfter)
	{
   
	 	if(trigger.isInsert)
    	{
        	Set<id> userIdsSet = new Set<Id>();    
        	Map<id,integer> userTaskCountMap = new map<id,integer>();
            
            // update coutner by user
             for (task t: trigger.new)
             {
                 
                 userIdsSet.add(t.OwnerId);
                 if(orgPart.contains(t.OwnerId))
                 {
                         	integer count= (integer)orgPart.get(t.OwnerId);
                            count=count+1;
                     		orgPart.remove(t.OwnerId);
                            orgPart.put(t.OwnerId,count);
                         
                  }                            
             }
            
           }
        
            if(trigger.isUpdate)
            {
                
                
             for (task t: trigger.new)
             {
                 if (t.status != trigger.oldmap.get(t.id).status)
                 {    
                     if(orgPart.contains(t.OwnerId)) // if user never loaded the component or ttl has expired ie logged out do nothing
                     {
                          
                         integer count= (integer)orgPart.get(t.OwnerId);
                         //here is when we decide to subtract or add
                         
                         if(t.status=='Completed')
                         {
                                count=count-1;
                                orgPart.remove(t.OwnerId);
                                orgPart.put(t.OwnerId,count);
                         }
                         else
                         {
                             if(trigger.oldmap.get(t.id).status =='Completed')
                             {
                                count=count+1;
                                orgPart.remove(t.OwnerId);
                                orgPart.put(t.OwnerId,count);
                             }
                             
                         }
                             
                      }
                 }
              
                                         
             }
                
            }
            if(trigger.isDelete)
            {
             // update counter by user
              for (task t: trigger.new)
             {
                 if(orgPart.contains(t.OwnerId))
                 {
                  if(t.status!='Completed')
                   {
                       integer count= (integer)orgPart.get(t.OwnerId);
                       count=count-1;
                       orgPart.remove(t.OwnerId);
                       orgPart.put(t.OwnerId,count);
                   }
                 }
             }
              
            }
        
        
        if(trigger.isUndelete)
            {
             // update counter by user
              for (task t: trigger.new)
             {
                 if(orgPart.contains(t.OwnerId))
                 {
                  if(t.status!='Completed')
                   {
                       integer count= (integer)orgPart.get(t.OwnerId);
                       count=count+1;
                       orgPart.remove(t.OwnerId);
                       orgPart.put(t.OwnerId,count);
                   }
                 }
             }
              
            }
        
	}

}