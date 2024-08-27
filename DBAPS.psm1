<#
  =======================================================================
	 Created on:   	12/22/2015 3:18 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	dbaps.psm1
	-------------------------------------------------------------------------
	 Module Name: DBAPS
	===========================================================================
#>

#import sqlps module if not loaded
if(-not(get-module -name 'sqlps'))
{
    import-module sqlps -disablenamechecking
}
function New-WinLoginUserRoles {
    [CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$winlogin,
		[Parameter(Mandatory = $true)][string]$dbname,
        [Parameter(Mandatory = $true)][array]$dbroles
	)
    
	#Get instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
    #Get database object 
	$db = $server.Databases[$dbname]
    if ($db  -eq $null)
	{
        $Results = 'db does not exist, plase check name'
	}
	else
	{
        #Remove commas from database roles
        $roles = $dbroles.split(',')
	    #Clear output results
	    $Results = ''
	
        #check iF account exists in AD
        $parts = $winlogin.split('\')
        $SAM = $parts[1]
        $Name = Get-ADUser -Filter 'SamAccountName -like $SAM' | Select-Object Name
        if ($Name  -eq $null)
	    {
            $Results = 'Account does not exist in AD'
            #Create account before login and user can be added
	    }
	    else
	    {
	        #Check if login exists, if not create it
	        if ($server.Logins[$winlogin] -eq $null)
	        {
                $SqlUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $Winlogin
                $SqlUser.LoginType = 'WindowsUser'
                $sqlUser.DefaultDatabase = 'master'
                $SqlUser.Create()
                $Results = 'Login added,'
	        }
	        else
	        {
		        $Results = 'Login exists,'
	        }
	
	        #Check if dbuser exists, if not create it
            if ($db.Users[$winlogin] -eq $null) 
	            {
                    $dbuser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $db, $Winlogin
                    $dbuser.defaultSchema = 'dbo'
                    $dbuser.Login = $Winlogin
                    $dbuser.Create()
                    $Results += ' user created, '

                    foreach ($role in $roles)
                    {
                        $role = $role.Trim()
                        $dbrole = New-Object Microsoft.SqlServer.Management.Smo.DatabaseRole -ArgumentList $db, $role
                        $dbrole.AddMember($Winlogin)
		                $Results += $role + ' '
                    }
                    $Results += 'role(s) granted'
	            }
	            else
	            {
                    $db.Users[$Winlogin].Drop()
                    $dbuser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $db, $Winlogin
                    $dbuser.defaultSchema = 'dbo'
                    $dbuser.Login = $Winlogin
                    $dbuser.Create()
                    $Results += ' user exists, '

                    foreach ($role in $roles)
                    {
                        $role = $role.Trim()
                        $dbrole = New-Object Microsoft.SqlServer.Management.Smo.DatabaseRole -ArgumentList $db, $role
                        $dbrole.AddMember($Winlogin)
		                $Results += $role + ' '
                    }
                    $Results += 'role(s) granted'		
	          }
	    }	
    }	
                    Write-Host $Results
} #end New-WinLoginUserRoles 

Function New-Database {
    [CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$orginst,
		[Parameter(Mandatory = $true)][string]$dbname,
		[Parameter(Mandatory = $true)][double]$datafilesize,
		[Parameter(Mandatory = $true)][double]$datafilegrowth,
		[Parameter(Mandatory = $true)][double]$logfilesize,
		[Parameter(Mandatory = $true)][double]$logfilegrowth
	)   
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	#Trim white space
	$db = new-object ('Microsoft.SqlServer.Management.Smo.Database') ($orgsrv, $dbName.Trim())
	# Set the Default File Locations
	$fileloc = $orgsrv.Settings.DefaultFile
	$logloc = $orgsrv.Settings.DefaultLog
	if ($fileloc.Length -eq 0) {
            $fileloc = $dessrv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $dessrv.Information.MasterDBLogPath
            }
		
	# new filegroup object
	$PrimaryFG = New-Object ('Microsoft.SqlServer.Management.SMO.FileGroup') ($db, 'PRIMARY')
	# Add the filegroup object to the database object
	$db.FileGroups.Add($PrimaryFG)
		
	$DataFileName = $db.name + '_Data'
	$DataFile = New-Object ('Microsoft.SqlServer.Management.SMO.DataFile') ($PrimaryFG, $DataFileName)
	$PrimaryFG.Files.Add($DataFile)
	$DataFile.FileName = $fileloc + '\' + $DataFileName + '.mdf'
	$DataFile.Size = $datafilesize * 1024
	$DataFile.Growth = $datafilegrowth * 1024
	$DataFile.GrowthType = 'KB'
	$DataFile.MaxSize = -1
		
	# Create a log file for this database
	$LogFileName = $db.name + '_Log'
	$LogFile = New-Object ('Microsoft.SqlServer.Management.SMO.LogFile') ($DB, $LogFileName)
	$db.LogFiles.Add($LogFile)
	$LogFile.FileName = $logloc + '\' + $LogFileName + '.ldf'
	$LogFile.Size = $logfilesize * 1024
	$LogFile.GrowthType = 'KB'
	$LogFile.Growth = $logfilegrowth * 1024
	$LogFile.MaxSize = -1

    try 
    { 
        $db.Create()
        $db.SetOwner('sa_root', $TRUE)
	    $db.Alter()
	
        Write-Host $db created
        Set-Location c:\
    } 
    catch 
    { 
        Write-Output = "Exception: " $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
		throw $_.Exception
    }
	

} #end New-Database 

function Get-ActiveNode{
    [CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string[]]$instances
	)  
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
    $Instance = $Instances.split(",")
    foreach($I in $Instance){
        try { 
            $S = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $I | Select-Object Name 
            Write-Host $I Active Node: $S.Name
        } 
        catch { 
            Write-Output = "Exception: " $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
        }
    }    
} #end Get-ActiveNode 

