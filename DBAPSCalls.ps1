#Break statement added to stop you from accidentally running all the functions by clicking 'Run Script' or hitting F5
    Write-Host 'Stop hitting F5'
    break
    $env:PSModulePath = $env:PSModulePath + ";c:\Powershell\Modules"
    $env:PSModulePath = $envPSModulePath –replace “;c:\\Poweshell\Modules” 
    $psISE.Options.ShowToolBar=$True
    #Get Module function list
    Get-Command -Module Attach-Database #sqlserver
    #View function definition
    (Get-Command Attach-Database).Definition
    Get-Help -Name SQLPS -Full
    #$env:PSModulePath + ';c:\ModulePath'
    Remove-Module -Name SQLServer
    Import-Module -Name dbatools
    Get-Command -Name New-RsFolder  | Select-Object -ExpandProperty Definition
    Get-SqlAgent -ServerInstance M030 | Get-SqlAgentJob -Name phonelistupdate | Format-Table –AutoSize
    Get-Command -Module dbatools #-CommandType cmdlet *RDS*
    Get-Module -ListAvailable
    Test-NetConnection -ComputerName NJ1PRODE -Port 1433 -Verbose
    Test-NetConnection -ComputerName NJ1SAND1 -Port 3306 -Verbose
    # check data providers
    (New-Object system.data.oledb.oledbenumerator).GetElements() | select SOURCES_NAME, SOURCES_DESCRIPTION

#Copy Agent Jobs
Copy-DbaAgentJob -Source NJ1PRODN -Destination "[NJ1SQL16N1\NJ1PRODN]" -WhatIf 

#Get AD account info, second cmdlet call returns all properties.
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
import-module - activedirectory
    Get-ADUser -Filter  'SamAccountName -like "*NJ1PRODN16*"'  | Select-Object * 
    Get-ADUser -Filter  'SamAccountName -like "*Langdon"' -Properties * | Select-Object LockedOut    
    Get-ADUser -Filter  'SamAccountName -like "SQLAMXQM*"'  #| Select-Object Name
    Get-ADUser JJackson -Properties *
    get-adgroup -Filter "name -like '*SMS Development*'" -Properties * | select name
    Get-AdGroup -Filter {Name -like ‘*SMS Development*’} -Properties * | select Name, Description 

#Add SQL Login
    Add-SqlLogin -ServerInstance "NJ1DEVC" -LoginName "MyLogin" -LoginType "SqlLogin" -DefaultDatabase "master" -Enable
    #Add Server Login - SA
    #USE [master]
    #GO
    #CREATE LOGIN [MATHEMATICA\wmiorion] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
    #GO
    #ALTER SERVER ROLE [sysadmin] ADD MEMBER [MATHEMATICA\wmiorion]
    #GO

#Add login, user, and permissions to a database
    New-WinLoginUserRoles -instance 'SQL_AWSPROD01' -Winlogin 'MATHEMATICA\ARodeiro' -dbname 'EmployeeCentral' -dbroles 'public'  
    New-WinLoginUserRoles -instance 'NJ1DEVE' -Winlogin 'MATHEMATICA\JDrury' -dbname 'Coreset_Cleaning_Platform' -dbroles 'db_datareader'   
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\BLi" -dbname '40286_FAMLE_nFORM' -dbroles 'db_datareader, db_executor'
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\JHarrington" -dbname '50515_FACES19_SMS' -dbroles 'db_datareader, db_datawriter, db_executor'  
    New-WinLoginUserRoles -instance 'NJ3PRODE' -Winlogin "Mathematica\DMunipally" -dbname 'Plus' -dbroles 'db_developer, db_ddladmin'  
    New-WinLoginUserRoles -instance 'NJ1PRODM16' -Winlogin 'Mathematica\VBoroveva' -dbname 'JIRA_Cloud-B' -dbroles 'db_owner'
    New-WinLoginUserRoles -instance 'NJ1PRODE' -Winlogin 'Mathematica\ADeng' -dbname 'msdb' -dbroles 'DatabaseMailUserRole'

