$sessions = New-PSSession -comp NJ1SQL08DEVA,NJ1SQL08DEVB

enter-pssession -session $sessions[1]

enter-pssession -session ($sessions | where { $_.computername -eq 'NJ1SQL08DEVA' })

Exit-PSSession

$sessions | gm

Get-PSSession

invoke-command -command { get-wmiobject -class win32_process } -session $sessions