function Get-DatabaseRolePermssions {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
        [Parameter(Mandatory = $true)][string]$login
	)
    [reflection.assembly]::LoadWithPartialName("system.io") | Out-Null
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	$orgsrv.ConnectionContext.StatementTimeout = 0
    $dbs = $orgsrv.Databases
    #$roles = $dbroles.split(',')
    #Create array to store logins
    [System.Collections.ArrayList]$results = @()
    #$dbm = $orgsrv.databases['master']
	$dbs = $orgsrv.Databases
	foreach ($db in $dbs)
    {
        #foreach ($login in $logins)
        #{
            if($db.Users.Contains($login))
            {
                foreach($role in $db.roles)
                {
                    $rolemembers = $role.EnumMembers()

                    if($rolemembers -contains $login)
                    {
                        #$results += $login.Name + ' has '  +  $role + ' permissions on ' +  $db
                        $results += New-Object PsObject -property @{
                        'Role' = $role
                        'Database' = $db
                        'Login' = $login}
                    }
                }
            }
        #}
    } 
    $results | Export-Csv -Path 'C:\Powershell\Text\RolePermissions.csv' -NoTypeInformation

} #end Get-DatabaseRolePermssions 

function Invoke-BackupDatabase {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
		[Parameter(Mandatory = $true)][string]$bkdir,
   		[Parameter(Mandatory = $true)][string]$dbname
	)
    #Import SQLPS Module if not loaded
    if(-not(Get-Module -name 'sqlps'))
    {
        Import-Module SQLPS -DisableNameChecking
    }
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
   	$orgsrv.ConnectionContext.StatementTimeout = 0
	$bfile = "$bkdir\$($dbname).bak"
	Backup-SqlDatabase -InputObject $orgsrv.Name -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly -Initialize
    Write-Host $dbname backed up.
} #end Invoke-BackupDatabase 

