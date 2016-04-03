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
		if ($database.IsSystemObject -eq $False -and $database.name -like "Tfs_*") 
			{
                
                #$DBsToDetach = ""
                $server.KillAllProcesses($database.name)
                $database.alter()
                $database.SetOffline()
                $server.DetachDatabase($database.Name, $false, $false)
                Write-Host $database.name "detached"
			    #$DBsToDetach.Clear()
			    #$DBsToDetach.Add($database) | Out-Null              
			
		}
            
    }	
        
}

Detach-Databases -instance "NJ1SQL14Test1"