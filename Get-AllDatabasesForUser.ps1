#Get databases that have this database user
Import-Module SQLPS -DisableNameChecking

$instanceName = "NJ1DBTEMP2\SQLDMADEV"
#$OldUser = "Mathematica\GJones"
$OldUser = "Mathematica\Amarden"

$TotalDatabases = 0

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

foreach ($db in $server.Databases) {  #Iterate through each database

        foreach ($user in $db.Users) { #Iterate through each user

                if($user.Login -like $OldUser) {  #Check if database has an $OldUser account
                
                    Write-Host "Database Name: " $db.name  "DB Login: " $user.Login
                $TotalDatabases++


                }
        }
    
}

Write-Host "Database user created for " $TotalDatabases "Databases"
