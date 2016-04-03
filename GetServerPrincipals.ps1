<<<<<<< HEAD
﻿function Get-ServerPrincipals
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$instanceA,
		[Parameter(Mandatory = $true)][string]$instanceB

	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	$srvA = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instanceA
   	$srvB = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instanceB

	$db = $srvA.databases['master']
	#Query databases
	$dbcmd = @" 
		Select name from sys.server_principals where name like 'Mathematica\%'
"@
	$rs = $db.ExecuteWithResults($dbcmd)
	$dt = New-Object "System.Data.DataTable"
	$dt = $rs.Tables[0]
	$principals = $dt.name
    
	
	foreach ($p in $principals)
	{
        $login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $srvB, $p
        $login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
        $login.Create()
        Write-Host $login
	}
}

Get-ServerPrincipals -instanceA "SQL_ISDEV01" -instanceB "NJ1DEVC" 

=======
﻿function Get-ServerPrincipals
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$instanceA,
		[Parameter(Mandatory = $true)][string]$instanceB

	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	$srvA = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instanceA
   	$srvB = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instanceB

	$db = $srvA.databases['master']
	#Query databases
	$dbcmd = @" 
		Select name from sys.server_principals where name like 'Mathematica\%'
"@
	$rs = $db.ExecuteWithResults($dbcmd)
	$dt = New-Object "System.Data.DataTable"
	$dt = $rs.Tables[0]
	$principals = $dt.name
    
	
	foreach ($p in $principals)
	{
        $login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $srvB, $p
        $login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
        $login.Create()
        Write-Host $login
	}
}

Get-ServerPrincipals -instanceA "SQL_ISDEV01" -instanceB "NJ1DEVC" 

>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