#Revoke ATO Permissions
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\DOConner" -dbname '50390_PODE' -dbroles 'db_datareader, db_executor'
    Import-Module sqlps -disablenamechecking
    Invoke-Sqlcmd –ServerInstance 'NJ3PRODC' –Database 50390_PODE –Query 'GRANT VIEW DEFINITION On database::[50390_PODE] TO [MATHEMATICA\DOConnor]'
    
    Invoke-Sqlcmd –ServerInstance 'NJ3PRODC' –Database 50327_EmplCoaching_SMS –Query 'REVOKE VIEW DEFINITION ON OBJECT::dbo.tlkpSetting FROM [MATHEMATICA\MMonteiro];'
    Invoke-Sqlcmd –ServerInstance 'NJ3PRODC' –Database 40286_FAMLE_nFORM_Preview –Query 'GRANT UPDATE ON OBJECT::dbo.tlkpSetting TO [MATHEMATICA\MMonteiro];'


#Grant object level permissions
    Import-Module sqlps -disablenamechecking
    #New-WinLoginUserRoles -instance 'NJ1PRODM' -Winlogin 'Mathematica\EmployeeRoutingUsers' -dbname 'DeltekCP' -dbroles 'puCWolfendalec'
    Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database 40286_FAMLE_nFORM –Query 'GRANT EXECUTE ON [dbo].[ExportUFRASample] TO [MATHEMATICA\SLauffer]'

#Redgate SQL Compare permissions to sync databases
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\DOConnor" -dbname '50390_PODE' -dbroles 'db_datareader, db_executor'
    Invoke-Sqlcmd –ServerInstance 'NJ3PRODC' –Database 50390_PODE –Query 'GRANT VIEW DEFINITION On database::[50390_PODE] TO [MATHEMATICA\DOConnor]'
    Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database 50390_PODE –Query 'GRANT SHOWPLAN TO [Mathematica\NWu]'
    Invoke-Sqlcmd –ServerInstance NJ1DEVC –Database master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\TTrainor]'

#Deltek SAS Report Permissions
    New-WinLoginUserRoles -instance 'NJ1PRODCore' -Winlogin 'Mathematica\JMastrianni' -dbname 'DELTEKTE' -dbroles 'public'
    #-----------------------------------------------------------------------------------------------------------------------------------------
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT EXECUTE ON [dbo].[mprspExpensesByProjecttask] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT EXECUTE ON [TC_0012].[mprspDept39And51And53byProject] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT EXECUTE ON [TC_0012].[mprspDept39And51And52And53byProject] TO [Mathematica\JMastrianni]' 
    #-----------------------------------------------------------------------------------------------------------------------------------------
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[EXP_RPT_CHARGE_ALLOCATIONS] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[EXP_RPT_EXPENSE] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[EXP_RPT] TO [Mathematica\JMastrianni]' 
    #-----------------------------------------------------------------------------------------------------------------------------------------
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [dbo].[mprvw_SAS_TSG_ETHours] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[TS_CELL] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[TS_LINE] TO [Mathematica\JMastrianni]' 
    Invoke-Sqlcmd –ServerInstance NJ1PRODCore –Database DELTEKTE –Query 'GRANT SELECT ON [TC_0012].[EMPL] TO [Mathematica\JMastrianni]' 
  
#Backup/Archive a single database  
    Import-Module sqlps -disablenamechecking
    Invoke-BackupDatabase -orginst 'NJ1DEVE' -dbname '50273_PREPPM' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks'
    Invoke-BackupDatabase -orginst 'NJ1DEVC' -dbname '50037_ECE_Cost' -bkdir '\\mathematica.net\NDrive\Transfer\MMonteiro'
    Invoke-BackupDatabase -orginst 'SQL_AWS3P01' -dbname 'abrahrms_live_840' -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon'
    Invoke-BackupDatabase -orginst 'SQL_AWSPROD01' -dbname 'OnBaseToABRA' -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon'
    Invoke-Sqlcmd –ServerInstance SQL_AWS3P01 –Database master –Query 'ALTER DATABASE [OmtoolServerMetaDataSet] SET OFFLINE WITH ROLLBACK IMMEDIATE' 

