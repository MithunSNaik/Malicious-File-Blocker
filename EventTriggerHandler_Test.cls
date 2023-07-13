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
* @description Test class for EventTriggerHandler.
*************************************************************************************************************************************************************************/
@isTest
public class EventTriggerHandler_Test {
    
    @isTest static void createErrorLog(){
        //Featch Profile.
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        //Create user
        User usr = new User();
        usr.LastName = 'Test User';
        usr.ProfileId = p.Id;
        usr.Email='standardTestuser@test.com';
        usr.Username = 'testusers123@test.com';
        usr.Alias = 'standou';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey ='en_US';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.EmailEncodingKey  = 'UTF-8';
        insert usr;
        
        system.runAs(usr){

            //Create Log record.
            Error_Logging__e event = new Error_Logging__e();
            event.Object_Name__c = 'Account'; 
            event.Error_Message__c = 'File type is not allowed for Account';
            event.File_Extension__c = 'zip';
            event.Log_Time__c = system.today();
            event.Record_Type_Name__c = 'Test Record Type';
            
            Test.startTest();
            Database.saveResult sr = EventBus.publish(event);
            Test.stopTest();
            
            system.assertEquals(true, sr.isSuccess());
        }
    }
    
}