global without sharing class CRM_CampaignAddselected {

    public CRM_CampaignAddselected(ApexPages.StandardController controller) {
      }
    public static void AddSelectedToCampaign(List<Relationship__c> relLst, Campaign cmp) {

        List<Campaign_Relationship_Association__c> craLst = new List<Campaign_Relationship_Association__c>();
        List<CampaignMember> cmLst = new List<CampaignMember>();
        Set<Id> AccIds = new Set<Id>();

        for (Relationship__c r : relLst) {
            Campaign_Relationship_Association__c cra = new Campaign_Relationship_Association__c(Relationship__c = r.id, Campaign__c = cmp.id);
            craLst.add(cra);
            AccIds.add(r.Primary_Relationship_Contact__c);
        }

        List<Contact> conLst = [SELECT Id FROM Contact WHERE AccountId IN :AccIds AND Id NOT IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :cmp.Id)];
        for (Contact c : conLst) {
            CampaignMember newCm = new CampaignMember(CampaignId = cmp.Id, ContactId = c.Id);
            cmLst.add(newCm);
        }

        insert cmLst;
        insert craLst;
    }
    public static void AddSelectToCam(List<Relationship__c> relLst, Campaign cmp) {

        List<Campaign_Relationship_Association__c> craLst = new List<Campaign_Relationship_Association__c>();
        List<CampaignMember> cmLst = new List<CampaignMember>();
        Set<Id> AccIds = new Set<Id>();

        for (Relationship__c r : relLst) {
            Campaign_Relationship_Association__c cra = new Campaign_Relationship_Association__c(Relationship__c = r.id, Campaign__c = cmp.id);
            craLst.add(cra);
            AccIds.add(r.Primary_Relationship_Contact__c);
        }

        List<Contact> conLst = [SELECT Id FROM Contact WHERE AccountId IN :AccIds AND Id NOT IN (SELECT ContactId FROM CampaignMember WHERE CampaignId = :cmp.Id)];
        for (Contact c : conLst) {
            CampaignMember newCm = new CampaignMember(CampaignId = cmp.Id, ContactId = c.Id);
            cmLst.add(newCm);
        }

        insert cmLst;
        insert craLst;
    }
    public void star() {
        Set<Id> AccIds1 = new Set<Id>();



    }
    static webService String DeleteRelationshipFromCampaign(List<Id> records) {
        List<Campaign_Relationship_Association__c> recToDelete = [SELECT id,Campaign__c,Relationship__c,Relationship__r.Primary_Relationship_Contact__c FROM Campaign_Relationship_Association__c WHERE id = :records];
        Set<Id> AccIds = new Set<Id>();

        for (Campaign_Relationship_Association__c cra : recToDelete) {
            AccIds.add(cra.Relationship__r.Primary_Relationship_Contact__c);

        }
        List<CampaignMember> cmLstToDelete = [SELECT Id,ContactId FROM CampaignMember WHERE ContactId IN (SELECT Id FROM Contact WHERE AccountId IN :AccIds)];
        //return 'CampaignMembers to Delete:'+ cmLstToDelete+'\n ####### \n Junstion records to Delete: '+recToDelete ;
        delete recToDelete;
        delete cmLstToDelete;

        return 'Records will be deleted in 2 secs';
    }
}