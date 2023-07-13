trigger EventTriger on Error_Logging__e (after insert) {
      if(Trigger.isAfter){            
        if(Trigger.isInsert || trigger.isUpdate){
            EventTriggerHandler eventHandler = new EventTriggerHandler();
            eventHandler.insertException(Trigger.new);
        }
    }
}