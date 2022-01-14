public class NWD_MyBenefitsController {
@AuraEnabled
  /*public static List<ClientBenefit__c> getBenefits() {
   // return [SELECT Id, Name, First_Name__c, Last_Name__c FROM NWD_Citizen__c ORDER BY createdDate ASC];
      //system.debug([SELECT Id, Name, First_Name__c, Last_Name__c FROM NWD_Citizen__c ORDER BY createdDate ASC]);
      return [SELECT Id, Name,  citizen__r.Name, Agency__c, Program__c, Start_Date__c, End_Date__c FROM ClientBenefit__c];
  }*/
    
    public static List<ClientBenefit__c> getBenefits(String sortField, boolean isAsc) {
    String query = 'SELECT Id, Name, Citizen__r.Name, Agency__c, Program__c, Start_Date__c, End_Date__c';
        query += ' FROM ClientBenefit__c';
       if (sortField != '') {
         query += ' order by ' + sortField;
 
    // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
         if (isAsc) {
            query += ' asc';
         } else {
            query += ' desc';
         }
      }
      list <ClientBenefit__c> citList;
        try {
         system.debug('The query is' + query);
         citList = Database.query(query);
         List <ClientBenefit__c> retCitList = new List <ClientBenefit__c>();
 
         for (ClientBenefit__c cit: citList) {
            retCitList.add(cit);
          }
            system.debug('List in apex is '+retCitList);
         return retCitList;
      } 
      catch (Exception ex) {
         // for handle Exception
         return null;
      }
  }
}