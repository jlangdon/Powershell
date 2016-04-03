<<<<<<< HEAD
﻿Import-Module ActiveDirectory

[System.Reflection.Assembly]::Load("Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[System.Reflection.Assembly]::Load("Microsoft.TeamFoundation.VersionControl.Client, Version=11.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

Function Get-NotificationRecipients([int]$x = 7)
{
    $uri = "http://tfs.mathematica.net:8080/tfs"
    $configServer = [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($uri)
    $tpcNodes = $configServer.CatalogNode.QueryChildren([guid[]][Microsoft.TeamFoundation.Framework.Common.CatalogResourceTypes]::ProjectCollection, $false, [Microsoft.TeamFoundation.Framework.Common.CatalogQueryOptions]::None)
    
    $allCheckOuts = @()
    $connectivityErrors = @()

    # Loop through the Team Project Collections
    $tpcNodes | ForEach-Object -Process {
        
        $tpcGuid = $_.Resource.Properties["InstanceID"]
        $tpcName = $_.Resource.DisplayName
        
        Try
        {
            $versionControlServer = $configServer.GetTeamProjectCollection($tpcGuid).GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer])
            [string[]]$i = "$/" # Start at root, will recurse        
        
            # get all of the checkouts x days old or older and add them to the collection
            $allCheckOuts += $versionControlServer.GetPendingSets($i, [Microsoft.TeamFoundation.VersionControl.Client.RecursionType]::Full) | Select-Object @{Name="Domain";Expression={$_.OwnerName.Substring(0, $_.OwnerName.IndexOf("\"))}}, @{Name="User";Expression={$_.OwnerName.Remove(0, $_.OwnerName.IndexOf("\") + 1)}}, @{Name="TeamProjectCollection";Expression={$tpcName}}, @{Name="Computer";Expression={$_.Computer}}, @{Name="Workspace";Expression={$_.Name}} -ExpandProperty PendingChanges | Where-Object CreationDate -LE (Get-Date).AddDays(-$x)
        }

        Catch
        {
            $obj = New-Object -TypeName PSObject -Property @{TeamProjectCollection=$tpcName}
            $connectivityErrors += $obj
        }
    }

    # Get a distinct list of users with checkouts
    $allUsers = $allCheckOuts | Select-Object Domain, User | Sort-Object Domain, User | Get-Unique -AsString

    $notificationRecipients = @()
    $checkOutErrors = @()

    # Loop through the distinct list of users
    $allUsers | ForEach-Object -Process {
        
        $user = $_.User
        $domain = $_.Domain      

        Try
        {
            $adUser = Get-ADUser $user -Server $domain -Properties EmailAddress, Manager
            $csv = "C:\TFS\" + $user + ".csv"

            # Create a csv containing checkout data for each user
            $allCheckOuts | Where-Object User -EQ $user | Sort-Object TeamProjectCollection, CreationDate | Select-Object Domain, User, TeamProjectCollection, Computer, Workspace, ServerItem, LocalItem, ChangeTypeName, @{Name="CheckOutDate";Expression={Get-Date $_.CreationDate -Format d}} | Export-Csv $csv -NoTypeInformation

            $objNormal = New-Object -TypeName PSObject -Property @{Email=$adUser.EmailAddress; SupEmail=(Get-ADUser $adUser.Manager -Properties EmailAddress).EmailAddress; CSV=$csv}           
            $notificationRecipients += $objNormal
        }
        
        Catch
        {            
            $checkOutErrors += $allCheckOuts | Where-Object User -EQ $user
        }  
    }

    If($connectivityErrors)
    {
        $emailConnectivityErrors = "TFS-Support@mathematica-mpr.com"
        $supEmailConnectivityErrors = ""
        $csvConnectivityErrors = "C:\TFS\_ConnectivityErrors.csv"

        # Create a csv containing the team project collections that could not be connected to
        $connectivityErrors | Sort-Object TeamProjectCollection | Export-Csv $csvConnectivityErrors -NoTypeInformation

        $objConnectivityErrors = New-Object -TypeName PSObject -Property @{Email=$emailConnectivityErrors; SupEmail=$supEmailConnectivityErrors; CSV=$csvConnectivityErrors}
        $notificationRecipients += $objConnectivityErrors 
    }

    If($checkOutErrors)
    {
        $emailCheckOutErrors = "TFS-Support@mathematica-mpr.com"
        $supEmailCheckOutErrors = ""
        $csvCheckOutErrors = "C:\TFS\_CheckOutErrors.csv"
            
        # Create a csv containing checkout data for users that couldn't be found in Active Directory; this will be sent to TFS Support.
        $checkOutErrors | Sort-Object User, TeamProjectCollection, CreationDate | Select-Object Domain, User, TeamProjectCollection, Computer, Workspace, ServerItem, LocalItem, ChangeTypeName, @{Name="CheckOutDate";Expression={Get-Date $_.CreationDate -Format d}} | Export-Csv $csvCheckOutErrors -NoTypeInformation   

        $objCheckOutErrors = New-Object -TypeName PSObject -Property @{Email=$emailCheckOutErrors; SupEmail=$supEmailCheckOutErrors; CSV=$csvCheckOutErrors}
        $notificationRecipients += $objCheckOutErrors       
    }  

    Return $notificationRecipients
}

=======
﻿Import-Module ActiveDirectory

[System.Reflection.Assembly]::Load("Microsoft.TeamFoundation.Client, Version=11.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
[System.Reflection.Assembly]::Load("Microsoft.TeamFoundation.VersionControl.Client, Version=11.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

Function Get-NotificationRecipients([int]$x = 7)
{
    $uri = "http://tfs.mathematica.net:8080/tfs"
    $configServer = [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($uri)
    $tpcNodes = $configServer.CatalogNode.QueryChildren([guid[]][Microsoft.TeamFoundation.Framework.Common.CatalogResourceTypes]::ProjectCollection, $false, [Microsoft.TeamFoundation.Framework.Common.CatalogQueryOptions]::None)
    
    $allCheckOuts = @()
    $connectivityErrors = @()

    # Loop through the Team Project Collections
    $tpcNodes | ForEach-Object -Process {
        
        $tpcGuid = $_.Resource.Properties["InstanceID"]
        $tpcName = $_.Resource.DisplayName
        
        Try
        {
            $versionControlServer = $configServer.GetTeamProjectCollection($tpcGuid).GetService([Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer])
            [string[]]$i = "$/" # Start at root, will recurse        
        
            # get all of the checkouts x days old or older and add them to the collection
            $allCheckOuts += $versionControlServer.GetPendingSets($i, [Microsoft.TeamFoundation.VersionControl.Client.RecursionType]::Full) | Select-Object @{Name="Domain";Expression={$_.OwnerName.Substring(0, $_.OwnerName.IndexOf("\"))}}, @{Name="User";Expression={$_.OwnerName.Remove(0, $_.OwnerName.IndexOf("\") + 1)}}, @{Name="TeamProjectCollection";Expression={$tpcName}}, @{Name="Computer";Expression={$_.Computer}}, @{Name="Workspace";Expression={$_.Name}} -ExpandProperty PendingChanges | Where-Object CreationDate -LE (Get-Date).AddDays(-$x)
        }

        Catch
        {
            $obj = New-Object -TypeName PSObject -Property @{TeamProjectCollection=$tpcName}
            $connectivityErrors += $obj
        }
    }

    # Get a distinct list of users with checkouts
    $allUsers = $allCheckOuts | Select-Object Domain, User | Sort-Object Domain, User | Get-Unique -AsString

    $notificationRecipients = @()
    $checkOutErrors = @()

    # Loop through the distinct list of users
    $allUsers | ForEach-Object -Process {
        
        $user = $_.User
        $domain = $_.Domain      

        Try
        {
            $adUser = Get-ADUser $user -Server $domain -Properties EmailAddress, Manager
            $csv = "C:\TFS\" + $user + ".csv"

            # Create a csv containing checkout data for each user
            $allCheckOuts | Where-Object User -EQ $user | Sort-Object TeamProjectCollection, CreationDate | Select-Object Domain, User, TeamProjectCollection, Computer, Workspace, ServerItem, LocalItem, ChangeTypeName, @{Name="CheckOutDate";Expression={Get-Date $_.CreationDate -Format d}} | Export-Csv $csv -NoTypeInformation

            $objNormal = New-Object -TypeName PSObject -Property @{Email=$adUser.EmailAddress; SupEmail=(Get-ADUser $adUser.Manager -Properties EmailAddress).EmailAddress; CSV=$csv}           
            $notificationRecipients += $objNormal
        }
        
        Catch
        {            
            $checkOutErrors += $allCheckOuts | Where-Object User -EQ $user
        }  
    }

    If($connectivityErrors)
    {
        $emailConnectivityErrors = "TFS-Support@mathematica-mpr.com"
        $supEmailConnectivityErrors = ""
        $csvConnectivityErrors = "C:\TFS\_ConnectivityErrors.csv"

        # Create a csv containing the team project collections that could not be connected to
        $connectivityErrors | Sort-Object TeamProjectCollection | Export-Csv $csvConnectivityErrors -NoTypeInformation

        $objConnectivityErrors = New-Object -TypeName PSObject -Property @{Email=$emailConnectivityErrors; SupEmail=$supEmailConnectivityErrors; CSV=$csvConnectivityErrors}
        $notificationRecipients += $objConnectivityErrors 
    }

    If($checkOutErrors)
    {
        $emailCheckOutErrors = "TFS-Support@mathematica-mpr.com"
        $supEmailCheckOutErrors = ""
        $csvCheckOutErrors = "C:\TFS\_CheckOutErrors.csv"
            
        # Create a csv containing checkout data for users that couldn't be found in Active Directory; this will be sent to TFS Support.
        $checkOutErrors | Sort-Object User, TeamProjectCollection, CreationDate | Select-Object Domain, User, TeamProjectCollection, Computer, Workspace, ServerItem, LocalItem, ChangeTypeName, @{Name="CheckOutDate";Expression={Get-Date $_.CreationDate -Format d}} | Export-Csv $csvCheckOutErrors -NoTypeInformation   

        $objCheckOutErrors = New-Object -TypeName PSObject -Property @{Email=$emailCheckOutErrors; SupEmail=$supEmailCheckOutErrors; CSV=$csvCheckOutErrors}
        $notificationRecipients += $objCheckOutErrors       
    }  

    Return $notificationRecipients
}

>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
Get-NotificationRecipients