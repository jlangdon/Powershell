Import-Module "SQLPS" -DisableNameChecking

$instanceName = "JLANGDON\MSSQLSERVER2012"
$OldUser = "Mathematica\JLangdon"
$NewUser = "Mathematica\SReid"
$DBRoleName = "db_executor"
$TotalDatabases = 0

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

foreach ($db in $server.Databases) {  #Iterate through each database

        foreach ($user in $db.Users) { #Iterate through each user

                if($user.Name -like $OldUser) {  #Check if database has an $OldUser account
                
                        #Set UserExist to false. #Check if database has an $NewUser account
                        $UserExist = 0
                        foreach ($user in $db.Users) {
                            if($user.Name.Contains($NewUser)) { #If $NewUser exists set to 1 and exit loop
                                $UserExist = 1
                                    Break
                            }               
                        }       
                        if($UserExist -eq 0) {                
                            #Add $NewUser
                            $DBUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User $db, $NewUser
                            $DBUser.Login = $NewUser
                            $DBUser.Create()
                            Write-Host "Database Name: " $db.name
                            $TotalDatabases++ 
                        }

                        #Set RoleExist to false, if it exists in $role set to true and don't create.
                        $RoleExist = 0
                        foreach ($role in $db.Roles) {
                            if($role.Name.Contains($DBRoleName)) {
                                $RoleExist = 1
                                Break
                            }               
                        }
                        #If role doesn't exist, create it.
                        if($RoleExist -eq 0) {
                                #Create db role
                                $DBRole = New-Object -TypeName Microsoft.SqlServer.Management.Smo.DatabaseRole $db, $DBRoleName
                                $DBRole.Create()
                                #Create execute permisisons, grant to new db role
                                $permissions = New-Object Microsoft.SqlServer.Management.Smo.DatabasePermissionSet([Microsoft.SqlServer.Management.Smo.DatabasePermission]::Execute)
                                $db.Grant($permissions, $DBRole.Name)
                        }


                        #Add database roles to user
                        $DBUser.AddToRole("db_executor")
                        $DBUser.AddToRole("db_datareader")
                        $DBUser.AddToRole("db_datawriter") 

                        Break


                }
        }
    
}

Write-Host "Database user created for " $TotalDatabases "Databases"
