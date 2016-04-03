#Break statement added to stop you from accidentally running all the functions by clicking "Run Script" or hitting F5
    Write-o "Stop hitting F5"
    break

#Show scheduling a job and creating a job
#Create Trigger, options, and then Job
$trigger = New-JobTrigger –Daily -At "12:15 AM"
#Set options, can use default by passing no parameters
$options = New-ScheduledJobOption 
$pwd = ConvertTo-SecureString "zaJzkwxCVmyg0JedP5Db" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("Mathematica\JSMonad_SVC", $pwd)
Register-ScheduledJob -Name "Invoke-TPPTASharepointBZC" -ScriptBlock { Invoke-TPPTASharepointBZC } -Trigger $trigger -ScheduledJobOption $options


#Show job history
Get-Job | Format-Table -AutoSize
Get-Job -IncludeChildJob | Select-Object -Property *  |Format-Table -AutoSize
Get-Job | Select-Object -Property * 
Get-Job | Select-Object -Property * | Where-Object { $_.Name -eq 'Invoke-TPPTASharepointBZC'}
Get-Job | Select-Object -Property * | Where-Object { $_.Name -eq 'New-DatabaseBackup'}
Get-Job | Select-Object -Property * | Where-Object { $_.Name -eq 'Write-S3Backup'}
Get-Job | Select-Object -Property Name, State, PSBeginTime, ID | Where-Object { $_.Name -eq 'Remove-Backups'} |Format-Table -AutoSize

start-job


#Show scheduled jobs
Get-ScheduledJob | Format-Table -AutoSize
Get-ScheduledJob | Select * 
Get-ScheduledJob | Select * | Where-Object { $_.Id -eq 2}

#Unregister
Unregister-ScheduledJob -Name Invoke-TPPTASharepointBZC


#Modify ScheduledJob and JobTrigger
$pwd = ConvertTo-SecureString "zaJzkwxCVmyg0JedP5Db" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("Mathematica\JSMonad_SVC", $pwd)
Get-ScheduledJob -Name Invoke-TPPTASharepointBZC | Set-ScheduledJob -ScriptBlock { Invoke-TPPTASharepointBZC } -Trigger $trigger -ScheduledJobOption $options -Credential $creds 

Get-JobTrigger -Name Invoke-TPPTASharepointBZC | Set-JobTrigger -Daily -At "04:00 PM"
Get-JobTrigger -Name New-DatabaseBackup | Set-JobTrigger -Daily -At "05:00 PM"
Get-JobTrigger -Name Write-S3Backup | Set-JobTrigger -Daily -At "06:00 PM"


Start-Job -ScriptBlock { Invoke-TPPTASharepointBZC } 
Start-Job -ScriptBlock { Write-S3Backup } 
Start-Job -ScriptBlock { Remove-Backups } 

Receive-Job -Id 8



#1. Remove @ 4 PM
#2. Backup @ 5 PM
#3. Write  @ 6 PM