function Invoke-RestoreDatabase {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$desinst,
		[Parameter(Mandatory = $true)][string]$bkdir,
   		[Parameter(Mandatory = $true)][string]$dbname,
        [Parameter(Mandatory = $true)][string]$versionlevel,
        [switch]$replace

	)
    $dessrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $desinst
   	$dessrv.ConnectionContext.StatementTimeout = 0

    # Get the default file and log locations
    # (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
    $fileloc = $dessrv.Settings.DefaultFile
    $logloc = $dessrv.Settings.DefaultLog
        if ($fileloc.Length -eq 0) {
            $fileloc = $dessrv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $dessrv.Information.MasterDBLogPath
            }
    # Now restore the databases to the destination server
    $bckfile = "$bkdir\$($dbname).bak"
          
	# Build the physical file names for the restored database
    $dbfile = $fileloc + $dbname + '_Data.mdf'
    $logfile = $logloc + $dbname + '_Log.ldf'

    # Use the backup file name to create the backup device
    $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
  
    # Create an empty collection for the RelocateFile objects
    #$fl = @()
  
    # Create a Restore object so we can read the details inside the backup file
    $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
    $rs.Database = $dbname
    $rs.Devices.Add($bdi)
    $rs.ReplaceDatabase = $True

    # Get the file list info from the backup file
    $fl = $rs.ReadFileList($dessrv.name)
    foreach ($fil in $fl) {
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $fil.LogicalName
        if ($fil.Type -eq 'D'){
            $rsfile.PhysicalFileName = $dbfile
        }
        else {
            $rsfile.PhysicalFileName = $logfile
        }
            $rs.RelocateFiles.Add($rsfile) 
        }
    try
    {
		# Restore the database 
	    # Get everyone out of the database
	    $dessrv.KillAllProcesses($dbname)
        if($replace)
        {
            $rs.ReplaceDatabase = $true
        }
        else
        {
            $rs.ReplaceDatabase = $false
        }
        $rs.SqlRestore($dessrv.Name)
        $db = $dessrv.databases[$dbname]
        $db.SetOwner('sa_root', $TRUE)
        $db.CompatibilityLevel =  [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::$versionlevel
        $db.Alter()
        Write-Host $dbname database restored
    }
    catch
    {
        Write-Output = $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
    }
	
}  #end Invoke-RestoreDatabase 

function Invoke-RestoreAsDatabase {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$desinst,
		[Parameter(Mandatory = $true)][string]$bkdir,
		[Parameter(Mandatory = $true)][string]$dbname,
		[Parameter(Mandatory = $true)][string]$asdbname,
		[Parameter(Mandatory = $true)][string]$versionlevel,
        [switch]$replace
	)
     $dbname = $dbName.Trim()
     $asdbname = $asdbname.Trim()
	If ($dbname -eq $asdbname)
	{
		Write-Host 'dbname cannot be the same name as asdbname'
	}
	else
	{
		$dessrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $desinst
		# Get the default file and log locations
		$fileloc = $dessrv.Settings.DefaultFile
		$logloc = $dessrv.Settings.DefaultLog
		if ($fileloc.Length -eq 0)
		{
			$fileloc = $dessrv.Information.MasterDBPath
		}
		if ($logloc.Length -eq 0)
		{
			$logloc = $dessrv.Information.MasterDBLogPath
		}
		# Now restore the databases to the destination server
		$bckfile = "$bkdir\$($dbname).bak"
		
        # Build the physical file names for the database copy
        $dbfile = $fileloc + $asdbname + '_Data.mdf'
        $logfile = $logloc + $asdbname + '_Log.ldf'
    		
		# Use the backup file name to create the backup device
		$bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
		
		# Create an empty collection for the RelocateFile objects
		#$rfl = @()
		
		# Create a Restore object so we can read the details inside the backup file
		$rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
		$rs.Database = $asdbname
		$rs.Devices.Add($bdi)
		
		# Get the file list info from the backup file
		$fl = $rs.ReadFileList($dessrv.name)
		foreach ($fil in $fl)
		    {
			    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
			    $rsfile.LogicalFileName = $fil.LogicalName
			    if ($fil.Type -eq 'D')
			            {
				$rsfile.PhysicalFileName = $dbfile
			}
			    else
			            {
				$rsfile.PhysicalFileName = $logfile
			}
			    $rs.RelocateFiles.Add($rsfile)
		    }
	    }
        $rs.FileNumber = 1
	    try 
        {
		# Restore the database
        
        if($replace)
        {
            $rs.ReplaceDatabase = $true
            $dessrv.KillAllProcesses($asdbname)

        }
        else
        {
            $rs.ReplaceDatabase = $false
        }

		$rs.SqlRestore($dessrv)
		$db = $dessrv.databases[$asdbname]
		$db.SetOwner('sa_root', $TRUE)
		$db.CompatibilityLevel = [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::$versionlevel
		$db.Alter()
        
        #Set Logical Log File Names
        $logname = $dbname + '_Log'
        $aslogname = $asdbname + '_Log'
         
        $mdfLogicalName = Invoke-Sqlcmd –ServerInstance $desinst –Database master –Query "Select name from sys.master_files WHERE name like '$dbname%' and physical_name like '%mdf'"
        $ldfLogicalName = Invoke-Sqlcmd –ServerInstance $desinst –Database master –Query "Select name from sys.master_files WHERE name like '$dbname%' and physical_name like '%ldf'" 
        Invoke-Sqlcmd –ServerInstance $desinst –Database master –Query "ALTER DATABASE [$asdbname] MODIFY FILE (NAME = '$dbname', NEWNAME='$asdbname')" 
        Invoke-Sqlcmd –ServerInstance $desinst –Database master –Query "ALTER DATABASE [$asdbname] MODIFY FILE (NAME = '$logname', NEWNAME='$aslogname')"  
        
        Write-Host $asdbname database restored
        }
        catch
        {
           Write-Output = $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
        }
	
} #end Invoke-RestoreAsDatabase 

