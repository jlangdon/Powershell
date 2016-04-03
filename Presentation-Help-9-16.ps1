<<<<<<< HEAD
﻿# PowerShell console: All Programs > Accessories > Windows PowerShell > WindowsPowerShell.exe
# PowerShell ISE (Integrated Scripting Environment: All Programs > Accessories > Windows PowerShell > WindowsPowerShellISE.exe
# PowerShell ISE: F5 = Run Script, F8 = Run Selection 


# Powershell people you should follow/read

# Jeffrey Snover: Lead Archtect, Father of Powershell - @jsnover
Start-Process 'https://twitter.com/jsnover'

# PowerShell Monad Manifesto - August 2002
Start-Process 'http://blogs.msdn.com/b/powershell/archive/2007/03/19/monad-manifesto-the-origin-of-windows-powershell.aspx'
# PowerShell V 1.0 - November 14, 2006
# PowerShell V 2.0 - August 2009 (Windows 7)
# PowerShell V 3.0 - Sepetember 2012
# PowerShell v 4.0 - October 2013 (Windows 8.1/Windows Server 2012) - Windows Management Framework 4.0# PowerShell v 5.0 - Windows Management Framework 5.0 preview released May 2014

# MPR Current version is 4.0
$PSVersionTable.PSVersion

# Don Jones - PowerShell.org President / PowerShell MVP   - @concentrateddon
Start-Process 'https://twitter.com/concentrateddon'

# The Scripting Guy - @ScriptingGuys - Ed Wilson 
Start-Process 'https://twitter.com/ScriptingGuys'

# The Help System - Don't memorize - Discover!

<# The help system has two main goals: to help you find commands to perform specific
tasks, and to help you learn how to use those commands once you’ve found them.  

Reference: Don Jones, Learning Windows PowerShell in a month of lunches #>

# Realtime updates - not release or update dependent, updates can be done on-demand.
update-help -Force   # Run As Adminstrator


# Cmdlet (Command Let) has a verb (Get) and noun (Service) naming convention
get-help get-service # Get help on cmdlet get-service    



help get-service # or man get-service, are functions, which are basically wrappers around the core Get-Help cmdlet



get-verb  #  Understand the Verb-Noun convention, list verbs that are used with cmdlets.



get-verb | measure   # count how many verbs



get-help *service*   #Wildcard search with * asterisk. Find cmdlets with service in the name



get-help g*service* #Wildcard before * to search for all "Get" verbs with Service noun.



cls ; Get-Module -ListAvailable  



cls ; get-help g*adcomputer*  # get cmdlets that work with Active Directory 



cls ; get-help get-adcomputer #notice AD module loads - PowerShell is smart enough to load the module first



cls ; get-help get-service -detailed  # Parameter sets, analgous to method overloading. Go through examples



cls ; get-help get-service -examples # cut to the chase, only show examples



cls ; get-help get-service -full  #  includes parameter information



get-help get-service -showwindow  # Settings uncheck everything except examples, show functionality including zoom. 
# Find -Name


cls ; get-service -Name wuauserv  # Default columns are determinded by a "view".


cls ; get-service | gm  # Alias for get-member - Properties return as columns


cls ; get-service -Name wuauserv | Format-Table -Property *  #Select all columns (properties).


cls ; get-service -Name wuauserv | Format-Table -Property Name, ServiceName, DisplayName, ServiceType -autosize


cls ; get-service -Name c*, w*  #  Collections using wildcards


cls ; get-service -DisplayName web*  # Don't have to remember Display Name, partial word search with wildcards.


cls ; gsv wuauserv   # Using Cmdlet alias with positional parameter. Alias not recommended in scripts - Think of the next guy/girk who tries to debug your code.


cls ; get-alias  #List all aliases


cls ; get-help *eventlog*     # about_eventlogs Help file


cls ; get-help about_eventlogs


cls ; get-help About_*   # Get a list of all Help topics