#Backup SMS a single database  
    Invoke-BackupDatabase -orginst 'NJ1DEVC' -dbname '50327_EmplCoaching_SMS' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks'
    Invoke-RestoreAsDatabase -desinst 'NJ1PRODM' -dbname 'OnBaseProd' -asdbname '50024_MIHOPE-SMSTest' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\prod\Baks' -versionlevel 'Version120' -replace
    New-WinLoginUserRoles -instance 'NJ1DEVE' -Winlogin "Mathematica\JCarsley" -dbname '11123_AWS_SMS' -dbroles 'db_developer, db_ddladmin'  
    New-WinLoginUserRoles -instance 'NJ1DEVE' -Winlogin "Mathematica\SMS_DTIDev" -dbname '50658_DTI_SMS' -dbroles 'db_datareader, db_datawriter, db_executor'  

#Restore a single database from archive
    import-module sqlps -disablenamechecking
    Invoke-RestoreDatabase -desinst 'NJ1DEVE' -dbname 'SMSDeploymentLogs' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks' -versionlevel 'Version120' -replace
    Invoke-RestoreDatabase -desinst 'NJ3PRODE' -dbname '50949_TCM_SMS' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks' -versionlevel 'Version120' -replace
    Invoke-RestoreDatabase -desinst 'NJ1PRODM' -dbname 'OnBaseToABRA' -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon' -versionlevel 'Version120' -replace

#Restore AS database with a different name
    Invoke-RestoreAsDatabase -desinst 'NJ1DEVC' -dbname '50327_EmplCoaching_SMS' -asdbname 'SMSBaseV5_ATO' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks'  -versionlevel 'Version120' -replace
    Invoke-RestoreAsDatabase -desinst 'NJ3STGC' -dbname '50327_EmplCoaching_SMS' -asdbname '50327_EmplCoaching_SMS_Test' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\dev\Baks' -versionlevel 'Version120' -replace
    New-WinLoginUserRoles -instance 'NJ1DEVE' -Winlogin "Mathematica\SMS_TNTPDev" -dbname '50530_TNTP_SMS' -dbroles 'db_datareader, db_datawriter, db_executor'
    Invoke-RestoreAsDatabase -desinst 'SQL_AWS3P01' -dbname 'OnBaseProd' -asdbname 'OnBaseProd_0226' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\prod\Baks' -versionlevel 'Version120' #-replace

#Backup and restore single database

    Invoke-BackupRestoreDB -orginst 'SQL_AWSPROD01' -desinst 'NJ1DEVM' -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon'  -dbname 'OnBaseToABRA' -versionlevel 'Version120' -replace #-offline
    Invoke-BackupRestoreDB -orginst 'NJ1DEVE' -desinst 'NJ3STGE' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Stg\Baks'  -dbname '50273_PREPPM' -versionlevel 'Version120' -replace #-offline
    Invoke-BackupRestoreDB -orginst 'NJ3PRODE' -desinst 'NJ1PRODE' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks'  -dbname '50522_SNMCS2_SMS' -versionlevel 'Version120' -replace -offline
    #Invoke-BackupRestoreDB -orginst 'NJ1PRODM' -desinst 'NJ1ProdCore' -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon'  -dbname 'GovWin72_SP2010DM_Content' -versionlevel 'Version120' -replace -offline

#Backup/restore steps to refresh production data to staging  
    
    Invoke-BackupDatabase -orginst 'NJ3PRODC' -dbname '50327_EmplCoaching_SMS' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks'
    Invoke-RestoreAsDatabase -desinst 'NJ3STGC' -dbname '50327_EmplCoaching_SMS' -asdbname '50327_EmplCoaching_SMS_Test' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks' -versionlevel 'Version120' -replace
    New-WinLoginUserRoles -instance 'NJ3STGC' -Winlogin "Mathematica\ADeng" -dbname '50327_EmplCoaching_SMS_Test' -dbroles 'db_developer, db_ddladmin'  


#Backup and restore databases from a csv file.  Migration script

    #Invoke-BackupRestoreWithCSV -orginst 'SQL_AWS3P01' -desinst 'NJ1DEVE' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Dev\Baks' -path 'c:\Powershell\Text\databases.txt' -versionlevel 'Version120'-replace #-offline
    Invoke-BackupRestoreWithCSV -orginst 'SQL_AWS3P01' -desinst 'NJ1PRODCORE' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks' -path 'c:\Powershell\Text\databases.txt' -versionlevel 'Version120'-replace #-offline

