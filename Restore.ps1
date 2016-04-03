<<<<<<< HEAD
<#
.Synopsis
   Backs up and test user databases using second instance
.DESCRIPTION
   This script will perform a full backup of the user databases on a server, restore them
   to a second SQL Server instance, and perform a DBCC CheckDB on each restored database.
   It will verify before each restore that there's enough free space on the target disk
   drives before performing the restore, and it will kill all processes connected to the 
   database being restored so it can overwrite the database there if it already exists.
.EXAMPLE
   ./test-dr.ps1 WS12SQL WS12SQL\TEST01 c:\Workdir
   ./test-dr.ps1 JLANGDON JLANGDON\SQLEXPRESS c:\Workdir
.EXAMPLE
   ./test-dr.ps1 WS12SQL1 WS12SQL2 \\WS12SQL3\Workdir
#>


# Get the SQL Server instance name from the command line
[CmdletBinding()]
param(
  # srcinst is the SQL Server instance being backed up
  [Parameter(Mandatory=$true)]
  [string]$srcinst=$null,
  # dstinst is the SQL Server instance where the databases will be restored and tested
  [Parameter(Mandatory=$true)]
  [string]$dstinst=$null,
  # workdir is the directory where the backups will be written
  [Parameter(Mandatory=$true)]
  [string]$workdir=$null
  )


# Handle any errors that occur
Trap {
  # Handle the error
  $err = $_.Exception
  write-output $err.Message
  while( $err.InnerException ) {
  	$err = $err.InnerException
  	write-output $err.Message
  	};
  # Continue the script.
  continue
  }

# Change log:
# July 30, 2013: Allen White
#   Initial Version


<# Connect to the specified instance
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $srcinst
$srv.ConnectionContext.StatementTimeout = 0
$dbs = $srv.Databases
$bdir = $workdir
#>

<#

# Set up a collection to store the database names and backup files
$bup = @()

foreach ($db in $dbs)
  {
  if ($db.IsSystemObject -eq $False)
  #if (($db.IsSystemObject -eq $False) -or ($db.name -ne "Medicare_Test" ))			# Only back up user databases
    {
	$dbname = $db.Name
        #$dt = Get-Date -Format yyyyMMddHHmmss
        #$bfile = "$bdir\$($dbname)_db_$($dt).bak"
		$bfile = "$bdir\$($dbname).bak"
	$bkup = New-Object System.Object
	$bkup | Add-Member -type NoteProperty -name Name -value $dbname
	$bkup | Add-Member -type NoteProperty -name Filename -value $bfile
	$bup += $bkup
        #Backup-SqlDatabase -ServerInstance $srcinst -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly
		Backup-SqlDatabase -InputObject $srv -Database $dbname -BackupFile $bfile -CompressionOption On  -CopyOnly 
    }
  }
  #>

# Connect to the destination instance
$dst = new-object ('Microsoft.SqlServer.Management.Smo.Server') $dstinst
# Get the default file and log locations
# (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
$fileloc = $dst.Settings.DefaultFile
$logloc = $dst.Settings.DefaultLog
if ($fileloc.Length -eq 0) {
    $fileloc = $dst.Information.MasterDBPath
    }
if ($logloc.Length -eq 0) {
    $logloc = $dst.Information.MasterDBLogPath
    }