function Invoke-BackupRestoreDB {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
        [Parameter(Mandatory = $true)][string]$desinst,
		[Parameter(Mandatory = $true)][string]$bkdir,
   		[Parameter(Mandatory = $true)][string]$dbname,
        [Parameter(Mandatory = $true)][string]$versionlevel,
        [switch]$offline,
        [switch]$replace
	)
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	$orgsrv.ConnectionContext.StatementTimeout = 0
    $dbname = $dbName.Trim()

	$bfile = "$bkdir\$($dbname).bak"
	Backup-SqlDatabase -InputObject $orgsrv.Name -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly -Initialize
    if ($offline) 		{
		$dbobj = $orgsrv.databases[$dbname]
        $orgsrv.KillAllProcesses($dbobj.name)
        $dbobj.SetOffline()
	}

    $dessrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $desinst
   	$dessrv.ConnectionContext.StatementTimeout = 0

    # Get the default file and log locations
    # (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
    $fileloc = $dessrv.Settings.DefaultFile
    $logloc = $dessrv.Settings.DefaultLog
        if ($fileloc.Length -eq 0) {
            $fileloc = $dessrv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $dessrv.Information.MasterDBLogPath
            }
    # Now restore the databases to the destination server
    $bckfile = "$bkdir\$($dbname).bak"
          
	# Build the physical file names for the restored database
    $dbfile = $fileloc + $dbname + '_Data.mdf'
    $logfile = $logloc + $dbname + '_Log.ldf'

    # Use the backup file name to create the backup device
    $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
  
    # Create an empty collection for the RelocateFile objects
    #$rfl = @()
  
    # Create a Restore object so we can read the details inside the backup file
    $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
    $rs.Database = $dbname
    $rs.Devices.Add($bdi)
    $rs.ReplaceDatabase = $True

    # Get the file list info from the backup file
    $fl = $rs.ReadFileList($dessrv.name)
    foreach ($fil in $fl) {
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $fil.LogicalName
        if ($fil.Type -eq 'D'){
            $rsfile.PhysicalFileName = $dbfile
        }
        else {
            $rsfile.PhysicalFileName = $logfile
        }
            $rs.RelocateFiles.Add($rsfile) 
        }
    try
    {
		# Restore the database 
	    # Get everyone out of the database
	    $dessrv.KillAllProcesses($dbname)
        if($replace)
        {
            $rs.ReplaceDatabase = $true
        }
        else
        {
            $rs.ReplaceDatabase = $false
        }
        $rs.SqlRestore($dessrv)
        $db = $dessrv.databases[$dbname]
        $db.SetOwner('sa_root', $TRUE)
        $db.CompatibilityLevel =  [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::$versionlevel
        $db.Alter()
        Write-Host $dbname database restored
    }
    catch
    {
        Write-Output = $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
    }
    
} #end Invoke-BackupRestoreDB 

