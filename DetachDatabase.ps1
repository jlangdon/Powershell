<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/12/2015 2:07 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:    DetachedDatabase.ps1 	
	===========================================================================
	.DESCRIPTION
		The script will detach all User databases except for SSRS databases.
#>

function Detach-Databases
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Create server object, set name from variables
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	[System.Collections.ArrayList]$dbs = $server.databases
	[System.Collections.ArrayList]$DBsToDetach = @()
	[System.Collections.ArrayList]$Detached = @()

	#Set data file properties
		foreach ($database in $dbs)
	{
		if ($database.IsSystemObject -eq $False -and $database.name -notlike "ReportServer*")
		#if ($database.name -like "JLTest")
			{
			$database.UserAccess = "Single"
			$server.KillAllProcesses($database.name)
			$database.alter()
			$DBsToDetach.Clear()
			$DBsToDetach.Add($database)
			
			foreach ($d in $DBsToDetach)
			{
				$server.DetachDatabase($database.Name, $false, $false)
				$Detached.Add($database.name)
			}
		}
	}
	$Detached -join "," >> c:\Powershell\Text\detached.csv
	
}

Detach-Databases -instance "SQL_AWS3P01"