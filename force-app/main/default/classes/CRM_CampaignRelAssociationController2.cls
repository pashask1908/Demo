public without sharing class CRM_CampaignRelAssociationController2 {

  public final campaign cmp;
 
  
  public string relName{get;set;}
  public string relNum{get;set;}
  public string prAdv{get;set;}
  public Boolean relSts{get;set;}
   
  public List<Campaign_Relationship_Association__c> craLst;
  public List<Relationship__c> relLst; 
  public List<CampaignMember> cmLst;
  public List<Contact> conLst;
  public List<RelWrap> RelationshipsLstRecs {get;set;} 
  public List<Relationship__c> relationshipsLst {get;set;}
  public MAP<Integer,Boolean> actionSelMap { get; set; }
    
    public Boolean actionSel{
        get {        
            return actionSelMap.get((Integer)this.setCon.getPageNumber());        
        }
        set {
            actionSel = value;
            actionSelMap.put((Integer)this.setCon.getPageNumber(),actionSel);
        }
    }
 
    /*
    *   set controller
    */
    public ApexPages.StandardSetController setCon;
    
    
    /*
    *   the relationship ids selected by the user
    */
    public Set<Id> selectedRelationshipIds = new Set<Id>();
  
  
  public CRM_CampaignRelAssociationController2(ApexPages.StandardController controller) {
    cmp = (Campaign)controller.getRecord();
  }

  // runs the actual query
  public void runQuery() {
        
            if(relName=='' && relNum=='' && PrAdv=='' && relSts!=true){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Keyword to search the records '));
                return;
            }
                    
            try {
              selectedRelationshipIds.clear();      
              String soqlRel = 'SELECT Id,Name,Primary_Relationship_Contact__c,Relationship_Number__c,Relationship_Status__c,Primary_Relationship_Advisor__c FROM Relationship__c WHERE Name!=Null';
    
            if (relName<>''){
              soqlRel += ' AND Name LIKE \'%' + String.escapeSingleQuotes(relName).replace('*','') + '%\'';   
            }  
            if (RelNum<>''){
              soqlRel += ' AND Relationship_Number__c LIKE \'%'+String.escapeSingleQuotes(RelNum).replace('*','') + '%\'';   
            }  
            if (PrAdv<>''){
              soqlRel += ' AND Primary_Relationship_Advisor__c LIKE \'%'+String.escapeSingleQuotes(PrAdv).replace('*','') + '%\'';   
            }  
            if (RelSts==true){
              soqlRel += ' AND Relationship_Status__c =  \'Active\'';   
            }        
            else{
              soqlRel += ' AND Relationship_Status__c = \'InActive\''; 
            }
            System.debug('DEBUG:SOQL Query - '+soqlRel );
      
            List<Relationship__c> soqlLst = Database.query(soqlRel);        
        
            //gather data set
            setCon= new ApexPages.StandardSetController(soqlLst);
            setCon.setpageNumber(1);
            setCon.setPageSize(8);
        
            actionSelMap = new MAP<Integer,Boolean>();
            for(Integer i=0;i<=(Integer)this.setCon.getResultSize();i++)
                actionSelMap.put(i,false);
     
            refreshData(); 
        } 
        catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! something went wrong : '+e.getmessage()));
        }   
  }
  
  public void refreshData(){
      try {
          if(RelationshipsLstRecs==null)
              RelationshipsLstRecs = new List<RelWrap>();
          
          RelationshipsLstRecs.clear();
       
        if(setCon<>null){
        for(sObject r : setCon.getRecords()){
            Relationship__c relRec = (Relationship__c)r;
            
            RelWrap row = new RelWrap(relRec,false);
             if(this.selectedRelationshipIds.contains(relRec.Id)){
                row.IsSelected=true;
            }
            else{
                row.IsSelected=false;
            }
            RelationshipsLstRecs.add(row);            
        }
        System.debug('Size of Data'+RelationshipsLstRecs.size()+'Check Data***'+RelationshipsLstRecs);
        }
      } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! something went wrong : '+e.getmessage()));

      } 
  }  
  
  public PageReference AddSelectedToCampaign() {
     try {
         UpdateSelectedListMethod();
         PageReference p;
         Set<Id> AccIds = new Set<Id>();
         
         System.debug('DEBUG: Adding Relationships to Campaigns - BEGIN');
         System.debug('DEBUG: Selected Relationships -' + selectedRelationshipIds);
         
         if(selectedRelationshipIds.size()<>null && !selectedRelationshipIds.isempty()) {             
             relLst = [SELECT Id, Name, Primary_Relationship_Contact__c FROM Relationship__c WHERE Id IN :selectedRelationshipIds ];     
             System.debug(relLst);
     
             craLst = new List<Campaign_Relationship_Association__c>();
             cmLst = new List<CampaignMember>();
             for(Relationship__c r: relLst) {
                Campaign_Relationship_Association__c cra = new Campaign_Relationship_Association__c(Relationship__c=r.id,Campaign__c=cmp.id);
                craLst.add(cra);
                AccIds.add(r.Primary_Relationship_Contact__c );
             }   
               
             conLst = [SELECT Id FROM Contact WHERE AccountId IN :AccIds AND Id NOT IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :cmp.Id)];
             for(Contact c : conLst) {
                 CampaignMember newCm = new CampaignMember(CampaignId=cmp.Id, ContactId=c.Id);
                 cmLst.add(newCm);
             }
             
             insert cmLst;
             insert craLst;
             p = new PageReference('/'+cmp.id);
             System.debug('DEBUG: Adding Relationships to Campaigns - END');
         }
         else {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Records not selected, Please select atleast one'));
             p = null;
         }
         
         return p;
         
     } catch(Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Record(s) Found, Please Select Record(s) to Add'));
          return null;
    }     
  }
  
   public PageReference Cancel() {
       PageReference p = new PageReference('/'+cmp.id);
       p.setRedirect(true);
       return p;
   }
  
    // All to do with checkboxes and pagination -----    
      
    /*
    *   return whether previous page exists
    */
    public Boolean getHasPrevious(){
        if(this.setCon<>null)
        return setCon.getHasPrevious();
        return false;        
    }   
    
    /*
    *   return whether next page exists
    */
    public Boolean getHasNext(){
        if(this.setCon<>null)
        return setCon.getHasNext();
        return false;           
    }    
    
    public Integer PageNumber{
        get{
        if(this.setCon<>null)
        return setCon.getPageNumber(); 
        return 0;       
        }
        set{
        PageNumber = value;
        }        
    }    
    
    /*
    *    return total pages
    */
    Public Integer getTotalPages(){
        
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        
        Decimal pages = totalSize/pageSize;
       
        return (Integer)pages.round(System.RoundingMode.CEILING);        
    }    
    
         
    public void UpdateSelectedListMethod() {        
        
        for(RelWrap r : RelationshipsLstRecs){            
            if(r.IsSelected ==true) selectedRelationshipIds.add(r.tRel.id);  
            else if(selectedRelationshipIds.contains(r.tRel.id))selectedRelationshipIds.remove(r.tRel.id);                     
        }         
    }
  

    /*
    *   advance to next page
    */
    public void doNext(){        
        UpdateSelectedListMethod();
        if(this.setCon.getHasNext())
            this.setCon.next();           
        refreshData();          
    }
        
    /*
    *   advance to previous page
    */
    public void doPrevious(){        
        UpdateSelectedListMethod();
        if(this.setCon.getHasPrevious())
            this.setCon.previous();
       refreshData();                
    }  
      
    /*
    *   Wrapper class that represents a row
    */
    public with sharing class RelWrap{
        
        public Relationship__c  tRel{get;set;}
        public Boolean IsSelected{get;set;}
        
        public RelWrap(Relationship__c  r, Boolean s) {
            this.tRel=r;
            this.IsSelected=s;
        }        
    }
    
    public boolean GetIsSearching(){
        if(this.setCon<>null)return true;
        return false;
    }
}