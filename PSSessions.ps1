<<<<<<< HEAD
﻿$sessions = New-PSSession -comp NJ1SQL08DEVA,NJ1SQL08DEVB

enter-pssession -session $sessions[1]

enter-pssession -session ($sessions | where { $_.computername -eq 'NJ1SQL08DEVA' })

Exit-PSSession

$sessions | gm

Get-PSSession

=======
﻿$sessions = New-PSSession -comp NJ1SQL08DEVA,NJ1SQL08DEVB

enter-pssession -session $sessions[1]

enter-pssession -session ($sessions | where { $_.computername -eq 'NJ1SQL08DEVA' })

Exit-PSSession

$sessions | gm

Get-PSSession

>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
invoke-command -command { get-wmiobject -class win32_process } -session $sessions