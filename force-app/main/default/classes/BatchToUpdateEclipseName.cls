/************************************************************************
* Name     : BatchToUpdateBillingAddress_PRS 
* Author   : Deloitte Consulting
* Desc     : This batch job will run to Copy Custom Address to Billing Address on the account record
*
* Modification Log:
* ----------------------------------------------------------------------
* Developer                    Date            Description
* ----------------------------------------------------------------------
* Chand                     02/07/2017         Original Version
*************************************************************************/


global class BatchToUpdateEclipseName implements Database.batchable<sObject>{
   
   public String query;
   public BatchToUpdateEclipseName(String query)
   {
     this.query = query;
   }

         
     global Database.QueryLocator start(Database.BatchableContext BC){
      
      //  ddString query = 'SELECT Id,Name FROM Eclipse__c';
        return Database.getQueryLocator(query);

     }
     global void execute(Database.BatchableContext BC, List<Eclipse__c> scope){
        
        //List of accounts to update
        List<Eclipse__c> eclToUpdateList =  new List<Eclipse__c>();
         try{
            for(Eclipse__c ec: scope){
            if(ec.Name.contains('|')){
               List<String> strl = New List<String>();
               strl = ec.Name.split('\\| ');
               ec.Name = strl[1]+' --- ' +strl[2];
               eclToUpdateList.add(ec);
               
             }
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