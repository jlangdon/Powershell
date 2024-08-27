
#Break statement added to stop you from accidentally running all the functions by clicking 'Run Script' or hitting F5
    Write-Host 'Stop hitting F5'
    break

    Get-Module SqlServer -ListAvailable
    (Get-Module SqlServer).Version

#Get AD account info, second cmdlet call returns all properties.
import-module - activedirectory
    Get-ADUser -Filter  'SamAccountName -like "*Headway*"'  #| Select-Object Name
    Get-ADUser JJackson -Properties *

#Get database Role Permissions on all databases - writes results to C:\Powershell\Text\RolePermissions.csv
    Get-DatabaseRolePermssions -orginst 'NJ1DEVM' -login 'Mathematica\JLangdon' 

#Add login, user, and permissions to a database
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\BDaniels' -dbname 'SSISDB' -dbroles 'public'  
    New-WinLoginUserRoles -instance 'SQL_ISPROD01' -Winlogin 'MATHEMATICA\JSohlberg' -dbname '50057_PSI_SMS' -dbroles 'db_datareader'  
    New-WinLoginUserRoles -instance 'NJ1DEVC' -Winlogin 'Mathematica\SH_SOC_Headway' -dbname 'Headway' -dbroles 'db_datareader, db_executor'    
    New-WinLoginUserRoles -instance 'NJ1DEVM' -Winlogin 'MATHEMATICA\JLangdon' -dbname 'Staffing' -dbroles 'db_datareader, db_datawriter, db_executor'    
    New-WinLoginUserRoles -instance 'SQL_ISDEV01' -Winlogin 'Mathematica\JLangdon' -dbname 'RedgateDev' -dbroles 'db_developer' 
    New-WinLoginUserRoles -instance 'M030' -Winlogin 'Mathematica\JCarsley' -dbname '40160_NBS6_SMS' -dbroles 'db_developer'
    New-WinLoginUserRoles -instance 'NJ1PRODC' -Winlogin 'Mathematica\AMarden' -dbname 'MACBIS_DQ' -dbroles 'db_ddladmin'
    New-WinLoginUserRoles -instance 'M030' -Winlogin 'MATHEMATICA\NWu' -dbname '40160_SEC__NBS' -dbroles 'db_owner'  
    New-WinLoginUserRoles -instance 'NJ1DEVC' -Winlogin 'Mathematica\BShk' -dbname 'BabyFaces' -dbroles 'db_owner' 

#Grant object level permissions
    New-WinLoginUserRoles -instance 'NJ3PRODC' -Winlogin 'Mathematica\RSelekman' -dbname '40286_FAMLE_nFORM' -dbroles 'public'
    Invoke-Sqlcmd –ServerInstance NJ3PRODC –Database 40286_FAMLE_nFORM –Query 'GRANT SELECT ON [dbo].[vwSAS_Streams_tblAdherenceQu] TO [MATHEMATICA\MCrofton]'

#Redgate SQL Compare permissions to sync databases
    New-WinLoginUserRoles -instance 'NJ1DEVM' -Winlogin 'Mathematica\JLangdon' -dbname 'Staffing' -dbroles 'public'
    Invoke-Sqlcmd –ServerInstance SQL_ISDEV01 –Database PI –Query 'GRANT VIEW DEFINITION On database::[PI] TO [MATHEMATICA\JLangdon]'
    Invoke-Sqlcmd –ServerInstance SQL_ISDEV01 –Database Master –Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'

#Backup a single database  
    Invoke-BackupDatabase -orginst 'SQL_AUDDEV01' -dbname '40160_NBS6_SMS' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'
    Invoke-BackupDatabase -orginst 'M030' -dbname "06503_WIAFX" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'
    Invoke-BackupDatabase -orginst 'SQL_AWS3P01' -dbname "DeltekCP" -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-AWS\Restricted\NJ1'

#Restore a single database
    Invoke-RestoreDatabase -desinst 'NJ1DEVM' -dbname 'SalaryReview' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1' -versionlevel 'Version120' -replace
    Invoke-RestoreDatabase -desinst 'NJ1DEVCORE' -dbname 'DELTEKCP' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-AWS\Restricted\NJ1' -versionlevel 'Version120' #-replace
    Invoke-RestoreDatabase -desinst 'NJ1DEVCORE' -dbname "DELTEKCP" -bkdir '\\mathematica.net\NDrive\Transfer\JLangdon' -versionlevel 'Version120' -replace

#Restore AS database with a different name
    Invoke-RestoreAsDatabase -desinst 'SQL_ISDEV01' -dbname '40300_JSA_Web' -asdbname 'RedgateDev' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'  -versionlevel 'Version100' # -replace
    Invoke-RestoreAsDatabase -desinst 'SQL_ISPROD01' -dbname 'SMSBaseV5' -asdbname '50319_CPC_Plus' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'  -versionlevel 'Version100' -replace
    Invoke-RestoreAsDatabase -desinst 'NJ1DEVM' -dbname 'CPSYSTEM_1124' -asdbname 'CPTESTSYS' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'  -versionlevel 'Version120' -replace

#Backup and restore single database
    Invoke-BackupRestoreDB -orginst 'NJ1DEVM' -desinst 'NJ1PRODM' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'  -dbname 'SalaryReview' -versionlevel 'Version120' #-replace -offline
    Invoke-BackupRestoreDB -orginst 'NJ1DEVCore' -desinst 'NJ1PRODC' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1'  -dbname 'BrainTest_SMS' -versionlevel 'Version120' #-replace -offline

#Backup and restore databases from a csv file.  Migration script
    Invoke-BackupRestoreWithCSV -orginst 'SQL_ISPROD01' -desinst 'NJ1PRODC' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1' -path 'c:\Powershell\Text\dbs.csv' -versionlevel 'Version120'-replace # -offline

#Create a new database
    New-Database -orginst 'NJ1PRODM' -dbname 'CostHistoryDB' -datafilesize 100 -datafilegrowth 50 -logfilesize 50 -logfilegrowth 10 

#List Active Nodes 
    Get-ActiveNode -instances "NJ1DEVM"

#Get Disk space info 
    Get-DiskSpace -instances "NJ1PRODN"

#Test Connnection - Ping
    Test-Connection -ComputerName 'NJ1DEVR'

#Test-AgentService  Active Nodes
    Test-AgentService -instances "NJ1SQL14DEVBI1\NJ1DEVBI"  #Copy 

#Get logins per domain
    Get-LoginsToCSV -orginst 'NJ1DEVC' -filter 'Mathematica\' 

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
    Invoke-Sqlcmd –ServerInstance NJ1PRODC –Database 40286_FAMLE_nFORM –Query 'GRANT VIEW SERVER STATE TO [Mathematica\JLangdon]'

#Take database offline
   #Invoke-DatabaseOffline -instance 'M030' -path 'c:\Powershell\Text\dbs.csv'

#Copy Logins from one instance to another based on some filter
    Copy-ServerPrincipals -orginst 'NJ3PRODC' -desinst 'DC1SQL14DR1\DC1DRPRODC' -filter 'Mathematica\'



