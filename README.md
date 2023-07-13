# Salesforce Malicious File Blocker
The Salesforce Malicious File Blocker is a powerful tool designed to enhance the security of your Salesforce org by preventing the upload and execution of malicious files. 
This repository provides a comprehensive solution to protect your Salesforce instance from potential threats and keep your data safe

Approach Taken:
  1. Created Custom Meata Data Named File Blocker.
  2. Craeted Custom Fields like,
          1. Approved File Extensions.
          2. Blocked File Error Message.
          3. Blocked Object Name.
          4. Blocked Object Record Type Name
          5. Blocked Users
  3. Next Create custom Meta Data Record, where you want to block the file.
           1. Record Can be created for Whole object level, with out adding record type name.
           2. If only needed for perticular record type in object, add both Object name and record type name.


  Apex Trigger and Class: 
            1. Created Apex Trigger on contentversion in after and before event.
            2. Created Handler class to handle the manage logic and processing of data or events with in an application.

  Platform Event : 
            1. Platform Event is used to create a Exception loger record.


  Permission Set : 
             1. Permission set to give the whole applicable acess of the application. 

  Home Page and DashBoard, Report:
              1. Home Page and Dashboard Created to Track how many files blocked.