#Backup and restore databases for TFS migration
    #1 Backup TFS 2010 db
    Invoke-BackupDatabase -orginst 'SQL_TFSPROD01' -dbname "TFs_IS_Source" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Dev\Baks\'
    #2 Restore to 2015
    Invoke-RestoreDatabase -desinst 'NJ1DEVC' -dbname "TFs_IS_Source" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Dev\Baks\' -versionlevel 'Version120' -replace
    #3 Backup from TFS 2015
    Invoke-BackupDatabase -orginst 'NJ1DEVC' -dbname "TFs_IS_Source" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks\'
    #4 Restore to 2017
    Invoke-RestoreDatabase -desinst 'NJ1PRODC' -dbname "TFs_IS_Source" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Archive\Prod\Baks\' -versionlevel 'Version120' -replace
    # Command Line to delete collection
    # TFSConfig Collection /delete /CollectionName:"Sandbox_TPC"
#Create a new database
   New-Database -orginst 'NJ1DEVC' -dbname '50813_UPL_test' -datafilesize 1024 -datafilegrowth 512 -logfilesize 512 -logfilegrowth 256 

#List Active Nodes 
    Get-ActiveNode -instances "NJ1PRODC"
    Get-ActiveNode -instances "NJ3PRODE"
    Get-ActiveNode -instances "SQL_AWS3P01"
    Get-ActiveNode -instances "SQL_ISDEV01"
    Get-ActiveNode -instances "SQL_AWSPROD01"
    Get-ActiveNode -instances "SQL_DMADEV01"
    Get-ActiveNode -instances "SQL_Warehouse01"
    Get-ActiveNode -instances "NJ3SQL14E2"

#Get Disk space info 
    Get-DiskSpace -instance "NJ1DEVE"
     Invoke-Sqlcmd –ServerInstance NJ3PRODEBI –Database DBA –Query 'SELECT TOP 78 * from dbo.diskspace order by created DESC' | Format-Table -Auto
     Invoke-Sqlcmd –ServerInstance NJ3PRODEBI –Database DBA –Query 'SELECT TOP 78 * from dbo.diskspace Where LUN = "NJ1PRODCORE_DATA"  order by created DESC' | Format-Table -Auto

                    
<#Take database offline 
     import-module sqlps -disablenamechecking
     Invoke-Sqlcmd –ServerInstance SQL_ISDEV01 –Database master –Query 'ALTER DATABASE [SMSBaseV5_Demo] SET OFFLINE WITH ROLLBACK IMMEDIATE' 


Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Sort-Object -Property DisplayName | Select-Object -Property DisplayName, DisplayVersion, InstallDate | Where-Object {($_.DisplayName -like "Hotfix*SQL*") -or ($_.DisplayName -like "Service Pack*SQL*")}| Format-List

#Test Connnection - Ping
    Test-Connection -ComputerName 'NJ3PRODC'

#Test-AgentService  Active Nodes
    #Test-AgentService -instances "NJ1PRODBI" -recipients "jlangdon@mathematica-mpr.com"  
    Test-AgentService -instances "NJ1DEVBI", "NJ1PRODBI", "NJ3PRODBI", "NJ3PRODEBI" -recipients "jlangdon@mathematica-mpr.com"  


#Get database Role Permissions on all databases - writes results to C:\Powershell\Text\RolePermissions.csv
    Get-DatabaseRolePermssions -orginst 'SQL_ISDEV01' -login 'Mathematica\JLangdon' 

#Get logins per domain
    Get-LoginsToCSV -orginst 'SQL_ISPROD01' -filter 'Mathematica\' 
    Get-LoginsToCSV -orginst 'NJ1DEVC' -filter 'NJ2\' 

#Attach databases
    Attach-Databases -servername 'NJ1PRODN' -mdfname 'Netwrix_Auditor_Event_Log_Piscataway.mdf' 

#Delete all files with a bak extension
    Invoke-DeleteBackupFiles -path '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Migrate\'

