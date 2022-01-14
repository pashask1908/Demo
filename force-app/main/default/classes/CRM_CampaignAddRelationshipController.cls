public with sharing class CRM_CampaignAddRelationshipController {
   public List<Relationship__c> relst{get; set;}
   public String RelName{get; set;}
    public List<Relationship__c> results {get;set;}
    Public List<Relationship__c> RelnList {get;set;}
   public CRM_CampaignAddRelationshipController(ApexPages.StandardController controller) {

    }
    public PageReference doSearch(){
      RelnList = new List<Relationship__c>();
       // relst=[Select id,Name from Relationship__c where Name=:RelName];
       // Results=(List<Relationship__c>) [FIND :RelName RETURNING Relationship__c(Id,Name,ownerid,Primary_Relationship_Contact__c )][0];
    // string searchQuery = 'FIND \'' +RelName+'*\' IN ALL FIELDS RETURNING Idea(Id, title, body, categories, createddate, lastmodifieddate)';
     
    String querySOSL = 'FIND\'' + RelName + '*\'IN ALL FIELDS RETURNING Relationship__c(Id,Name,ownerid,Primary_Relationship_Contact__c )';
     List<List<Sobject>> searchList=search.query(querySOSL);
     RelnList = ((List<Relationship__c>)searchList[0]);
     return null;
      }
    public void addSelectedToCampaign(){
    }
    public pageReference Cancel(){
    return null;
    }

}