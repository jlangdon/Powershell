#Break statement added to stop you from accidentally running all the functions by clicking 'Run Script' or hitting F5
    Write-Host 'Stop hitting F5'
    break
    Import-Module sqlps -disablenamechecking

    $env:PSModulePath = $env:PSModulePath + ";c:\Powershell\Modules"
    $env:PSModulePath = $envPSModulePath -replace “;c:\\Poweshell\Modules” 
    $psISE.Options.ShowToolBar=$True
    #Get Module info
    Get-module DBAPS 
    
    #Install Module
    Install-module DBAPS -AllowClobber
    
    #List module functions
    Get-Command -Module DBAPS

    #Import Module
    Remove-Module DBAPS
    Import-Module "C:\Powershell\Modules\DBAPS\DBAPS.psm1"
    
    #View function definition
    (Get-Command Invoke-RestoreAsDatabase).Definition

    #Get Function definition
    #Get-Command -Name New-Database  | Select-Object-ExpandProperty Definition

    #Get Database Info
    Get-SqlDatabase -Name AdventureWorks2002

    #Get Module help
    Get-Help -Name SQLServer -Full

 #----------------------------------------------------------------------------------------------------   
    Get-SqlAgent -ServerInstance M030 | Get-SqlAgentJob -Name phonelistupdate | Format-Table -AutoSize
    Test-NetConnection -ComputerName Jeffrey -Port 1433 -Verbose
    Test-NetConnection -ComputerName NJ1SAND1 -Port 3306 -Verbose
    # check data providers
    (New-Object system.data.oledb.oledbenumerator).GetElements() | Select-Object SOURCES_NAME, SOURCES_DESCRIPTION
#--------------------------------------------------------------------------------------------------------

Connect-DbaInstance -SqlInstance Jeffrey
Connect-DbaInstance -SqlInstance Jeffrey\sql2017

### User/Login Code




#Get AD account info, second cmdlet call returns all properties.
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
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
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\BLi" -dbname '40286_FAMLE_nFORM' -dbroles 'db_datareader, db_executor'
    New-WinLoginUserRoles -instance 'NJ3PRODE' -Winlogin "Mathematica\DMunipally" -dbname 'Plus' -dbroles 'db_developer, db_ddladmin'  
    New-WinLoginUserRoles -instance 'NJ1PRODE' -Winlogin 'Mathematica\ADeng' -dbname 'msdb' -dbroles 'DatabaseMailUserRole'

#Revoke ATO Permissions
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\DOConner" -dbname '50390_PODE' -dbroles 'db_datareader, db_executor'
    Invoke-Sqlcmd -ServerInstance 'NJ3PRODC' -Database 50390_PODE -Query 'GRANT VIEW DEFINITION On database::[50390_PODE] TO [MATHEMATICA\DOConnor]'
    
    Invoke-Sqlcmd -ServerInstance 'NJ3PRODC' -Database 50327_EmplCoaching_SMS -Query 'REVOKE VIEW DEFINITION ON OBJECT::dbo.tlkpSetting FROM [MATHEMATICA\MMonteiro];'
    Invoke-Sqlcmd -ServerInstance 'NJ3PRODC' -Database 40286_FAMLE_nFORM_Preview -Query 'GRANT UPDATE ON OBJECT::dbo.tlkpSetting TO [MATHEMATICA\MMonteiro];'

#Grant object level permissions
    #New-WinLoginUserRoles -instance 'NJ1PRODM' -Winlogin 'Mathematica\EmployeeRoutingUsers' -dbname 'DeltekCP' -dbroles 'puCWolfendalec'
    Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database 40286_FAMLE_nFORM -Query 'GRANT EXECUTE ON [dbo].[ExportUFRASample] TO [MATHEMATICA\SLauffer]'

#Redgate SQL Compare permissions to sync databases for migration scripts
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin "Mathematica\DOConnor" -dbname '50390_PODE' -dbroles 'db_datareader, db_executor'
    Invoke-Sqlcmd -ServerInstance 'NJ3PRODC' -Database 50390_PODE -Query 'GRANT VIEW DEFINITION On database::[50390_PODE] TO [MATHEMATICA\DOConnor]'
    Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database 50390_PODE -Query 'GRANT SHOWPLAN TO [Mathematica\NWu]'
    Invoke-Sqlcmd -ServerInstance NJ1DEVC -Database master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\TTrainor]'

#------------------------------------------------------------------------------------------------------------------------------------------------------
### Database Code

