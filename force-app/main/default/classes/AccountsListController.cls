public class AccountsListController{
//public List<Account> accs {get; set;}
public List<Account> getAccounts(){

//List<Account> actList = new List<Account>();
return [SELECT CreatedbyID, CreatedBy.Name, Account.Name,(SELECT name,Contact.FirstName, Contact.LastName 
             FROM Account.Contacts) FROM Account];
            
}
}