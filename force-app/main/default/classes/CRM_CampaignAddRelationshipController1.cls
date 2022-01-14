public with sharing class CRM_CampaignAddRelationshipController1 {
   
 
  public string relName;
  public final campaign cmp;
  public List<Campaign_Relationship_Association__c> craLst;
  public List<Relationship__c> relLst; 
  public List<CampaignMember> cmLst;
  public List<Contact> conLst;
  public string eText{get;set;}
  
  public List<CCWRowItem> RelationshipsLstRecs {get;set;} 
  
  public List<Relationship__c> relationshipsLst {get;set;}
 /*
   public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  } hello123 confused still
 
 
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 
 /* public String debugSoql {
    get { return soqlRel + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  } */
      
   public CRM_CampaignAddRelationshipController1(ApexPages.StandardController controller) {
   cmp = (Campaign)controller.getRecord();
   runSearch();
       }
   public PageReference runSearch() {
     
    relName = Apexpages.currentPage().getParameters().get('relName')+'*';
    runQuery();
    return null;
  }
 
 
  public void runQuery() {
 
    try {   
      if(relationshipsLst<>null)relationshipsLst.clear();  
      else relationshipsLst = new List<Relationship__c>();
      if(selectedRelationshipIds<>null)selectedRelationshipIds.clear(); 
      else selectedRelationshipIds= new Set<Id>();
       List<Relationship__c> soslLst = (List<Relationship__c>) [FIND :relName RETURNING Relationship__c(Id,Name)][0];
        setCon= new ApexPages.StandardSetController(soslLst);
        setCon.setpageNumber(1);
        setCon.setPageSize(3);
        actionSelMap = new MAP<Integer,Boolean>();
        for(Integer i=0;i<=(Integer)this.setCon.getResultSize();i++)
        actionSelMap.put(i,false);
      
        refreshData();       
      
      
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops! something went wrong'+e.getmessage()));
    }
 
  }
  
  public void refreshData(){
      if(RelationshipsLstRecs==null)
      RelationshipsLstRecs = new List<CCWRowItem>();
      RelationshipsLstRecs.clear();
        if(setCon.getRecords().size()<>0){
        for(sObject r : setCon.getRecords()){
           Relationship__c relRec = (Relationship__c)r;
            
            CCWRowItem row = new CCWRowItem(relRec,false);
             if(this.selectedRelationshipIds.contains(relRec.Id)){
                row.IsSelected=true;
            }
            else{
                row.IsSelected=false;
            }
            RelationshipsLstRecs.add(row);            
        }
      //  System.debug('Size of Data'+RelationshipsLstRecs.size()+'Check Data***'+RelationshipsLstRecs);
        }
  }
 
  
     public PageReference AddSelectedToCampaign() {
     PageReference p;
     Set<Id> AccIds = new Set<Id>();
     if(selectedRelationshipIds.size()<>null && !selectedRelationshipIds.isempty()){
     relLst = [SELECT Id,Name,Primary_Relationship_Contact__c FROM Relationship__c WHERE Id in :selectedRelationshipIds ];
     
     System.debug(relLst);

     
     craLst = new List<Campaign_Relationship_Association__c>();
     cmLst = new List<CampaignMember>();
     for(Relationship__c r: relLst){
        Campaign_Relationship_Association__c cra = new Campaign_Relationship_Association__c(Relationship__c=r.id,Campaign__c=cmp.id,Name=r.Name);
        craLst.add(cra);
        AccIds.add(r.Primary_Relationship_Contact__c );
     }   
     insert craLst;
     
     conLst = [SELECT Id,AccountId FROM Contact WHERE AccountId in :AccIds];
     for(Contact c : conLst ){
         CampaignMember newCm = new CampaignMember(CampaignId=cmp.Id, ContactId=c.Id);
         cmLst.add(newCm);
     }
     insert cmLst;
     
     p = new PageReference('/'+cmp.id);  
     }
     else{
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Records not selected, Please select atleast one'));
         p = null;
     }
       
     return p;
  }
  
   public PageReference Cancel() {
       PageReference p = new PageReference('/'+cmp.id);
       return p;
   }
   
  public MAP<Integer,Boolean> actionSelMap { get; set; }
    
    public Boolean actionSel{
        get {        
        return actionSelMap.get((Integer)this.setCon.getPageNumber()) ;
        
        }
        set{
        actionSel = value;
            actionSelMap.put((Integer)this.setCon.getPageNumber(),actionSel);
        }
    }
  
    public String contextItem{get;set;}
 
     public ApexPages.StandardSetController setCon{get;set;}
    
    private Set<Id> selectedRelationshipIds;
  
    public Integer getSelectedCount(){
        
        return this.selectedRelationshipIds.size();
        
    }
  
    public Boolean getHasPrevious(){
        
        return setCon.getHasPrevious();
       
    }
    
      public Boolean getHasNext(){
        
        return setCon.getHasNext();
        
    }
    
    
    public Integer getPageNumber(){
        
        return this.setCon.getPageNumber();
        
    }
      
    Public Integer getTotalPages(){
        
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
        
        Decimal pages = totalSize/pageSize;
       
        return (Integer)pages.round(System.RoundingMode.CEILING);
        
    }
         
        public void doAllItem() {
        
        RelationshipsLstRecs = new List<CCWRowItem>();
        if(this.setCon.getRecords().size()<>0){
        for(sObject r : setCon.getRecords()){
            Relationship__c relRec = (Relationship__c)r;
            
            if(actionSelMap.get((Integer)setCon.getPageNumber())==true) selectedRelationshipIds.add(relRec.id);  
            else
            {if(selectedRelationshipIds.contains(relRec.Id))selectedRelationshipIds.remove(relRec.id); } 
            
            
            CCWRowItem row = new CCWRowItem(relRec,false);
             if(selectedRelationshipIds.contains(relRec.Id)){
                row.IsSelected=true;
            }
            else{
                row.IsSelected=false;
            }
            RelationshipsLstRecs.add(row);            
        }
        }
         
    }

    
       public void doSelectItem(){
        
        this.selectedRelationshipIds.add(this.contextItem);
        refreshData(); 
        
    }
   
  
    public void doDeselectItem(){
        
        this.selectedRelationshipIds.remove(this.contextItem);
        refreshData(); 
        
    }
    
     public void doNext(){
        
        if(this.setCon.getHasNext())
            this.setCon.next();
            refreshData(); 
         
    }
    
   
    public void doPrevious(){
        
        if(this.setCon.getHasPrevious())
            this.setCon.previous();
            refreshData(); 
                
    }
    
      public with sharing class CCWRowItem{
        
        public Relationship__c  tRel{get;set;}
        public Boolean IsSelected{get;set;}
        
        public CCWRowItem(Relationship__c  r, Boolean s){
            this.tRel=r;
            this.IsSelected=s;
        }
        
    }
}