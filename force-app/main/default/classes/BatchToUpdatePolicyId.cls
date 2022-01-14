global class BatchToUpdatePolicyId implements Database.batchable<sObject>{

         
     global Database.QueryLocator start(Database.BatchableContext BC){
      
        String query = 'SELECT Id,Name,Policy_ID__c FROM Eclipse__c';
        return Database.getQueryLocator(query);

     }
     global void execute(Database.BatchableContext BC, List<Eclipse__c> scope){
        
        //List of accounts to update
        List<Eclipse__c> eclToUpdateList =  new List<Eclipse__c>();
         try{
            for(Eclipse__c ec: scope){
               ec.Policy_ID__c = ec.Name+'_1';
               
               eclToUpdateList.add(ec);
               
             }
             
              //Checking if the list is empty
              if(!eclToUpdateList.isEmpty()){
                update eclToUpdateList;
              }
              
                            
          }
          
         // Catching the exception
        catch(Exception ex) {
            
            System.debug('Error:'+ex.getMessage());
        }  
        
       } 
       
       global void finish(Database.BatchableContext BC){
        
       }

}