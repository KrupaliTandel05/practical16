trigger MainTrigger on Account (after insert,before delete ,after update , before insert) {
    List<Account> AllData = [Select Id, ParentId,child__c ,Parent_Accounts__c from Account];
    List<Account> Result = new List<Account>();
    map<Id,Account> mapData = new map<Id,Account>();
    List<Account> told = Trigger.old ; 
    List<Account> tnew = Trigger.new ;
    List<Account> totalResult = new List<Account>();
    List<Account> totalResultParent = new List<Account>();
  
    Map<Id,Account> totalResultMap = new Map<Id,Account>();
    for(Account i: AllData){ 
        mapData.put(i.Id,i);
    }
    
    if(Trigger.isInsert){
        //in the after insert only the data has to be updated basically
        if(Trigger.isAfter){
            totalResult = ChildHandler.InsertChild(mapData , Result , tnew );

        }

        //in the before trigger the data has not to be updated
        if(Trigger.isBefore){
            //inserting the parent records in the parent account field
            ParentHandler.isInsertParent(mapdata, tnew);

        }
        
    }
    else if(Trigger.isDelete){        
        totalResult = ChildHandler.deleteChild(mapData , Result , told);
        update totalResult;
        //deleting for the parent records
        totalResultParent = ParentHandler.tobeDeleted(mapdata, told );

    }
    else if(Trigger.isUpdate){
        totalResultMap = ChildHandler.UpdateChild(mapData , Result , tnew, told);
        totalResult = totalResultMap.values();
        List<Account> result = ParentHandler.updateParent(tnew) ; 
        update result ; 
         
       
        
    }
   		
    update totalResult;
   

}