public with sharing class ChildHandler {
    // for deletation
    public static List<Account> deleteChild(map<Id,Account> mapData , List<Account> Result,List<Account> told){
        for(Account acc: told){
           Id ChildID = acc.Id;
           Id ParentId = acc.ParentId;
           List<Id> delList = new List<Id>();
           Account toBeDeleted = mapData.get(ChildID);
           if(toBeDeleted != null){
               String delId = toBeDeleted.child__c;
               if(delId == null){
                   delList.add(ChildID);
                }
                else{
                    delId += ChildID;
                    delList = delId.Split(',');
                }
           
           
                while(ParentId != null){
                   Account temp = mapData.get(ParentId);
                   String OldString = temp.child__c;
               
                   for(Id i: delList ){
                       OldString = OldString.remove(i+',');
                   }
               
                   temp.child__c = OldString;
                   Result.add(temp);
                   ParentId = temp.ParentId;
               }
           }
        
       }
           return Result;
   }
   
   //insert function
   public static List<Account> InsertChild(map<Id,Account> mapData , List<Account> Result,List<Account> tnew){
               for(Account acc : tnew){
                    Id ChildID = acc.Id;
                    Id ParentId = acc.ParentId;
                    Account toBeInserted = mapData.get(ChildID);
                    if(toBeInserted == null){
                        break;
                    }
                    String InsId = toBeInserted.child__c;
                    if(InsId == null){
                        InsId = ChildID + ',';
                    }
                    else{
                        InsId += ChildID+',';
                    }
   
               while(ParentId != null){
                   Account temp = mapData.get(ParentId);
                   String OldString = temp.child__c;
                   if(OldString == null){
                       temp.child__c = InsId;
                   }
                   else{
                          temp.child__c += InsId;        
                      }
                   Result.add(temp);
                   ParentId = temp.ParentId;
               }
               
           }
           return Result;
       }
   
   


   //for updation
   public static Map<Id,Account> UpdateChild(map<Id,Account> mapData , List<Account> Result,List<Account> tnew,List<Account> told){
       Map<Id,Account> finalResult= new Map<Id,Account>();
       for(Integer i=0; i<told.size(); i++){
           if(tnew[i].ParentId == told[i].ParentId){
               break;
           }
           Id ChildId = told[i].Id;
           Id newParent = tnew[i].ParentId;
           Id oldParent = told[i].ParentId;
           List<Id> delList = new List<Id>();
           Account toBeUpdated = mapData.get(ChildId);
           String UpdId = toBeUpdated.child__c;
           if(UpdId == null){
                       UpdId = ChildID + ',';
                   }
                   else{
                       UpdId += ChildID+',';
                   }
           delList = UpdId.Split(',');
           
           // for deleting from child__c
           while(oldParent != null){
               Account temp = mapData.get(oldParent);
               String OldString = temp.child__c;
               for(Id j: delList ){
                       OldString = OldString.remove(j+',');
                   }
               
                   temp.child__c = OldString;
                   Result.add(temp);
                   oldParent = temp.ParentId;
           }
           
           // For inserting Data into child__c
           while(newParent != null){
               Account temp = mapData.get(newParent);
               String newString = temp.child__c;
               if(newString == null){
                       temp.child__c = UpdId;
                }
                else{
                        temp.child__c += UpdId;        
                }
               Result.add(temp);
               newParent = temp.ParentId;
           }
          
       }
        
    
       // convert into map for avoid duplicate values
       for(Account i :Result){
           finalResult.put(i.Id,i);
       }
       
       return finalResult; 
   }


}






