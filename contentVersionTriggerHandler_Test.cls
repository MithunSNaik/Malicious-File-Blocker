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
* @description Test class for contentVersionTriggerHandler.
*************************************************************************************************************************************************************************/
@isTest
public class contentVersionTriggerHandler_Test {
    
    @isTest static void handleFileBlock(){
        //Featch Profile.
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        //Create user
        User usr = new User();
        usr.LastName = 'Test User';
        usr.ProfileId = p.Id;
        usr.Email='standardTestuser@test1.com';
        usr.Username = 'testusers13@test1.com';
        usr.Alias = 'standou';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey ='en_US';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.EmailEncodingKey  = 'UTF-8';
        insert usr;
        
        system.runAs(usr){
            Account acc = new Account();
            acc.Name = 'Test Account';
            insert acc;
            
            File_Blocker__mdt filemdt = new File_Blocker__mdt();
            filemdt.Approved_File_Extensions__c = 'zip';
            filemdt.Blocked_File_Error_Message__c = 'File type is not allowed for Account';
            filemdt.Blocked_Object_Name__c = 'Account';
            
            Contentversion cv = new Contentversion();
            cv.Title = 'ABC';
            cv.PathOnClient = 'test.bat';
            cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
            insert cv;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            //create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = acc.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;

            test.startTest();
            Contentversion cvs=[select Title, PathOnClient from Contentversion where title='ABC'];
            system.assertEquals('ABC', cvs.Title);
            test.stopTest(); 
        }
        
    }
    
}