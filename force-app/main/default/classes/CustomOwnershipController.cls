public class CustomOwnershipController {

    public boolean check { get; set; }

    public Relationship__c r{get;set;}

    public Relationship__c getA() {
        r = new Relationship__c();
        return r;
    }
   
    public PageReference Saveown() {
        
        List<string> relIds = ApexPages.currentPage().getParameters().get('ids').split('\\,');
        System.debug('Ids'+ relIds);
        
        List<Relationship__c> relList = [SELECT ID, Ownerid FROM Relationship__c WHERE ID in :relIds ];
        
        System.debug('SOQL'+ relList );
        
       for(Relationship__c rel:relList){
            if(r.ownerid<>null)
            rel.ownerid = r.ownerid;
        } 
        
        string emailBody;
        emailBody = 'Below Relationship(s) has/have been assigned to you. Please click on the link(s) below to view the records(s)';
        
        for(string s : relIds ){
            emailBody+='\n '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+s;
        }        
        if(check==true)SendEmail(r.ownerid,emailBody);
        update relList ;       
        
        PageReference p = new PageReference(ApexPages.currentPage().getParameters().get('retUrl'));
        return p;
    }

    public PageReference Cancel() {
        r.ownerid = userinfo.getUserId();
       PageReference p = new PageReference(ApexPages.currentPage().getParameters().get('retUrl'));
        return p;
    }
    
    public static void SendEmail(ID id,String emailBody){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setTargetObjectId(id);
        mail.setSaveAsActivity(false);
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Salesforce Owner Change Information');
        
        // Specify the subject line for your email address.
        mail.setSubject('Relationship(s) transferred to you');
       
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody(emailBody);
        
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    
    }
    
     

}