# Get the free space on all drives on the destination machine
$dtmp = $dstinst.Split('\')
$dmachine = $dtmp[0]
$dsk = Get-WMIObject -Query 'select * from Win32_LogicalDisk where DriveType = 3' -computername $dmachine
$free = @()
foreach ($d in $dsk) {
	$drv = New-Object System.Object
	$drv | Add-Member -type NoteProperty -name Name -value $d.DeviceID
	$drv | Add-Member -type NoteProperty -name FreeSpace -value $d.FreeSpace
	$free += $drv
	}
	
# Now restore the databases to the destination server
foreach ($bkup in $bup)
  {
  $bckfile = $bkup.Filename
  $dbname  = $bkup.Name

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
  $fl = $rs.ReadFileList($srv)
  $fl | foreach {
    $dfile = Split-Path $_.PhysicalName -leaf
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $_.LogicalName
	$rssize = $_.Size
    if ($_.Type -eq 'D') {
      $rsfile.PhysicalFileName = $fileloc + '\' + $dfile
	  $ddrv = Split-Path $fileloc -Qualifier
      }
    else {
      $rsfile.PhysicalFileName = $logloc + '\' + $dfile
 	  $ddrv = Split-Path $logloc -Qualifier
     }
    $rfl += $rsfile
	
	#Reduce the free space on the destination drive to ensure we have enough space on disk before restoring
	For ($i=0; $i -lt $free.Count; $i++) {
		if ($free[$i].Name -eq $ddrv) {
			$free[$i].FreeSpace -= $rssize
			}
		}
    }
  
  # Check to see if free space ran out based on the restore size
  $spaceok = $True
	For ($i=0; $i -lt $free.Count; $i++) {
		if ($free[$i].FreeSpace -lt 0) {
			$spaceok = $False
			}
		}
   
  # Restore the database if free space is ok
  if ($spaceok) {
	# Get everyone out of the database
	$dst.KillAllProcesses($dbname)
	# Restore the database
	Restore-SqlDatabase -ServerInstance $dstinst -Database $dbname -BackupFile $bckfile -RelocateFile $rfl -ReplaceDatabase 
	}
  }
  
# Get the databases from the destination, and iterate through them
<#
$dbs = $dst.Databases
foreach ($db in $dbs) {
  # Check to make sure the database is not a system database, and is accessible
  if ($db.IsSystemObject -ne $True -and $db.IsAccessible -eq $True) {
    # Store the database name for reporting
    $dbname = $db.Name
    
    # Peform the database check
    $db.CheckTables('None')
    
    }	
  }#>

  $baks = @{}

  Get-ChildItem -Path \\mathematica.net\NDrive\Transfer\JLangdon\BR | Select-Object Name | 
        
        Foreach {
            
            Write-Host Name
            
            }

  

  $baks

  $baks.keys

  $baks | get-member
  
  #Write-Host $baks
=======
<#
.Synopsis
   Backs up and test user databases using second instance
.DESCRIPTION
   This script will perform a full backup of the user databases on a server, restore them
   to a second SQL Server instance, and perform a DBCC CheckDB on each restored database.
   It will verify before each restore that there's enough free space on the target disk
   drives before performing the restore, and it will kill all processes connected to the 
   database being restored so it can overwrite the database there if it already exists.
.EXAMPLE
   ./test-dr.ps1 WS12SQL WS12SQL\TEST01 c:\Workdir
   ./test-dr.ps1 JLANGDON JLANGDON\SQLEXPRESS c:\Workdir
.EXAMPLE
   ./test-dr.ps1 WS12SQL1 WS12SQL2 \\WS12SQL3\Workdir
#>


# Get the SQL Server instance name from the command line
[CmdletBinding()]
param(
  # srcinst is the SQL Server instance being backed up
  [Parameter(Mandatory=$true)]
  [string]$srcinst=$null,
  # dstinst is the SQL Server instance where the databases will be restored and tested
  [Parameter(Mandatory=$true)]
  [string]$dstinst=$null,
  # workdir is the directory where the backups will be written
  [Parameter(Mandatory=$true)]
  [string]$workdir=$null
  )


# Handle any errors that occur
Trap {
  # Handle the error
  $err = $_.Exception
  write-output $err.Message
  while( $err.InnerException ) {
  	$err = $err.InnerException
  	write-output $err.Message
  	};
  # Continue the script.
  continue
  }

# Change log:
# July 30, 2013: Allen White
#   Initial Version


<# Connect to the specified instance
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $srcinst
$srv.ConnectionContext.StatementTimeout = 0
$dbs = $srv.Databases
$bdir = $workdir
#>

<#

# Set up a collection to store the database names and backup files
$bup = @()

foreach ($db in $dbs)
  {
  if ($db.IsSystemObject -eq $False)
  #if (($db.IsSystemObject -eq $False) -or ($db.name -ne "Medicare_Test" ))			# Only back up user databases
    {
	$dbname = $db.Name
        #$dt = Get-Date -Format yyyyMMddHHmmss
        #$bfile = "$bdir\$($dbname)_db_$($dt).bak"
		$bfile = "$bdir\$($dbname).bak"
	$bkup = New-Object System.Object
	$bkup | Add-Member -type NoteProperty -name Name -value $dbname
	$bkup | Add-Member -type NoteProperty -name Filename -value $bfile
	$bup += $bkup
        #Backup-SqlDatabase -ServerInstance $srcinst -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly
		Backup-SqlDatabase -InputObject $srv -Database $dbname -BackupFile $bfile -CompressionOption On  -CopyOnly 
    }
  }
  #>

# Connect to the destination instance
$dst = new-object ('Microsoft.SqlServer.Management.Smo.Server') $dstinst
# Get the default file and log locations
# (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
$fileloc = $dst.Settings.DefaultFile
$logloc = $dst.Settings.DefaultLog
if ($fileloc.Length -eq 0) {
    $fileloc = $dst.Information.MasterDBPath
    }
if ($logloc.Length -eq 0) {
    $logloc = $dst.Information.MasterDBLogPath
    }

# Get the free space on all drives on the destination machine
$dtmp = $dstinst.Split('\')
$dmachine = $dtmp[0]
$dsk = Get-WMIObject -Query 'select * from Win32_LogicalDisk where DriveType = 3' -computername $dmachine
$free = @()
foreach ($d in $dsk) {
	$drv = New-Object System.Object
	$drv | Add-Member -type NoteProperty -name Name -value $d.DeviceID
	$drv | Add-Member -type NoteProperty -name FreeSpace -value $d.FreeSpace
	$free += $drv
	}
	
# Now restore the databases to the destination server
foreach ($bkup in $bup)
  {
  $bckfile = $bkup.Filename
  $dbname  = $bkup.Name

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
  $fl = $rs.ReadFileList($srv)
  $fl | foreach {
    $dfile = Split-Path $_.PhysicalName -leaf
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $_.LogicalName
	$rssize = $_.Size
    if ($_.Type -eq 'D') {
      $rsfile.PhysicalFileName = $fileloc + '\' + $dfile
	  $ddrv = Split-Path $fileloc -Qualifier
      }
    else {
      $rsfile.PhysicalFileName = $logloc + '\' + $dfile
 	  $ddrv = Split-Path $logloc -Qualifier
     }
    $rfl += $rsfile
	
	#Reduce the free space on the destination drive to ensure we have enough space on disk before restoring
	For ($i=0; $i -lt $free.Count; $i++) {
		if ($free[$i].Name -eq $ddrv) {
			$free[$i].FreeSpace -= $rssize
			}
		}
    }
  
  # Check to see if free space ran out based on the restore size
  $spaceok = $True
	For ($i=0; $i -lt $free.Count; $i++) {
		if ($free[$i].FreeSpace -lt 0) {
			$spaceok = $False
			}
		}
   
  # Restore the database if free space is ok
  if ($spaceok) {
	# Get everyone out of the database
	$dst.KillAllProcesses($dbname)
	# Restore the database
	Restore-SqlDatabase -ServerInstance $dstinst -Database $dbname -BackupFile $bckfile -RelocateFile $rfl -ReplaceDatabase 
	}
  }
  
# Get the databases from the destination, and iterate through them
<#
$dbs = $dst.Databases
foreach ($db in $dbs) {
  # Check to make sure the database is not a system database, and is accessible
  if ($db.IsSystemObject -ne $True -and $db.IsAccessible -eq $True) {
    # Store the database name for reporting
    $dbname = $db.Name
    
    # Peform the database check
    $db.CheckTables('None')
    
    }	
  }#>

  $baks = @{}

  Get-ChildItem -Path \\mathematica.net\NDrive\Transfer\JLangdon\BR | Select-Object Name | 
        
        Foreach {
            
            Write-Host Name
            
            }

  

  $baks

  $baks.keys

  $baks | get-member
  
  Write-Host $baks
>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
