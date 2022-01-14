public class UtilDW{
    
    public String GetAllField(String sObj) {
        String query = '';
        Datetime dt = Datetime.now().addHours(-48);
        String dtString = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String SobjectApiName = sObj;
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(SobjectApiName=='CaseHistory'){
          query = 'select ' + strFields + ' from ' + SobjectApiName+ ' where CreatedDate  >  ' +dtString ;// + 'limit 100';
        }
        else{
            query = 'select '  + strFields + ' from ' + SobjectApiName + ' where LastModifiedDate >  ' +dtString; // +' limit 100';
           //query = 'select '  + strFields + ' from ' + SobjectApiName + ' where LastModifiedDate >  ' +dtString +' limit 20';
          // query = 'select '  + strFields + ' from ' + SobjectApiName + ' where Id = 001q000000iwQNNAA2 ';
           
           query = 'select '  + strFields + ' from ' + SobjectApiName+ ' limit 100' + 'offset 500';
        
        }
            //query = 'select Id'  + ' from ' + SobjectApiName+ ' where CreatedDate> :Datetime.now().addDays(-2) ' +' limit 1';
        return query;
    }
    public String GetAllFieldsSfdcDw(String thisClassId)
    {
        String query = ' SELECT ApexClassId,CompletedDate,CreatedById,CreatedDate,ExtendedStatus,Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob where JobType = \'BatchApex\' AND ApexClassId = \'thisClassId\' AND CreatedDate < : DateTime.now().addHours(-12) order by CreatedDate desc';
        //query = query + ' limit 1';   
        System.debug('query here: @@@@@@@@@@@@@@@@@ ' +query);     
        return query;
    }
    public Decimal convertStringToDecimal(String field)
    {
        if(field == null)
            return null;
        return Decimal.valueOf(field);
    }
    Public Decimal convertBooleantoDecimal(boolean field){
        if(field == false)
            return 0;
        else if(field == true)
            return 1;
        else
            return 0;
    }
    Public String convertDecimaltoString(Decimal field){
        if(field == null)
            return null;

        return String.valueOf(field);
    }
    Public String convertBooleantoString(boolean field){
        if(field == false)
            return 'false';
        else if(field == true)
            return 'true';
        else
            return 'false';
    }
    Public String convertObjectToString(Object obj){
        if(obj == null)
            return null;
        return String.valueOf(obj);
    }
    Public String convertDateTimeToString(Datetime dt){
        if(dt == null)
            return null;
        return String.valueOf(dt);
    }
    Public String convertIntegerToString(Integer field){
        if(field == null)
            return null;
        return String.valueOf(field);
    }

}