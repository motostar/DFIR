# Readme

## Splunk Dashboard

This Dashboard is built to automate and identify obvious anomalies in MicroSoft 365 audit logs, 
Dashboard itself is built using Splunk and can be ported to any SIEM platform if need be. 
The queries in this dashboard are meant to be base searches and have a potential to be built on top of and customized to cover much broader cases. 
The dashboard Queries are built on top of the sigma rules (reference: https://github.com/SigmaHQ/sigma/tree/master/rules/cloud/m365) 
available for M365 investigations. The dashboard in its current version covers following detection cases but not limited to:

* microsoft365_activity_by_terminated_user
* microsoft365_activity_from_anonymous_ip_addresses
* microsoft365_activity_from_infrequent_country
* microsoft365_data_exfiltration_to_unsanctioned_app
* microsoft365_from_susp_ip_addresses
* microsoft365_impossible_travel_activity
* microsoft365_logon_from_risky_ip_address
* microsoft365_new_federated_domain_added
* microsoft365_potential_ransomware_activity
* microsoft365_susp_inbox_forwarding
* microsoft365_susp_oauth_app_file_download_activities
* microsoft365_unusual_volume_of_file_deletion
* Microsoft365_user_restricted_from_sending_email

## Pre-requisites:
There are some prerequisites to deploy this dashboard in a splunk environment. 

 - Splunk Version: Dashboard is built using Splunk Cloud version 9.0.2209.2 and any Splunk instance supporting classic dashboard type can be used to host this dashboard.  
 - Macro : in order to generalize the search and make index independent a macro is created to query all non internal indexes in splunk. 
 - EventTypes: various event types are built to reduce the SPL complexity and avoid incorrect reference of log events 
 - SourceType: Dashboard is built on M365 Unified Audit Logs in CSV format, any other format may break the queries and may require rework.
 - One visualisation uses a custom timeline visualisation.

### Create a Macro
|Field|Argument|
|--|--|
| Name | ual |
| Definition | index=* |
| Arguments | leave blank |
| Validation Expression| leave blank|
| Validation Error Message | leave blank|

### Importing EventTypes
The SPL queries in this dashboard is simplified by using Eventtypes for various activities in M365 logs, for the SPLs to work you need to import this into Default folder of the App in splunk.
for eg. Copy the content of eveentypes.conf in to 

> <Home_Splunk>/etc/app/<name_of_the_app>/Default/eventtypes.conf

### Custom Timeline App
This investigator Dash uses custom visualization for displaying timeline analysis in Account investigator tab within Dashboard. 
Intgrated App can be downloaded from this [Splunk base Link](https://splunkbase.splunk.com/app/3120)
#### Installing the timeline App
 - Download the app from Splunk base portal
 - From Splunk UI Click on "Apps" dropdown and Select "ManageApps"
 - Under Manage Apps Page select "Install App from File"
 - Select "Choose File" to upload the .gz package that is downloaded from the splunk base
 - Select the "Upgrade app. Checking this will overwrite the app if it already exists."  option
 - Finally click on Upload button to complete the import of bundled timeline visualization App
