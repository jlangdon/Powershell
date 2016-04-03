

$OrgPath = "c:\BackLog"
$DestPath = "c:\F2"
$StartDate = "01/01/2015"
#$EndDate = "05/20/2015" 
Get-ChildItem $OrgPath -Filter *.bak |  Where-Object {$_.LastWriteTime.Date -ge $StartDate} #| Move-Item -Destination $DestPath

 #-and  $_.LastWriteTime.Date -lt $EndDate }

 #Get-ChildItem $DestPath -Filter *.bak 




