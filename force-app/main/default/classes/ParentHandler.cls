public with sharing class ParentHandler {
   
    //inserting the parent records in the hierarchy
    public static void isInsertParent(  Map<Id , Account > mapdata ,  List<Account> tnew){
        for(Account acc : tnew){
            //checking  for the null value
            if(acc.ParentId == null){
                break ;
            }
            //fetching all the ids
            Id parentId = acc.ParentId;
            
            while(parentId != null){
                Account temp = mapdata.get(parentId) ; 
                Id tempId = temp.Id ; 

                if(acc.Parent_Accounts__c == null) {
                    acc.Parent_Accounts__c = (String)tempId + ',' ; 
                }
                else {
                    acc.Parent_Accounts__c += (String)tempId + ',';
                }

                parentId = temp.ParentId ; 
            }
        }
    }

    //Deleting the records parent records when the record is deleted 
    public static List<Account> tobeDeleted(Map<Id , Account > mapdata ,  List<Account> told){
  //list to be updated 
  List<Account> tobeUpdated = new List<Account>();
       for(Account acc : told){
        //accessing the id which has to be deleted this will work in the before trigger 
        Id selfId = acc.Id ; 

        //accessing all the records of that account
        Account records = mapdata.get(selfId) ; 

        //accessing the Child record 
        String childString = records.child__c ; 
        if(childString == null){
   break;
        }
            List<Id> childList = childString.split(',');


        //accessing the parent records 
        String parentString = records.Parent_Accounts__c;
        List<Id> parentList = parentString.split(',');

        parentList.add(selfId);

        for(Id childId : childList){
            //Accessing all the records of that childId 
            Account recordChild = mapdata.get(childId);

            //accessing the record of the parent
            String parenttobdeleted = recordChild.Parent_Accounts__c ; 
            
            //deleting the reords 
            for(Id k : parentList){
                parenttobdeleted = parenttobdeleted.remove(k + ',');
            }
             recordChild.Parent_Accounts__c = parenttobdeleted;
             tobeUpdated.add(recordChild);

        }

       }
       return tobeUpdated ;
    }

    //updated the records 
    public static Map<Id , Account> updateParent(map<Id,Account> mapData , List<Account> Result,List<Account> tnew,List<Account> told){
        //creating the map for storing the results
        Map<Id , Account> finalResult = new Map<Id , Account>();
        //fetching the records 
        for(Integer i = 0 ; i < told.size() ; i++){
            //if the parent id is same as to what it has to be updated then do nothing
            if(tnew[i].ParentId == told[i].ParentId){
                break ; 
            }
            //obtaining the records 
            Id childId = told[i].Id ; 

            //fetching the results of the old parent id and  the recent id
            Id newParent = tnew[i].ParentId ; 
            Id oldParent = told[i].ParentId ; 

            Account record = mapData.get(childId) ;
            
            String child = record.child__c ; 

            //accessing the parent records 
            String parent = record.Parent_Accounts__c ; 
            
            //List to store the child
            List<Id> childList = child.split(',');

            //list to store the parent
            List<Id > parentList = parent.split(',');
            //accessing the parent of the new id
            Account resultId = mapData.get(newParent);
            String parenttobeAdded = resultId.Parent_Accounts__c ; 
            parenttobeAdded += (String)newParent + ',' ; 

             //adding the parent details in the current account
            //making the parent of the child null and then updating the results
            // record.Parent_Accounts__c = null;
            record.Parent_Accounts__c = parenttobeAdded; 

            //remove parent from all the child  and add the parent records 

            for(Id j : childList){
                Account records = mapData.get(j);
                String recordParent = records.Parent_Accounts__c ; 

                //removing all the parent records from the child records
                for(Id k : parentList){
                    recordParent = recordParent.remove(k + ',');
                }
                records.Parent_Accounts__c = recordParent ;
                records.Parent_Accounts__c += parenttobeAdded ;
                Result.add(records);
            }
   
           
            

            //from here the actual execution of the program starts
         

            
            //iterating the list to append the parents in the list
            // for(Id l : childList){
            //     Account recordResult = mapData.get(l);
            //     String recordParentResult = recordResult.Parent_Accounts__c ; 
            //     recordParentResult += parenttobeAdded + ',';
            //     Result.add(recordResult);

            // }

            //updating all the child accounts

            Account chilTobeUpdate = mapData.get(newParent);
            String childTobeUpdateString = chilTobeUpdate.child__c ; 
            childTobeUpdateString += child ;

         

            
        }
        //convert them into the list to remove the dulplicate records 
        for(Account i : Result){
            finalResult.put(i.Id , i);
        }
        return finalResult ; 
    }
    
}