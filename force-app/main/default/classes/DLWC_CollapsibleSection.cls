/**
 * @description Class to fetch records to be in collapsible section
 */
public with sharing class DLWC_CollapsibleSection {

  /**
   * @description Fetches Account record details
   * @return List<Account>
   */
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts() {
    List<Account> accountRec = new List<Account>();
    accountRec = [SELECT Id,Name,AccountNumber,Phone,Industry,CreatedDate,Type,Rating from Account LIMIT 5];
    return accountRec;
  }

}