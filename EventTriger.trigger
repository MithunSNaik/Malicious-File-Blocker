/*************************************************************************
#
# Royal Dutch Shell
# __________________
#
# Copyright (c) 2023, Royal Dutch shell. All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Royal Dutch Shell and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Royal Dutch Shell
# and its suppliers and may be covered by U.S. and Foreign Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Royal Dutch Shell.
# *************************************************************************/
/*************************************************************************************************************************************************************************
* @author      Innovation Mavericks - Hackathon 2023
* @date        June 13, 2023
* @description Trigger on platform event.
*************************************************************************************************************************************************************************/
trigger EventTriger on Error_Logging__e (after insert) {
      if(Trigger.isAfter){            
        if(Trigger.isInsert || trigger.isUpdate){
            EventTriggerHandler eventHandler = new EventTriggerHandler();
            eventHandler.insertException(Trigger.new);
        }
    }
}
