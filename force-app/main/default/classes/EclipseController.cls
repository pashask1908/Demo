public class EclipseController {
    public Account objPolicyMember {get; set;}
    public EclipseController()
    {
        objPolicyMember = [SELECT Id,Name FROM Account LIMIT 1]; 
    }
}