#Set Database Location
    Get-PSDrive # Check if SQLServer PS Drive is available
    New-PSDrive -Name db -PSProvider sqlserver -Root SQLSERVER:\  #SQL\NJ1SQL08ISDEV\SQL_ISDEV01\Databases\ #Add drive if it's not there
    Set-Location SQLSERVER:\
    Set-Location SQLSERVER:\SQL\JLANGDON\MSSQLSERVER2012\Databases\AdventureWorks2012\Tables\
    Set-Location SQLSERVER:\SQL\SQL_ISDEV01\default\Databases\master\
    Set-Location SQLSERVER:\SQL\M030\Default\Databases\master\    
    [String] $Filter = 'NJ1\'
    Invoke-Sqlcmd -Query 'Select name from sys.server_principals where name like '$Filter%'' | Sort-Object -Property Name 
    Invoke-Sqlcmd -Query 'SELECT name FROM sys.database_principals' | Sort-Object -Property Name | out-gridview
    Invoke-Sqlcmd -Query 'SELECT name FROM sys.server_principals Where name like 'NJ1\%'' | Sort-Object -Property Name | out-gridview
    Invoke-Sqlcmd -Query 'SELECT COUNT(*) FROM sys.sysdatabases'

#Query specfic database

    Invoke-Sqlcmd –ServerInstance NJ1PRODC –Database master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'
    Invoke-Sqlcmd –ServerInstance 'JLANGDON\MSSQLSERVER_2014' –Query "SP_ADDSRVROLEMEMBER 'Mathematica\JLangdon','SYSADMIN'" 

#Run SQL script
    
    invoke-sqlcmd -ServerInstance 'JLANGDON\MSSQLSERVER_2014' -inputFile "C:\SQLScripts\Exec\CreateTable.sql" | out-File -filepath "C:\SQLScripts\Exec\Results.txt"

#Take database offline

   #Invoke-DatabaseOffline -instance 'M030' -path 'c:\PowershelOl\Text\dbs.csv'

#Reset SQL Admin
    
    Reset-SqlAdmin -SqlServer 'JLANGDON\MSSQLSERVER2012' 

#Copy Logins from one instance to another based on some filter

   Copy-ServerPrincipals -orginst 'NJ1DEVC' -desinst 'NJ1DEVE' -filter 'Mathematica\'


#Translaste SIS to User and User to SID

    $objUser = New-Object System.Security.Principal.NTAccount('jelangdon')
    $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
    $strSID.Value

    $objSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-9-1-3246135797-3923212562-3038118243-2203835609-1177588740")
    $strUser = $objSID.Translate([System.Security.Principal.NTAccount])
    $strUser.Value


#Invoke-CreateZipFile http://blogs.technet.com/b/heyscriptingguy/archive/2015/03/09/use-powershell-to-create-zip-archive-of-folder.aspx

Invoke-PHSPBackupDatabase -orginst 'SQL_ISDEV01' -source '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\PH\'  -filename 'TPPTASharepoint.zip' -dbname 'TPPTASharepoint' -destination '\\M076\MPRFTPS-Files FDrive\MPRFTPSUser12\' -password 'JLangdon' 
Invoke-PHSPBackupDatabase -orginst 'SQL_ISDEV01' -source '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\PH\'  -filename 'TPPTASharepoint.zip' -dbname 'TPPTASharepoint' -destination '\\mathematica.net\NDrive\Transfer\JLangdon\Migrate' -password 'JLangdon' 

## Adminstrator check

invoke-command {net localgroup administrators} -computer NJ1SAND1

##  G
$sb={get-itemproperty hklm:\software\policies\Microsoft\Windows\WindowsUpdate\ -Name WUServer | Select-Object WUServer}
invoke-command -ComputerName Serenity -ScriptBlock $sb

