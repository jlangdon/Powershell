<# The sample scripts are not supported under any Microsoft standard support 
 program or service. The sample scripts are provided AS IS without warranty  
 of any kind. Microsoft further disclaims all implied warranties including,  
 without limitation, any implied warranties of merchantability or of fitness for 
 a particular purpose. The entire risk arising out of the use or performance of  
 the sample scripts and documentation remains with you. In no event shall 
 Microsoft, its authors, or anyone else involved in the creation, production, or 
 delivery of the scripts be liable for any damages whatsoever (including, 
 without limitation, damages for loss of business profits, business interruption, 
 loss of business information, or other pecuniary loss) arising out of the use 
 of or inability to use the sample scripts or documentation, even if Microsoft 
 has been advised of the possibility of such damages 
#>

Function RebuildOrReorganizeIndexes
{
	PARAM
	(
		[Parameter(Mandatory=$true,Position=0)][String]$ServerName,
        [Parameter(Mandatory=$true,Position=1)][String]$DatabaseName
        
	)

	if($ServerName -and $DatabaseName)
	{  
        $SQLConnection = NewSQLConnection $ServerName $DatabaseName

        try{        
			    #Open database
				$SQLConnection.Open()
	             
                ## Get the version of the server
                #Get the instance name 
                if($ServerName = $env:COMPUTERNAME)
                {
                $InstanceName = "MSSQLSERVER"     
                }
                elseif(($ServerName -ne $env:COMPUTERNAME) -and ($ServerName.split("\")[0] -eq $env:COMPUTERNAME))
                {
                 $InstanceName = $ServerName.split("\")[1]     
                }

                #Get the build of the server
                $sn= (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$InstanceName
	            $version=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$sn\Setup").Version
                $Build=$version.Split(".")
                $Major=[int]$Build[0]
               
           
                if(($Major -eq 9 ) -or ($Major -eq 10 ) -or ($Major -eq 11 ) )
                {
	                #SQL query statement to get the result
                    $SQLQuery = "
                                DECLARE @Index sysname;
                                DECLARE @Table sysname;
                                DECLARE @Schema sysname;

                                DECLARE @cmd1 VARCHAR(500);
                                DECLARE @cmd2 VARCHAR(500);
                                DECLARE @IndexFrag float;

                                DECLARE @AllIndexTab TABLE(DBName nvarchar(128),SchemaName sysname, ObjectName sysname,IndexName sysname,IndexType nvarchar(60),IndexFragmentation float,PageCounts bigint);

                                ----Find all the indexes which are not heap in a table
                                INSERT @AllIndexTab
                                SELECT  DB_NAME(d.database_id) ,
		                                SCHEMA_NAME(o.schema_id),
		                                OBJECT_NAME(d.object_id),
		                                i.name,
		                                d.index_type_desc ,
		                                d.avg_fragmentation_in_percent,
		                                d.page_count 
                                FROM sys.dm_db_index_physical_stats(DB_ID(),null,null,null,NULL) d
                                INNER JOIN 
                                sys.indexes i
                                ON d.object_id = i.object_id AND d.index_id = i.index_id
                                JOIN sys.objects o
                                ON d.object_id = o.object_id 
                                WHERE d.index_id <> 0 AND d.page_count > 1000
                                ORDER BY d.avg_fragmentation_in_percent 

                                --Before rebuild or reorganize indexes, check the result of indexes in the database
                                SELECT * FROM @AllIndexTab

                                --Rebuild or reorganize the indexes
                                DECLARE IndexCursor CURSOR FOR
                                SELECT IndexName,SchemaName,ObjectName,IndexFragmentation
                                FROM @AllIndexTab
                                OPEN IndexCursor
                                FETCH NEXT FROM IndexCursor INTO @Index, @Schema,@Table,@IndexFrag
                                WHILE @@FETCH_STATUS = 0
	                                BEGIN
			                                IF @IndexFrag > 30
			                                BEGIN
				                                --Rebuild indexes with fragmentation great than 30
				                                SET @cmd1 = 'ALTER INDEX '+ @Index + ' ON [' +@Schema+'].['+ @Table+ '] REBUILD' ;
				                                EXEC (@cmd1) 
			                                END
			                                ELSE IF @IndexFrag BETWEEN 5 AND 30
			                                BEGIN 				
				                                --Reorganize indexes fragmentation between 5 and 30
				                                SET @cmd2='ALTER INDEX ' + @Index + ' ON [' + @Schema+'].['+ @Table + '] REORGANIZE';
				                                EXEC (@cmd2)
			                                END

		                                FETCH NEXT FROM IndexCursor INTO @Index, @Schema,@Table,@IndexFrag
	                                END
	
                                CLOSE IndexCursor
                                DEALLOCATE IndexCursor                             
                                "
                            
                    #Create SQLDataAdapter object with command text and connection
			        $SQLDataSet = New-Object System.Data.DataSet
			        $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($SQLQuery,$SQLConnection)
                                       
			        $SQLAdapter.Fill($SQLDataSet) | Out-Null
                  
                    #To show the result
                    Write-Host "--------------------------------------------------------------------------------"
                    Write-Host "Get index(es) in $DatabaseName whose page_count is(are) more than 1000 "
                    Write-Host "--------------------------------------------------------------------------------"
                    $SQLDataSet.Tables| Format-List


                }
                else 
                {
                Write-Host "The version of this instance $ServerName is not SQL Server 2005, SQL Server 2008 or SQL Server 2012!"
                }
                
            }
        catch 
		{
				Write-Error $_
		}
    }
}
	
        
Function GetChoice($message)
{
    $Win = New-Object System.Management.Automation.Host.ChoiceDescription "&Windows","Windows authentication"
    $SQL = New-Object System.Management.Automation.Host.ChoiceDescription "&SQL Server","SQL Server authentication"
    $Quit = New-Object System.Management.Automation.Host.ChoiceDescription "&Quit","Choose to quit"
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($Win,$SQL,$Quit)
    $caption = "Confirming"
    $result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
    $result
}
        
Function NewSQLConnection
{
	
    PARAM
	(
		[String]$ServerName,
        [String]$DatabaseName
        
	)
	   
	if($ServerName -and $DatabaseName)
	{
        $Choice = Getchoice("Select Windows or SQL Server authentication")
        
        ## Windows Authentication
        if($choice -eq 0)
        {
		    #Create SqlConnection object and define connection string
		    $Connection = New-Object System.Data.SqlClient.SqlConnection
		    $ConnectionB = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
		    $ConnectionB["Data Source"] = $ServerName
		    $ConnectionB["Database"] = $DatabaseName
		    $ConnectionB["Trusted_Connection"] = "SSPI"
		    $Connection.ConnectionString = $ConnectionB.ConnectionString
        }
  
        ## SQL Server Authentication 
        if($choice -eq 1)
        {

		    #Use Get-Credentical to get username and password and then create SQLConnection,define connection string        
            $credentical = Get-Credential
		    $userName = Invoke-Command -ScriptBlock {PARAM([string]$targetStr)
		    if($targetStr.ToCharArray()[0] -eq "\"){$targetStr.Substring(1,$targetStr.Length-1)}else{$targetStr}
					    } -ArgumentList $credentical.UserName
		    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(`
					    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($credentical.Password))
		    $Connection = New-Object System.Data.SqlClient.SqlConnection
		    $ConnectionB = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
		    $ConnectionB["Data Source"] = $ServerName
		    $ConnectionB["Database"] = $DatabaseName
		    $ConnectionB["User ID"] = $UserName
		    $ConnectionB["Password"] = $password
		    $Connection.ConnectionString = $ConnectionB.ConnectionString
		}		
		# Store SqlConnection object
		$Connection        
	}
}

RebuildOrReorganizeIndexes