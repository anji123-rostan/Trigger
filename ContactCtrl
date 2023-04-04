public class ContactCtrl {
    @AuraEnabled(cacheable=true)
    public static List<contact>getContactComp(string accId){
        try {     
            return[
                SELECT AccountId, Id, FirstName, LastName
                FROM Contact
                WHERE AccountId =: accId
                WITH SECURITY_ENFORCED
            ];    
        } catch (Exception e) { 
            throw new AuraHandledException(e.getMessage());   
        }
    }
}
