/******************************************************************
* @author       Sanchita Kumari , Mithun 
* @date         2023-07-11
* @description  trigger to block from malicious file upload
******************************************************************/

trigger maliciousFileBlocker on ContentVersion (before insert,after insert) {
    if(Trigger.isAfter){            
        if(Trigger.isInsert || trigger.isUpdate){
            contentVersionTriggerHandler conhandler = new contentVersionTriggerHandler();
            conhandler.handleFileBlock(Trigger.new);
        }
    }
   /* if(Trigger.isBefore){            
        if(Trigger.isInsert || trigger.isUpdate){
            contentVersionTriggerHandler conhandler = new contentVersionTriggerHandler();
            conhandler.handleFileBlock(Trigger.new);
        }
    }*/
    
}