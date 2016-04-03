function Backup-ForEach
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$bkdir
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instance
	$srv.ConnectionContext.StatementTimeout = 0
	[System.Collections.ArrayList]$bak = @()
	$db = $srv.databases['master']
	#Query databases
	$dbcmd = @" 
		Select top 10 name from sys.databases
"@
	$rs = $db.ExecuteWithResults($dbcmd)
	$dt = New-Object "System.Data.DataTable"
	$dt = $rs.Tables[0]
	$dbs = $dt
    
	
	foreach ($db in $dbs)
	{
		$dbname = $db.Name
		$bfile = "$bkdir\$($dbname).bak"
		Backup-SqlDatabase -InputObject $srv.Name -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly
		$bak.Add($dbname) | Out-Null
        #Write-Host $dbname
		
	}

            $bak -join "," >> c:\Powershell\Text\backedup.csv 
       
}

Backup-ForEach -instance "SQL_ISDEV01" -bkdir "\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Migrate\"