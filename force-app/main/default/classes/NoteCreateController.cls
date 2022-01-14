public class NoteCreateController {
    public Activity_Note__c an {get;set;}
    public String evtId ;
    
    public NoteCreateController(){
      an = new Activity_Note__c();
        evtId = ApexPages.currentPage().getParameters().get('evtId');
    }
    
    public PageReference saveNote(){
        
        
        insert an; // Id gets generated
        
        if(evtId <> null && evtId <> ''){
            Event evt = new Event(Id = evtId);
            evt.Description = an.Id ; // replace Description with enahanced lookup field.
            update evt;
        }
        return new PageReference('/'+an.Id);
    }
    
    public PageReference cancelNote(){
        if(evtId <> null && evtId <> ''){
            return new PageReference('/'+evtId);
        }
        
        return null;
    }
}