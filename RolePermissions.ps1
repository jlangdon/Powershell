<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/10/2015 11:15 AM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


function Add-WinDBUserWithReadWrite
{
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	
	#Return results
	$Results = ""
	#Get Server/Instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Check if login exists
	$log = $server.Logins[$Winlogin].ToString()
	if ($log -eq $null)
	#if ($server.Logins.Contains($Winlogin))
	#if ($logins -notcontains $Winlogin)
	{
		Add-SqlLogin -sqlserver $server -name $Winlogin -logintype "WindowsUser" -DefaultDatabase 'master'
		$Results = "Login added,"
	}
	else
	{
		$Results = "Login exists,"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader, db_datawriter roles granted"
		
	}
	else
	{
		#Remove-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$db.Users[$dbuser].Drop()
		$db.Refresh()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader, db_datawriter roles role granted"
		
	}
	Write-Host $Results
}

Add-WinDBUserWithReadWrite -instance "JLANGDON\MSSQLSERVER2012" -Winlogin "Mathematica\ADeng" -dbname "JL"


