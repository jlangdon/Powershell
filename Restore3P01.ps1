<<<<<<< HEAD
﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/12/2015 2:07 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#Import SQLPS Module
Import-Module SQLPS -DisableNameChecking
#[string]$instance = "SQL_AWS3P01"
[string]$instance = "JLangdon\MSSQLServer2012"
#Create server object, set name from variables
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
[System.Collections.ArrayList]$dbs = $server.databases
[System.Collections.ArrayList]$DBsToDetach = @()
[System.Collections.ArrayList]$Detached = @()

#Set data file properties
	foreach ($database in $dbs)
	{
		if ($database.IsSystemObject -eq $False -and $database.name -notlike "ReportServer*")
		{
			$database.UserAccess = "Single"
			$database.Alter([Microsoft.SqlServer.Management.Smo.TerminationClause]"RollbackTransactionsImmediately")
			$DBsToDetach.Clear()
			$DBsToDetach.Add($database)

			foreach ($d in $DBsToDetach)
			{
				$server.DetachDatabase($database.Name, $false, $false)
				$Detached.Add($database.name)
			}
		}
}
$Detached -join "," >> c:\Powershell\Text\3P01.csv

#Start attach by getting database names from csv file
$ImportedDBS = Get-Content -Path c:\Powershell\Text\3P01.csv -Delimiter "," 
foreach ($dt in $ImportedDBS)
{
	$db = ""
	if ($dt.contains(“,”))
	{
		$db = $dt.Replace(",", "")
	}
	else
	{
		$db = [string]$dt.trim()
	}
	$owner = "sa"
	$mdf = "C:\Powershell\dbfiles\"
	#$mdf = "\\M031\O'$\Data\"
	$mdfFile = Get-ChildItem -Path $mdf -Filter $db*.mdf
	$ldf = "C:\Powershell\dbfiles\"
	#$ldf = "\\M031\O'$\LOG\"
	$ldfFile = Get-ChildItem -Path $ldf -Filter $db*.ldf 
	$datastr = $mdf + $mdfFile
	$logstr = $ldf + $ldfFile
	$sc = New-Object System.Collections.Specialized.StringCollection
	$sc.Add($datastr)
	$sc.Add($logstr)
	try
	{
		$server.AttachDatabase($db, $sc, $owner, [Microsoft.SqlServer.Management.Smo.AttachOptions]::None)
	}
	catch
	{
		Write-Host "Exception: $($_.Exception)"
		throw $_.Exception
	}		
	Write-Host $sc
}


<#foreach ($database in $dbs)
{
	#if ($database.name -like "DELTEKTE_Test" -or $database.name -like "DELTEKCP_Test")
	if ($database.name -like "DELTEKTE_Test")
	{
		$database.UserAccess = "Single"
		$database.Alter([Microsoft.SqlServer.Management.Smo.TerminationClause]"RollbackTransactionsImmediately")
		$DBsToDetach.Clear()
		$DBsToDetach.Add($database)
		
		foreach ($d in $DBsToDetach)
		{
			$server.DetachDatabase($database.Name, $false, $false)
			$Detached.Add($database.name)
		}
	}
}
#>






=======
﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/12/2015 2:07 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

#Import SQLPS Module
Import-Module SQLPS -DisableNameChecking
#[string]$instance = "SQL_AWS3P01"
[string]$instance = "JLangdon\MSSQLServer2012"
#Create server object, set name from variables
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
[System.Collections.ArrayList]$dbs = $server.databases
[System.Collections.ArrayList]$DBsToDetach = @()
[System.Collections.ArrayList]$Detached = @()

#Set data file properties
	foreach ($database in $dbs)
	{
		if ($database.IsSystemObject -eq $False -and $database.name -notlike "ReportServer*")
		{
			$database.UserAccess = "Single"
			$database.Alter([Microsoft.SqlServer.Management.Smo.TerminationClause]"RollbackTransactionsImmediately")
			$DBsToDetach.Clear()
			$DBsToDetach.Add($database)

			foreach ($d in $DBsToDetach)
			{
				$server.DetachDatabase($database.Name, $false, $false)
				$Detached.Add($database.name)
			}
		}
}
$Detached -join "," >> c:\Powershell\Text\3P01.csv

#Start attach by getting database names from csv file
$ImportedDBS = Get-Content -Path c:\Powershell\Text\3P01.csv -Delimiter "," 
foreach ($dt in $ImportedDBS)
{
	$db = ""
	if ($dt.contains(“,”))
	{
		$db = $dt.Replace(",", "")
	}
	else
	{
		$db = [string]$dt.trim()
	}
	$owner = "sa"
	$mdf = "C:\Powershell\dbfiles\"
	#$mdf = "\\M031\O'$\Data\"
	$mdfFile = Get-ChildItem -Path $mdf -Filter $db*.mdf
	$ldf = "C:\Powershell\dbfiles\"
	#$ldf = "\\M031\O'$\LOG\"
	$ldfFile = Get-ChildItem -Path $ldf -Filter $db*.ldf 
	$datastr = $mdf + $mdfFile
	$logstr = $ldf + $ldfFile
	$sc = New-Object System.Collections.Specialized.StringCollection
	$sc.Add($datastr)
	$sc.Add($logstr)
	try
	{
		$server.AttachDatabase($db, $sc, $owner, [Microsoft.SqlServer.Management.Smo.AttachOptions]::None)
	}
	catch
	{
		Write-Host "Exception: $($_.Exception)"
		throw $_.Exception
	}		
	Write-Host $sc
}


<#foreach ($database in $dbs)
{
	#if ($database.name -like "DELTEKTE_Test" -or $database.name -like "DELTEKCP_Test")
	if ($database.name -like "DELTEKTE_Test")
	{
		$database.UserAccess = "Single"
		$database.Alter([Microsoft.SqlServer.Management.Smo.TerminationClause]"RollbackTransactionsImmediately")
		$DBsToDetach.Clear()
		$DBsToDetach.Add($database)
		
		foreach ($d in $DBsToDetach)
		{
			$server.DetachDatabase($database.Name, $false, $false)
			$Detached.Add($database.name)
		}
	}
}
#>






>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