function Invoke-BackupRestoreWithCSV {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
        [Parameter(Mandatory = $true)][string]$desinst,
		[Parameter(Mandatory = $true)][string]$bkdir,
   		[Parameter(Mandatory = $true)][string]$path,
        [Parameter(Mandatory = $true)][string]$versionlevel,
        [switch]$offline,
        [switch]$replace
    )
    if(-not(Get-Module -name 'sqlps'))
    {
        Import-Module SQLPS -DisableNameChecking
    }
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	$orgsrv.ConnectionContext.StatementTimeout = 0
    #Create array to store backed up databases
	[System.Collections.ArrayList]$bak = @()
	#Get database names from csv file
	$dbs = Get-Content -Path $path -Delimiter ','
	foreach ($db in $dbs)
	{
		$dbname = ''
		if ($db.contains(“,”))
		{
			$dbname = $db.Replace(',', '')
		}
		else
		{
			$dbname = [string]$db.trim()
		}
		$bfile = "$bkdir\$($dbname).bak"
		Backup-SqlDatabase -InputObject $orgsrv.Name -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly -Initialize
        Write-Host $dbname database backed up
        if ($offline)
		{
			$dbobj = $orgsrv.databases[$dbname]
            $orgsrv.KillAllProcesses($dbobj.name)
            $dbobj.SetOffline()
		}
	}
    #Start restore process. Set destination istance, import backed up dbs
    $dessrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $desinst
    $ImportedDBS = Get-Content -Path $path -Delimiter ','
	foreach ($db in $ImportedDBS)
	{
		$dbname = ''
		if ($db.contains(','))
		{
			$dbname = $db.Replace(',', '')
		}
		else
		{
			$dbname = [string]$db.trim()
		}
        # Get the default file and log locations
        # (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
        $fileloc = $dessrv.Settings.DefaultFile
        $logloc = $dessrv.Settings.DefaultLog
        if ($fileloc.Length -eq 0) {
            $fileloc = $dessrv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $dessrv.Information.MasterDBLogPath
            }

        # Now restore the databases to the destination server
            $bckfile = "$bkdir\$($dbname).bak"
          
            # Build the physical file names for the database copy
            $dbfile = $fileloc + $dbname + '_Data.mdf'
            $logfile = $logloc + $dbname + '_Log.ldf'

            # Use the backup file name to create the backup device
            $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
  
            # Create an empty collection for the RelocateFile objects
            $rfl = @()
  
        # Create a Restore object so we can read the details inside the backup file
        $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
        $rs.Database = $dbname
        $rs.Devices.Add($bdi)
        $rs.ReplaceDatabase = $True

        # Get the file list info from the backup file
        $fl = $rs.ReadFileList($dessrv.name)
        foreach ($fil in $fl) {
        $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
        $rsfile.LogicalFileName = $fil.LogicalName
            if ($fil.Type -eq 'D'){
                $rsfile.PhysicalFileName = $dbfile
            }
            else {
                $rsfile.PhysicalFileName = $logfile
            }
                $rs.RelocateFiles.Add($rsfile) 
            }
        try
        {
		    # Restore the database 
	        # Get everyone out of the database
	        $dessrv.KillAllProcesses($dbname)
            if($replace)
            {
                $rs.ReplaceDatabase = $true
            }
            else
            {
                $rs.ReplaceDatabase = $false
            }
            $rs.SqlRestore($dessrv)
            $db = $dessrv.databases[$dbname]
            $db.SetOwner('sa_root', $TRUE)
            $db.CompatibilityLevel =  [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::$versionlevel
            $db.Alter()
            Write-Host $dbname database restored
        }
        catch
        {
            Write-Output = $($_.Exception.Message.ToString() + $_.Exception.StackTrace.ToString())
        }
    }

} #end Invoke-BackupRestoreWithCSV function

function Get-DiskSpace {
    [CmdletBinding()]
	param (
        [Parameter(Mandatory = $true)][string[]]$instance
	)
         $dsk = Get-WmiObject -Class win32_volume -ComputerName $instance -filter 'DriveType=3' | 
        Select Label,@{Name=”DiskSize(GB)”;Expression={[decimal](“{0:N2}” -f($_.capacity/1gb))}}, @{Name=”FreeSpace(GB)”;Expression={[decimal](“{0:N2}” -f($_.freespace/1gb))}}, @{Name="Free (%)";Expression={"{0:N2}" -f((($_.freespace/1gb) / ($_.capacity/1gb)*100))}}  |
        Where-Object {$_.label -match $i + "_Data" -or $_.label -match $i + "_Log" -or $_.label -match $i + "_SYSTEM" -or $_.label -match $i + "_TempDB"}
         $dsk | Format-Table -AutoSize
} #end function Get-DiskSpace

