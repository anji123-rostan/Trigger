global class EMIDeduction implements Schedulable {
    
    global void execute(SchedulableContext SC){
        
        List<Id> achid = new List<Id>();
        List<Id> lid = new List<Id>();
        
        List<Loan__c> loanlist = [SELECT Id,Loan_Amount__c,  Loan_Acc_Number__c,Existing_Account_Holder__c, Account_Info__c,
                                  Name,Loan_Type__c,Tenure_Duration__c, EMI_Amount__c FROM Loan__c WHERE EMI_Amount__c > 0 ];
        
        
        for(Loan__c l : loanlist){
            
            if(l.EMI_Amount__c > 0 && l.Account_Info__c != null){
                achid.add(l.Account_Info__c);
                lid.add(l.id);
            }
        }
        
        List<Account_Info__c> aclist = [SELECT Id,Balance__c FROM Account_Info__c WHERE Id IN : achid];
        List<Loan__c> loans = [SELECT Id,Loan_Amount__c,Loan_Acc_Number__c,Account_Info__c,
                               Name,Loan_Type__c,Tenure_Duration__c,EMI_Amount__c FROM Loan__c WHERE id IN : lid];
        
        List<Account_Info__c> achlist = new List<Account_Info__c>();
        
        for(Loan__c loan : loans){
            
            for(Account_Info__c ac : aclist){
                
                if(loan.Account_Info__c == ac.id){
                    ac.Balance__c = ac.Balance__c -loan.EMI_Amount__c;
                    loan.Paid_EMI_Months__c=loan.Paid_EMI_Months__c + 1;
                    loan.Remaining_EMI_Months__c=loan.Tenure_Duration__c - loan.Paid_EMI_Months__c;
                    loan.Paid_Amount__c=loan.EMI_Amount__c * loan.Paid_Amount__c;
                    loan.Remainig_Pay_Amount__c=loan.Remaining_EMI_Months__c * loan.EMI_Amount__c;
                    
                }                   
                achlist.add(ac);
            }
        }
        update achlist;         
    }
}