#Create a new database
   New-Database -orginst 'Jeffrey' -dbname 'One' -datafilesize 1024 -datafilegrowth 512 -logfilesize 512 -logfilegrowth 256 

#Backup a single database  
   Invoke-BackupDatabase -orginst 'Jeffrey' -dbname 'Five' -bkdir 'F:\Backups'
   Invoke-Sqlcmd -ServerInstance Jeffrey -Database master -Query 'ALTER DATABASE [OmtoolServerMetaDataSet] SET OFFLINE WITH ROLLBACK I`
#Restore a single database from archive
   Invoke-RestoreDatabase -desinst 'Jeffrey' -dbname 'Five' -bkdir 'F:\Backups' -versionlevel 'Version140' -replace

#Backup and restore single database
    Invoke-BackupRestoreDB -orginst 'Jeffrey' -desinst 'NJ1DEVM' -bkdir 'F:\Backups'  -dbname 'OnBaseToABRA' -versionlevel 'Version120' -replace #-offline
    Invoke-BackupRestoreDB -orginst 'Jeffrey' -desinst 'NJ1PRODE' -bkdir 'F:\Backups'  -dbname '50522_SNMCS2_SMS' -versionlevel 'Version120' -replace -offline

#Restore AS database with a different name
    Invoke-RestoreAsDatabase -desinst 'Jeffrey' -dbname 'Hello' -asdbname 'HelloNow' -bkdir 'F:\Backups'  -versionlevel 'Version140' -replace

#Backup and restore databases from a csv file.  Migration script
    Invoke-BackupRestoreWithCSV -orginst 'SQL_AWS3P01' -desinst 'NJ1DEVE' -bkdir 'F:\Backups' -path 'c:\Powershell\Text\databases.txt' -versionlevel 'Version120'-replace #-offline
    Invoke-BackupRestoreWithCSV -orginst 'SQL_AWS3P01' -desinst 'NJ1PRODCORE' -bkdir 'F:\Backups' -path 'c:\Powershell\Text\databases.txt' -versionlevel 'Version120'-replace #-offline

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
    Get-DiskSpace -instance "Jeffrey"
     Invoke-Sqlcmd -ServerInstance NJ3PRODEBI -Database DBA -Query 'SELECT TOP 78 * from dbo.diskspace order by created DESC' | Format-Table -Auto
     Invoke-Sqlcmd -ServerInstance NJ3PRODEBI -Database DBA -Query 'SELECT TOP 78 * from dbo.diskspace Where LUN = "NJ1PRODCORE_DATA"  order by created DESC' | Format-Table -Auto

                    
<#Take database offline 
     Invoke-Sqlcmd -ServerInstance SQL_ISDEV01 -Database master -Query 'ALTER DATABASE [SMSBaseV5_Demo] SET OFFLINE WITH ROLLBACK IMMEDIATE' 


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

    Invoke-Sqlcmd -ServerInstance NJ1PRODC -Database master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'
    Invoke-Sqlcmd -ServerInstance 'JLANGDON\MSSQLSERVER_2014' -Query "SP_ADDSRVROLEMEMBER 'Mathematica\JLangdon','SYSADMIN'" 

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
Invoke-PHSPBackupDatabase -orginst 'SQL_ISDEV01' -source '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\PH\'  -filename 'TPPTASharepoint.zip' -dbname 'TPPTASharepoint' -destination 'F:\Backups\Migrate' -password 'JLangdon' 

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
Get-Command -Module '*SQL*' -CommandType Cmdlet |
Select-Object CommandType, Name, ModuleName |
Sort-Object -Property ModuleName, CommandType, Name |
Format-Table -AutoSize

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

        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\AShum]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\BHunscher]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\CCaci]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\EKrzton-Presson]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\JValenzuela]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\LFurness]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\MMonteiro]'
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\SReid]'

        ## ATO Development Database Permissions
        New-WinLoginUserRoles -instance 'NJ1DEVC' -Winlogin 'Mathematica\JLangdon' -dbname '40286_FAMLE_CrossSite' -dbroles 'db_developer'
        ## ATO Production Server Permissions
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database Master -Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'
        ## ATO Production Database Permissions
        Invoke-Sqlcmd -ServerInstance NJ3PRODC -Database '40286_FAMLE_CrossSite' -Query 'GRANT VIEW DEFINITION On database::[40286_FAMLE_CrossSite] TO [Mathematica\JLangdon]'
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