function Test-AgentService{
     [CmdletBinding()]
	    param (
            [Parameter(Mandatory = $true)][string[]]$instances,
            [Parameter(Mandatory = $true)][string[]]$recipients
	    )
    [string[]]$EmailList = $recipients
    $Instance = $Instances.split(",")
    foreach($I in $Instance){
        $Agent = "SQLAgent$" + $I
        $A = Get-Service -ComputerName $I -Name $Agent
        #Write-Host $A.Name  $A.Status
        if ($A.Status -ne 'Running')
        {
            #restart service
            $A | restart-service
            #send email
            $params = @{'to'= $EmailList
            'from'='psagentalert@mathematica-mpr.com'
            'body'="The " + $A.DisplayName + " service was restarted"
            'subject'= "The " + $A.DisplayName + " service was restarted"
            'smtpserver'='intrelay.mathematica-mpr.com'}
            send-mailmessage @params 
        }
        else
		{
			Write-Host "The " $A.DisplayName " service is " $A.Status
		}
    }    
} #end Test-AgentService

Function New-Database {
    [CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$orginst,
		[Parameter(Mandatory = $true)][string]$dbname,
		[Parameter(Mandatory = $true)][double]$datafilesize,
		[Parameter(Mandatory = $true)][double]$datafilegrowth,
		[Parameter(Mandatory = $true)][double]$logfilesize,
		[Parameter(Mandatory = $true)][double]$logfilegrowth
	)   
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
	$orgsrv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
	#Trim white space
	$db = new-object ('Microsoft.SqlServer.Management.Smo.Database') ($orgsrv, $dbName.Trim())
	# Set the Default File Locations
	$fileloc = $orgsrv.Settings.DefaultFile
	$logloc = $orgsrv.Settings.DefaultLog
	if ($fileloc.Length -eq 0) {
            $fileloc = $dessrv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $dessrv.Information.MasterDBLogPath
            }
		
	# new filegroup object
	$PrimaryFG = New-Object ('Microsoft.SqlServer.Management.SMO.FileGroup') ($db, 'PRIMARY')
	# Add the filegroup object to the database object
	$db.FileGroups.Add($PrimaryFG)
		
	$DataFileName = $db.name + '_Data'
	$DataFile = New-Object ('Microsoft.SqlServer.Management.SMO.DataFile') ($PrimaryFG, $DataFileName)
	$PrimaryFG.Files.Add($DataFile)
	$DataFile.FileName = $fileloc + '\' + $DataFileName + '.mdf'
	$DataFile.Size = $datafilesize * 1024
	$DataFile.Growth = $datafilegrowth * 1024
	$DataFile.GrowthType = 'KB'
	$DataFile.MaxSize = -1
		
	# Create a log file for this database
	$LogFileName = $db.name + '_Log'
	$LogFile = New-Object ('Microsoft.SqlServer.Management.SMO.LogFile') ($DB, $LogFileName)
	$db.LogFiles.Add($LogFile)
	$LogFile.FileName = $logloc + '\' + $LogFileName + '.ldf'
	$LogFile.Size = $logfilesize * 1024
	$LogFile.GrowthType = 'KB'
	$LogFile.Growth = $logfilegrowth * 1024
	$LogFile.MaxSize = -1

    try 
    { 
        $db.Create()
        $db.SetOwner('sa_root', $TRUE)
	    $db.Alter()
	
        Write-Host $db created
        Set-Location c:\
    } 
    catch 
    { 
        Write-Host 'Exception: $($_.Exception.GetBaseException().Message)'
		throw $_.Exception
    }
	

} #end New-Database 

function Copy-ServerPrincipals {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$orginst,
		[Parameter(Mandatory = $true)][string]$desinst,
        [Parameter(Mandatory = $true)][string]$filter

	)
	$srvA = new-object ('Microsoft.SqlServer.Management.Smo.Server') $orginst
   	$srvB = new-object ('Microsoft.SqlServer.Management.Smo.Server') $desinst
    $logins = $srvA.Logins |  Where-Object {$_.name -like "$filter*"} | Select-Object -Property Name

   	foreach ($l in $logins)
	{
        $principal = $l.Name.ToString()
        # drop login if it exists
        if ($srvB.Logins.Contains($principal))
        {
        $srvB.Logins[$principal].Drop()
        } 
        $p = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $srvB.Name, $principal
        $p.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::WindowsUser
        $p.Create() 
        Write-Host $p
	}
} #end Copy-ServerPrincipals function


























 
