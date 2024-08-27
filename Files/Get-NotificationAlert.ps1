<<<<<<< HEAD
﻿
function Get-LastBootupTime
{
    #Get Current Date
    [datetime]$CurrentDate = Get-Date
    #Get last boot up time
    $lb =  Get-CimInstance -ClassName win32_OperatingSystem | select lastbootuptime
    [datetime]$lbt = $lastbootuptime.lastbootuptime

    #Compare last boot up to any time duration. Example shows if bootup was more than an hour ago pop up alert.
    if ($lbt -lt $CurrentDate.AddHours(-1))
    {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
        $objNotifyIcon.Icon = "C:\PowerShell\Ico\PowerShell.ico"
        $objNotifyIcon.BalloonTipIcon = "Error" 
        $objNotifyIcon.BalloonTipText = "Your last reboot was $lbt." 
        $objNotifyIcon.BalloonTipTitle = "MPR Computer Reboot Policy"
 
        $objNotifyIcon.Visible = $True 
        $objNotifyIcon.ShowBalloonTip(10000)
    }

 }

 Get-LastBootupTime



   

   #[datetime]$CurrentDate = Get-Date
   #$CurrentDate.AddHours(-48)
   

=======
﻿
function Get-LastBootupTime
{
    #Get Current Date
    [datetime]$CurrentDate = Get-Date
    #Get last boot up time
    $lb =  Get-CimInstance -ClassName win32_OperatingSystem | select lastbootuptime
    [datetime]$lbt = $lastbootuptime.lastbootuptime

    #Compare last boot up to any time duration. Example shows if bootup was more than an hour ago pop up alert.
    if ($lbt -lt $CurrentDate.AddHours(-1))
    {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
        $objNotifyIcon.Icon = "C:\PowerShell\Ico\PowerShell.ico"
        $objNotifyIcon.BalloonTipIcon = "Error" 
        $objNotifyIcon.BalloonTipText = "Your last reboot was $lbt." 
        $objNotifyIcon.BalloonTipTitle = "MPR Computer Reboot Policy"
 
        $objNotifyIcon.Visible = $True 
        $objNotifyIcon.ShowBalloonTip(10000)
    }

 }

 Get-LastBootupTime



   

   #[datetime]$CurrentDate = Get-Date
   #$CurrentDate.AddHours(-48)
   

>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