Invoke-Command nj3sql14bi1.mathematica.net -ScriptBlock { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12*\MSSQLServer\SuperSocketNetLib\Sm' -name 'Enabled' | Select-Object 'Enabled' | Format-List }

Invoke-Command nj3sql14c2.mathematica.net -ScriptBlock { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12*\MSSQLServer\SuperSocketNetLib\Sm' -name 'Enabled' | Select 'Enabled' | Format-List }

##Cluster info

Import-Module FailoverClusters
Get-ClusterGroup -Cluster NJ1DEVM
#shows all clustered resources 
Get-ClusterResource -Cluster NJ1DEVC
#Shows node and state
Get-ClusterNode -Name
Get-Cluster -Name 'NJ1DEVC' | Format-List *

Get-WmiObject -Class Win32_ComputerSystem -ComputerName NJ1DEVC | Select-Object Name


$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $CN
Invoke-Sqlcmd -Query 'SERVERPROPERTY('ServerName') AS [ServerName];' -ServerInstance $srv.Name | Format-Table -AutoSize  

$svr | select version, edition, productlevel;
$srv.Databases
$srv.Databases['DeltekTE'].Tables
$svr.databases['DeltekTE'].tables | select name, rowcount | Sort-Object -Property RowCount -desc | select -First 3

Get-ClusterGroup #Cluster group shows active/owner node
# Get node list, status and current owner
Invoke-Sqlcmd -Query 'SELECT NodeName, status_description, is_current_owner FROM sys.dm_os_cluster_nodes WITH (NOLOCK) OPTION (RECOMPILE);' -ServerInstance $srv.Name | Format-Table -AutoSize  

############################################
#PowerShell Gallery

Find-Script -Repository PSGallery | Where-Object {$_.Name -Like 'S*'}

Find-Module -Repository PSGallery | Where-Object {$_.Name -Like 'A*'}

Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force
Get-Module -Name PSScriptAnalyzer -ListAvailable

#list all the SQL-related commands
Get-Command -Module '*SQL*' –CommandType Cmdlet |
Select-Object CommandType, Name, ModuleName |
Sort-Object -Property ModuleName, CommandType, Name |
Format-Table –AutoSize

Find-Module -Name Posh* | Out-GridView -PassThru


Invoke-Command -ComputerName jlangdon -ScriptBlock {
Import-Module -Name ActiveDirectory
Get-ADUser -Identity Administrator
}

Install-Module -Name ISEScriptAnalyzerAddOn -Force
Get-Module -Name ISEScriptAnalyzerAddOn -ListAvailable

Invoke-ScriptAnalyzer

Get-Help Invoke-ScriptAnalyzer -full


Invoke-ScriptAnalyzer -Path C:\Powershell\Modules\DBAPS\DBAPS.psm1

Get-Help Get-EventLog -Examples

Get-EventLog -LogName application -newest 10 | where {$_.entryType -match "Failure"}
 
Get-EventLog  -LogName "Application" | where {$_.EventID -eq 17890 -and $_.message -match 'significan'} #  

 where { $_.providername -eq 'application hang' -and

    $_.level -eq 2 -and

    $_.ID -eq 1002 -and

    $_.message -match 'lync.exe'} }

    -StringData $Here

   $here = (Get-WinEvent -ComputerName nj1devc.mathematica.net -FilterHashtable @{logname='application';id=33205} -MaxEvents 1)

   $here.GetType()
   $here.properties 

   $eventXML = [xml]$here.ToXml()

   $eventXML.Event.EventData.Data | Where-Object {$.


   $here.Contains('a')
    ConvertFrom-StringData -StringData $Here


    <#
        nForm developers: AShum,BHunscher,CCaci,EKrzton-Presson,JPark-Lee,JValenzuela,LFurness,MMonteiro,SReid 

        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\AShum]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\BHunscher]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\CCaci]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\EKrzton-Presson]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\JValenzuela]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\LFurness]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\MMonteiro]'
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\SReid]'

        ## ATO Development Database Permissions
        New-WinLoginUserRoles -instance 'NJ1DEVC' -Winlogin 'Mathematica\JLangdon' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_developer'
        ## ATO Production Server Permissions
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'
        ## ATO Production Database Permissions
        Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database '40286_FAMLE_CrossSite' –Query 'GRANT VIEW DEFINITION On database::[40286_FAMLE_CrossSite] TO [Mathematica\JLangdon]'
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JLangdon' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
   
        40286_FAMLE_nFORM

        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
        New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\JPark-Lee' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_datareader, db_executor'    
    #>

    Install-Module -Name ReportingServicesTools            
            
Invoke-Expression (Invoke-WebRequest https://aka.ms/rstools)