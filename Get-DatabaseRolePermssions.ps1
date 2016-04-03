function Get-DatabaseRolePermssions {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst
        #[Parameter(Mandatory = $true)][string]$login
	)
	#Import SQLPS Module if not loaded
    if(-not(Get-Module -name "sqlps"))
    {
        Import-Module SQLPS -DisableNameChecking
    }
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	$orgsrv.ConnectionContext.StatementTimeout = 0
    #Create array to store backed up databases
	[System.Collections.ArrayList]$Perms = @()
	#Get database names
	$dbs = $server.Databases
	foreach ($db in $dbs)
        {
            Write-Output $db.name

        }

}

Get-DatabaseRolePermssions -orginst "JLANGDON\MSSQLSERVER2012" 