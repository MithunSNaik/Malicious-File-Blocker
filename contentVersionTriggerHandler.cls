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
* @description Handler class for Block file extensions
*************************************************************************************************************************************************************************/
public class contentVersionTriggerHandler {
    
    Public static  List<File_Blocker__mdt> fileMetaData = new List<File_Blocker__mdt>();
    Map<String,File_Blocker__mdt> fileMetaMap = new Map<String,File_Blocker__mdt>();
    Public static String fileExtension;
    
    
    public  void handleFileBlock(List<ContentVersion> fileList){
        set<Id> contDocIdSet=new set<Id>(); 
        Map<Id,String> objectToDocIdMap=new Map<Id,String>();
        List<String> lstApprovedFileExtension = new List<String>();
        List<String> lstUsers = new List<String>();
        String errorMsg;
        string ObjName;
        String rctypeName;
        try{
            String loggedInUserName = [SELECT Name FROM User WHERE Id=:System.UserInfo.getUserId()].name;
            for(File_Blocker__mdt fileMeta:[select DeveloperName,Approved_File_Extensions__c,Blocked_File_Error_Message__c, Blocked_Object_Name__c,
                                            Blocked_Object_Record_Type_Name__c,Blocked_Users__c from File_Blocker__mdt]){
                                                fileMetaMap.put(fileMeta.Blocked_Object_Name__c, fileMeta);                 
                                            }
            for(ContentVersion contVer:fileList)
            {
                contDocIdSet.add(contVer.ContentDocumentId);
            }
            for(contentdocumentlink cdLink:[select LinkedEntityId,LinkedEntity.recordTypeId,ContentDocumentId from contentdocumentlink where ContentDocumentId IN:contDocIdSet]){
                if((cdLink.LinkedEntityId).getSObjectType().getDescribe().getName() != 'User'){
                    ObjName = (cdLink.LinkedEntityId).getSObjectType().getDescribe().getName();
                }
                String recordTypeId=cdLink.LinkedEntity.recordTypeId;
                if(recordTypeId != Null){
                    rctypeName =Schema.getGlobalDescribe().get(ObjName).getDescribe().getRecordTypeInfosById().get(recordTypeId).getDeveloperName();  
                }else{
                    rctypeName = null;
                }
                
                if(fileMetaMap.containsKey(ObjName)){
                    lstApprovedFileExtension = (fileMetaMap.get(ObjName).Approved_File_Extensions__c).split(';');
                    errorMsg =fileMetaMap.get(ObjName).Blocked_File_Error_Message__c;
                    lstUsers = (fileMetaMap.get(ObjName).Blocked_Users__c).split(';');
                }
                objectToDocIdMap.put(cdLink.ContentDocumentId,ObjName);
            }
            
            for(ContentVersion contVer:fileList){
                if(objectToDocIdMap.get(contVer.ContentDocumentId)!=null)
                {
                    Integer index=(contVer.PathOnClient).indexOf('.');
                    fileExtension=(contVer.PathOnClient).subString(index+1);
                    if(!(lstApprovedFileExtension.contains(fileExtension)) && lstUsers.contains(loggedInUserName)){
                        contVer.addError(errorMsg);
                        Error_Logging__e myEvent = new Error_Logging__e();
                        myEvent.Object_Name__c = fileMetaMap.get(ObjName).Blocked_Object_Name__c;
                        myEvent.Error_Message__c = fileMetaMap.get(ObjName).Blocked_File_Error_Message__c;
                        myEvent.Log_Time__c = system.today();
                        myEvent.File_Extension__c = fileExtension;
                        myEvent.Record_Type_Name__c = fileMetaMap.get(ObjName).Blocked_Object_Record_Type_Name__c;
                        EventBus.publish(myEvent);  
                    }
                    
                }
            }  
        }catch(exception e){
            handleException(e);
        }
    }
    //Method to create exception when code fails.
    public static void handleException(Exception e){
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        String className = stackTrace.substringAfter('.').substringBefore('.');	
        String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
        Exception_Log__c excLog = new Exception_Log__c();
        excLog.Exception_Message__c = e.getMessage();
        excLog.Exception_Type__c = e.getTypeName();
        excLog.Line_Number__c = e.getLineNumber();
        excLog.MethodName__c=methodName;
        excLog.ClassName__c=className;
        insert excLog; 
    }
}
