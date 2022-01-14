/**
 * Created by chansk on 7/26/2019.
 */

public with sharing class Sample1 {
    public void addRecord() {
        try {
            Account acct = new Account(Name = 'SFDC Account');
            insert acct;

            // Once the account is inserted, the sObject will be
            // populated with an ID.
            // Get this ID.
            ID acctID = acct.ID;
            Integer i=0;
            for (i=0;i<200;i++){
                Account acct1 = new Account(Name = 'SFDC Account');
                insert acct1;
            }

            // Add a contact to this account.
            Contact con = new Contact(
                    FirstName = 'Joehh',
                    LastName = 'Smithhh',
                    Phone = '415.555.1212',
                    AccountId = acctID);
            insert con;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

}