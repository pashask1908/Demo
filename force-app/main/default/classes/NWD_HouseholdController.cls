public class NWD_HouseholdController {
    
    @AuraEnabled
    public static List<NWD_Citizen__c> getFMembers() {
    return [SELECT Id, Name, First_Name__c, Last_Name__c, Age__c, Gender__c, Relationship_To_Houshold__c FROM NWD_Citizen__c ORDER BY CreatedDate DESC];
      }
    
    @AuraEnabled
    public static NWD_Citizen__c saveCitizen(NWD_Citizen__c cit) {

    upsert cit;
    return cit;
    }

}