get-help get-service -online # view help online, perhaps easier to read. Dynamic help not available in V1 or V2


=======
﻿# PowerShell console: All Programs > Accessories > Windows PowerShell > WindowsPowerShell.exe
# PowerShell ISE (Integrated Scripting Environment: All Programs > Accessories > Windows PowerShell > WindowsPowerShellISE.exe
# PowerShell ISE: F5 = Run Script, F8 = Run Selection 


# Powershell people you should follow/read

# Jeffrey Snover: Lead Archtect, Father of Powershell - @jsnover
Start-Process 'https://twitter.com/jsnover'

# PowerShell Monad Manifesto - August 2002
Start-Process 'http://blogs.msdn.com/b/powershell/archive/2007/03/19/monad-manifesto-the-origin-of-windows-powershell.aspx'
# PowerShell V 1.0 - November 14, 2006
# PowerShell V 2.0 - August 2009 (Windows 7)
# PowerShell V 3.0 - Sepetember 2012
# PowerShell v 4.0 - October 2013 (Windows 8.1/Windows Server 2012) - Windows Management Framework 4.0# PowerShell v 5.0 - Windows Management Framework 5.0 preview released May 2014

# MPR Current version is 4.0
$PSVersionTable.PSVersion

# Don Jones - PowerShell.org President / PowerShell MVP   - @concentrateddon
Start-Process 'https://twitter.com/concentrateddon'

# The Scripting Guy - @ScriptingGuys - Ed Wilson 
Start-Process 'https://twitter.com/ScriptingGuys'

# The Help System - Don't memorize - Discover!

<# The help system has two main goals: to help you find commands to perform specific
tasks, and to help you learn how to use those commands once you’ve found them.  

Reference: Don Jones, Learning Windows PowerShell in a month of lunches #>

# Realtime updates - not release or update dependent, updates can be done on-demand.
update-help -Force   # Run As Adminstrator


# Cmdlet (Command Let) has a verb (Get) and noun (Service) naming convention
get-help get-service # Get help on cmdlet get-service    



help get-service # or man get-service, are functions, which are basically wrappers around the core Get-Help cmdlet



get-verb  #  Understand the Verb-Noun convention, list verbs that are used with cmdlets.



get-verb | measure   # count how many verbs



get-help *service*   #Wildcard search with * asterisk. Find cmdlets with service in the name



get-help g*service* #Wildcard before * to search for all "Get" verbs with Service noun.



cls ; Get-Module -ListAvailable  



cls ; get-help g*adcomputer*  # get cmdlets that work with Active Directory 



cls ; get-help get-adcomputer #notice AD module loads - PowerShell is smart enough to load the module first



cls ; get-help get-service -detailed  # Parameter sets, analgous to method overloading. Go through examples



cls ; get-help get-service -examples # cut to the chase, only show examples



cls ; get-help get-service -full  #  includes parameter information



get-help get-service -showwindow  # Settings uncheck everything except examples, show functionality including zoom. 
# Find -Name


cls ; get-service -Name wuauserv  # Default columns are determinded by a "view".


cls ; get-service | gm  # Alias for get-member - Properties return as columns


cls ; get-service -Name wuauserv | Format-Table -Property *  #Select all columns (properties).


cls ; get-service -Name wuauserv | Format-Table -Property Name, ServiceName, DisplayName, ServiceType -autosize


cls ; get-service -Name c*, w*  #  Collections using wildcards


cls ; get-service -DisplayName web*  # Don't have to remember Display Name, partial word search with wildcards.


cls ; gsv wuauserv   # Using Cmdlet alias with positional parameter. Alias not recommended in scripts - Think of the next guy/girk who tries to debug your code.


cls ; get-alias  #List all aliases


cls ; get-help *eventlog*     # about_eventlogs Help file


cls ; get-help about_eventlogs


cls ; get-help About_*   # Get a list of all Help topics


get-help get-service -online # view help online, perhaps easier to read. Dynamic help not available in V1 or V2


>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
