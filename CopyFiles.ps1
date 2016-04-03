function Copy-DatabaseFiles
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$origin,
        [Parameter(Mandatory = $true)][string]$destination,
        [Parameter(Mandatory = $true)][string]$username,
        [Parameter(Mandatory = $true)][string]$pwd,
        [Parameter(Mandatory = $true)][string]$database,
        [Parameter(Mandatory = $true)][string]$ext,
        [Parameter(Mandatory = $true)][string]$destfolder

	)
    $password = "Sarah108" | ConvertTo-SecureString -asPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Set-Location c:\
    #Map drives
    New-PSDrive -Name "A" -PSProvider FileSystem -Root $origin -Persist -Credential $credential
    New-PSDrive -Name "B" -PSProvider FileSystem -Root $destination -Persist -Credential $credential
    #Set orgin pwd 
    Set-Location $pwd
    #Select Files to copy
    $files = Get-ChildItem -Filter $database*.$ext
    #Copy files
    Copy-Item  $files.Name -Destination B:\$destfolder -ErrorAction SilentlyContinue

    Write-host $files
}

#Copy data files
Copy-DatabaseFiles -origin "\\M031.mathematica.net\S$" -destination "\\M031.mathematica.net\R$" -pwd "A:\Data" -database "GovWinViewer" -destfolder "Data" -ext "mdf"  -username "Mathematica\JELangdon"
#Copy log files
Copy-DatabaseFiles -origin "\\M031.mathematica.net\S$" -destination "\\M031.mathematica.net\R$" -pwd "A:\Log" -database "GovWinViewer" -destfolder "Log" -ext "ldf" -username "Mathematica\JELangdon"



function Copy-DatabaseFiles
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$origin,
        [Parameter(Mandatory = $true)][string]$destination,
        [Parameter(Mandatory = $true)][string]$username,
        [Parameter(Mandatory = $true)][string]$pwd,
        [Parameter(Mandatory = $true)][string]$database,
        [Parameter(Mandatory = $true)][string]$ext,
        [Parameter(Mandatory = $true)][string]$destfolder

	)
    $password = "Sarah108" | ConvertTo-SecureString -asPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
    Set-Location c:\
    #Map drives
    New-PSDrive -Name "A" -PSProvider FileSystem -Root $origin -Persist -Credential $credential
    New-PSDrive -Name "B" -PSProvider FileSystem -Root $destination -Persist -Credential $credential
    #Set orgin pwd 
    Set-Location $pwd
    #Select Files to copy
    $files = Get-ChildItem -Filter $database*.$ext
    #Copy files
    Copy-Item  $files.Name -Destination B:\$destfolder -ErrorAction SilentlyContinue

    Write-host $files
}

#Copy data files
Copy-DatabaseFiles -origin "\\M031.mathematica.net\S$" -destination "\\M031.mathematica.net\R$" -pwd "A:\Data" -database $global:gdbname -destfolder "Data" -ext "mdf"  -username "Mathematica\JELangdon"
#Copy log files
Copy-DatabaseFiles -origin "\\M031.mathematica.net\S$" -destination "\\M031.mathematica.net\R$" -pwd "A:\Log" -database $global:gdbname -destfolder "Log" -ext "ldf" -username "Mathematica\JELangdon"








