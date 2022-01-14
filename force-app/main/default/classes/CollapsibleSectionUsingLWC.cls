public with sharing class CollapsibleSectionUsingLWC {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accountRec = new List<Account>();
        accountRec = [SELECT Id,Name,AccountNumber,Phone,Industry,CreatedDate,Type,Rating from Account LIMIT 6];
        return accountRec;
    }
}