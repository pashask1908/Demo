public with sharing class CustomExtensionController {  
    
    public Eclipse__c ecp{get;set;} 
    public Eclipse__c ecret{get;set;} 
    
    public Account account{get;set;}
    ApexPages.StandardController sController;  
    
    public CustomExtensionController (ApexPages.StandardController controller) {  
        sController = controller;  
        ecp = (Eclipse__c)controller.getRecord();  
    }  
    
    public PageReference saveCustom() {  
        
        // Custom Save code here...  
        
        try{
        	PageReference pr = sController.save();
            Id recId = pr.getUrl().substring(1);
            
            ecret = [select id,name,Relationship__c,Account__c,Account__r.Name from Eclipse__c where Account__c!=null AND Id=:recId   limit 1];
        	
             
            
            ecret.Name=ecret.Account__r.Name;
            update ecret;
            
            return pr; 
        }Catch(Exception e){
            e.getMessage();
            
             return null; 
        }
        
        
        
        
        
        // Alternatively, could return a PR to the view page.  
        //pageReference pv = sController.view();  
        
    }  
}