function Restore-ForEach
{
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$bkdir
	)

	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $instance
	$srv.ConnectionContext.StatementTimeout = 0

    #Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Create server object, set name from variables
	
	#Start restore by getting database names from csv file
	$ImportedDBS = Get-Content -Path c:\Powershell\Text\backedup.csv -Delimiter ","
	foreach ($dt in $ImportedDBS)
	{
		$dbname = ""
		if ($dt.contains(“,”))
		{
			$dbname = $dt.Replace(",", "")
		}
		else
		{
			$dbname = [string]$dt.trim()
		}
		#Set-Location c:

        # Get the default file and log locations
        # (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
        $fileloc = $srv.Settings.DefaultFile
        $logloc = $srv.Settings.DefaultLog
        if ($fileloc.Length -eq 0) {
            $fileloc = $srv.Information.MasterDBPath
            }
        if ($logloc.Length -eq 0) {
            $logloc = $srv.Information.MasterDBLogPath
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
          $fl = $rs.ReadFileList($srv)
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
	        $srv.KillAllProcesses($dbname)
            $rs.SqlRestore($srv)
            $db = $srv.databases[$dbname]
            $db.SetOwner('sa', $TRUE)
	        #Restore-SqlDatabase -ServerInstance $dstinst -Database $dbname -BackupFile $bckfile -RelocateFile $rfl -ReplaceDatabase 

		}
		catch
		{
			#Write-Host "Exception: $($_.Exception)"
            Write-Host "Exception: $($_.Exception.GetBaseException().Message)"
            
			throw $_.Exception
		}
   
          }
		

}

Restore-ForEach -instance 'NJ1DEVC' -bkdir '\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\Migrate\'

#Make sure service account has permissions to read from the network drive
