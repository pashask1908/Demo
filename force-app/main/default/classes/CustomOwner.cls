public with sharing class CustomOwner {
    public CustomOwner(){
     //String strvar = ApexPages.CurrentPage().getParameters().get('id');
    // a = [select id,ownerid from relationship__c where id IN:strvar.id];
    }

    public Boolean check { get; set; }

    public Relationship__c a { get; set; }

    public PageReference Cancelowner() {
        return null;
    }


    public PageReference saveowner() {
      update a;
      
      /*  if(check==true){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'a.email'};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName(a.name);
        mail.setSubject('Sandbox: Relationship(s)transferred to you.');
       mail.setHtmlBody('Below Relationship(s) has/have been assigned to you. Please click on the link(s) below to view the record(s).<p>+<a href=https://ap1.salesforce.com/''+a.ownerId>');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        } */
                 
        return null;
        
    }

}