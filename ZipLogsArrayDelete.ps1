<<<<<<< HEAD
﻿<#IMPORTANT NOTE: This script needs to be run as a user that has permissions to the folders on the server.
PLEASE VERIFY user access is correct before running this script. #>
<# 
List the servers that you want to be able to access

$myServers = @("m961", "m976", "NJ1AppsExt3Dev-VM", "NJ1AppsInt1dev-vm")
#>
$myServers = @("m037", "m038", "m051", "m072", "M073", "m076", "m077", "nj1appsint1a", "nj1int1", "nj1int2", "nj1int3", "nj1net1", "M017", "M035")
<#
This for loop will go through each server and grab the files to be zipped
#>
foreach ($server in $myServers)
{
<#
Make modifications to the directory where the files are. 
The statement below requires the server name to be part of the folder name
#>
$path = "\\" + $server + "\" + $server + "weblogs"
set-location -path $path
$Directory = Get-Item . 
<#
Change the location for storing the zip file
#>
$ParentDirectory = "\\nj1ad1\ndrive\Transfer\KRhodes\ServerZipLogs" #"N:\Transfer\KRhodes\ServerZipLogs"
$ZipFileName = $ParentDirectory + "\" + $Directory.Name + "$(Get-Date -Format 'yyyy-MM').zip"
<# If the file being created exists in the target directory
delete it #>
"Checking if Zip file exists in the target directory."
if (test-path $ZipFileName) { 
  echo "Zip file already exists and is being deleted $ZipFileName."
  Remove-Item $ZipFileName -force 
  Start-Sleep -Seconds 5
  }
set-content $ZipFileName ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
(dir $ZipFileName).IsReadOnly = $false 
<#
The zip file is being created and stored in the location specified
#>
$ZipFile = (new-object -com shell.application).NameSpace($ZipFileName)

$ZipFile.CopyHere($Directory.FullName)

 
 "Starting zip file creation for server $Server."
  $wait = ""
Do 
 { 
 $wait = "." + $wait
 $FileSize = (Get-Item $ZipFileName).length
 <#"file size is $FileSize"#>
 "pending $wait"
 Start-Sleep -Seconds 30
 }
 until ($FileSize -ge 100)
 "Zip file for $Server created."
 "File size = $FileSize."

<# Deleting files older than 180 Days
To change the date range enter a new # of Daysback
#>
$Daysback = "-180"
 "Deleting the files older than $Daysback days."
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem $Path -include *.txt* -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Force 
Get-ChildItem $Path -include *.log -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Force 
"Deleting Files complete. `r`n`r`n" 
}
"The Zip file creation for servers $myServers is complete"




=======
﻿<#IMPORTANT NOTE: This script needs to be run as a user that has permissions to the folders on the server.
PLEASE VERIFY user access is correct before running this script. #>
<# 
List the servers that you want to be able to access

$myServers = @("m961", "m976", "NJ1AppsExt3Dev-VM", "NJ1AppsInt1dev-vm")
#>
$myServers = @("m037", "m038", "m051", "m072", "M073", "m076", "m077", "nj1appsint1a", "nj1int1", "nj1int2", "nj1int3", "nj1net1", "M017", "M035")
<#
This for loop will go through each server and grab the files to be zipped
#>
foreach ($server in $myServers)
{
<#
Make modifications to the directory where the files are. 
The statement below requires the server name to be part of the folder name
#>
$path = "\\" + $server + "\" + $server + "weblogs"
set-location -path $path
$Directory = Get-Item . 
<#
Change the location for storing the zip file
#>
$ParentDirectory = "\\nj1ad1\ndrive\Transfer\KRhodes\ServerZipLogs" #"N:\Transfer\KRhodes\ServerZipLogs"
$ZipFileName = $ParentDirectory + "\" + $Directory.Name + "$(Get-Date -Format 'yyyy-MM').zip"
<# If the file being created exists in the target directory
delete it #>
"Checking if Zip file exists in the target directory."
if (test-path $ZipFileName) { 
  echo "Zip file already exists and is being deleted $ZipFileName."
  Remove-Item $ZipFileName -force 
  Start-Sleep -Seconds 5
  }
set-content $ZipFileName ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
(dir $ZipFileName).IsReadOnly = $false 
<#
The zip file is being created and stored in the location specified
#>
$ZipFile = (new-object -com shell.application).NameSpace($ZipFileName)

$ZipFile.CopyHere($Directory.FullName)

 
 "Starting zip file creation for server $Server."
  $wait = ""
Do 
 { 
 $wait = "." + $wait
 $FileSize = (Get-Item $ZipFileName).length
 <#"file size is $FileSize"#>
 "pending $wait"
 Start-Sleep -Seconds 30
 }
 until ($FileSize -ge 100)
 "Zip file for $Server created."
 "File size = $FileSize."

<# Deleting files older than 180 Days
To change the date range enter a new # of Daysback
#>
$Daysback = "-180"
 "Deleting the files older than $Daysback days."
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem $Path -include *.txt* -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Force 
Get-ChildItem $Path -include *.log -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item -Force 
"Deleting Files complete. `r`n`r`n" 
}
"The Zip file creation for servers $myServers is complete"




>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
| Select-Object -Property *