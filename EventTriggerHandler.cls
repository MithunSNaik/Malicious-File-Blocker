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
* @description Handler class for exception logger.
*************************************************************************************************************************************************************************/
public class EventTriggerHandler {
    public  void insertException(List<Error_Logging__e> errorLog){
        List<Exception_Log__c> errLogList = new List<Exception_Log__c>();   
        for(Error_Logging__e ex:errorLog){ 
            Exception_Log__c errLog = new Exception_Log__c();
            errLog.Object_Name__c = ex.Error_Log__c;
            errLog.Error_Message__c = ex.Error_Message__c;
            errLog.File_Extension__c = ex.File_Extension__c;
            errLog.Log_Time__c = ex.Log_Time__c;
            errLog.Object_Name__c = ex.Object_Name__c;
            errLog.Record_Type_Name__c = ex.Record_Type_Name__c;
            errLogList.add(errLog);
        }
        insert errLogList;
    }
}
