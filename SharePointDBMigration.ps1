function Invoke-PHSPBackupDatabase {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
		[Parameter(Mandatory = $true)][string]$bkdir,
   		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Import SQLPS Module if not loaded
    if(-not(Get-Module -name "sqlps"))
    {
        Import-Module SQLPS -DisableNameChecking
    }
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	$bfile = "$bkdir\$($dbname).bak"
	Backup-SqlDatabase -InputObject $orgsrv.Name -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly -Initialize
   

} #end Invoke-PHSPBackupDatabase function


#Invoke-PHSPBackupDatabase -orginst "SQL_SDEV01" -dbname "TPPTASharepoint" -bkdir "\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Migrate\PH"


function Invoke-CreateZipFile {
    [CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$source,
        [Parameter(Mandatory = $true)][string]$destination,
        [Parameter(Mandatory = $true)][string]$password
	)
    try  {
        If(Test-path $destination) {Remove-item $destination -Force}
        $process = "\\Nj1sql14m1\c$\7-Zip\7z.exe"
        Start-Process $process -ArgumentList "a $destination $source -p$password"
    }
	catch
	{
		Write-Output = "Exception: $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())"
			
	} 

} #end function Invoke-CreateZipFile


    #Invoke-CreateZipFile -source "C\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Migrate\PH\" -destination "C:\Powershell\books\Test.zip" -password "JLangdon"


function Copy-DatabaseFiles {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$DataRoot
	)
	#Import SQLPS Module if not loaded
    if(-not(Get-Module -name "sqlps"))
    {
        Import-Module SQLPS -DisableNameChecking
    }
	$cred = Get-Credential -UserName mathematica\jelangdon -Message "Log in"

        #$DataRoot = "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER2012\MSSQL"

        New-PSDrive -Name "Z" -PSProvider FileSystem -Root $DataRoot -Credential $cred

        $DataDirOrg = "Z:\data"
        $DataDirDest = "Z:\data2"

        Copy-Item $DataDirOrg -Filter *.txt -Destination $DataDirDest 

        #$DataFiles =  Get-ChildItem $DataDir #-Force -Recurse -ErrorAction SilentlyContinue

        #$DataFiles = Get-ChildItem $DataDir #-Filter $db*.ldf | Select -First 1	

        #$DataFiles

        #Get-PSDrive Z | Remove-PSDrive	
} #end Copy-DatabaseFiles function

