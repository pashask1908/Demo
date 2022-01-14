@isTest
public class CustomOwnershipController_Test {
    static testMethod void validateCustomOwnershipController() {
       User u1 = [SELECT Id FROM User Limit 1];
       
       System.RunAs(u1){
           Test.startTest();
           Relationship__c c = new Relationship__c ();
           Relationship__c r = new Relationship__c ();
           r.OwnerId = u1.id;
          insert r;
           boolean check=true;
           
                     
           CustomOwnershipController coc = new CustomOwnershipController();
           
           Relationship__c c1 = coc.getA();
           ApexPages.currentPage().getParameters().put('ids', c.id+','+c1.id);
           ApexPages.currentPage().getParameters().put('retUrl', 'https://test.salesforce.com');
           String p1 = coc.Saveown().getUrl();
           System.assertEquals('https://test.salesforce.com', p1);
           
           ApexPages.currentPage().getParameters().put('ids', c.id+','+c1.id);
           List<string> relIds = ApexPages.currentPage().getParameters().get('ids').split('\\,');
           Id userid =(id) u1.id ;
           p1 = coc.Saveown().getUrl();
          
           coc.Saveown();
       string emailBody;
        emailBody = 'Below Relationship(s) has/have been assigned to you. Please click on the link(s) below to view the records(s)';
        
        for(string s : relIds ){
            emailBody+='\n '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+s;
        }   
        CustomOwnershipController.SendEmail(u1.id,emailBody);   
           String p2 = coc.Cancel().getUrl();
           System.assertEquals('https://test.salesforce.com', p2);  
            Test.stopTest();      
           
       }
       
    
}



}