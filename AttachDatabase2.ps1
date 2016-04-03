<#	
	.NOTES
	===========================================================================
	Created on:   	7/9/2015 2:07 PM
	 Created by:   	JLangdon
	===========================================================================
	.DESCRIPTION
		The script will attach all User databases from a csv file.
#>

function Attach-Databases {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
        [Parameter(Mandatory = $true)][string]$drive,
        [Parameter(Mandatory = $true)][string]$datadir,
        [Parameter(Mandatory = $true)][string]$logdir,
        [Parameter(Mandatory = $true)][string]$username
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Create server object, set name from variables
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
    $password = "Sarah108" | ConvertTo-SecureString -asPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    #Map PS-Drive
    New-PSDrive -Name "Z" -PSProvider FileSystem -Root $drive -Credential $credential
	#Start attach by getting database names from csv file
	$ImportedDBS = Get-Content -Path c:\Powershell\Text\detached.csv -Delimiter ","
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
        Set-Location z:\Data        
        $mdf = Get-ChildItem -Filter $db*.mdf
        #Set Location to log file directory
        Set-Location z:\Log
		$ldf = Get-ChildItem -Filter $db*.ldf			#Set data file path
        $datastr = $DataDir + $mdf.Name
   		#Set log file path
   		$logstr = $LogDir + $ldf.Name
        $sc = New-Object System.Collections.Specialized.StringCollection
		$sc.Add($datastr) | Out-Null
		$sc.Add($logstr) | Out-Null
		try
		{
			$server.AttachDatabase($db, $sc, $owner, [Microsoft.SqlServer.Management.Smo.AttachOptions]::None)
		}
		catch
		{
			Write-Error "$($_.Exception.Message) - Line Number : $($_.InvocationInfo.ScriptLineNumber)"
		}
        Write-Host $db
        Write-Host $datastr
		Write-Host $logstr
    } 
}

Attach-Databases -instance "NJPRODC" -drive "\\NJPRODC.mathematica.net\E$" -datadir "E:\Data\" -logdir "E:\Log\" -username "Mathematica\JELangdon"





