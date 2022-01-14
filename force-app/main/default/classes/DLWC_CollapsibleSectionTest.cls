/**
 * @description Test Class to validate DLWC_CollapsibleSection Class
 */
@isTest
public class DLWC_CollapsibleSectionTest {
    /**
 * @description Creates test account record
 */
    static testMethod void insertNewAccount() {
        Account account = new Account();
        account.Name = 'TestCollapsible';
        account.AccountNumber = '98765';
        account.Type = 'Prospect';
        account.Phone = '9000123456';
        account.Industry = 'Agriculture';
        account.Rating = 'Warm';
        insert account;
        DLWC_CollapsibleSection.getAccounts();
    }
    
}