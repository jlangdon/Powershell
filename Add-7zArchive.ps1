<<<<<<< HEAD
﻿ <#
.SYNOPSIS
 Add files to a 7zip archive

.DESCRIPTION
    Add files to a 7zip archive

    Note:  This function does not parse 7zip output
    Note:  IANA 7zip expert.  If you have any tips on important parameters, if my commands are inefficient, etc. please let me know!

.FUNCTIONALITY
    General Command

.PARAMETER archive
    Path to the archive file

.PARAMETER zipExe
    Path to 7z executable

.PARAMETER Type
    7Z or Zip.  Default = Zip

.PARAMETER compression
    compression level.  0 = no compression, 5 = normal compression, 9 = ultra.  Default: 5

.parameter path
    Path to file(s) to compress

.EXAMPLE
    #get all txt files in the root of C:\, return their fullname (their full path)
    $path = get-childitem C:\*.txt | select -ExpandProperty fullname

    Add-7zArchive -archive C:\test.zip -path $path -zipExe \\path\to\7z.exe

    This example gets a list of txt files to compress, adds them to C:\test.zip

.EXAMPLE
    #get all txt files in the root of C:\, return their fullname (their full path)
    $path = get-childitem C:\*.txt | select -ExpandProperty fullname

    foreach($file in $path){
        $fileDetails = get-item $file
        
        #remove extension
        $name = $fileDetails.name.replace($filedetails.extension,"")
        
        #add to a zip file with same name
        Add-7zArchive -archive C:\$name.zip -path $file -zipExe \\path\to\7z.exe

    }

    This example gets a list of txt files to compress
    For each file..
        It finds the filename without the extention
        It adds the file to a zip file with the same name

    I do something similar to this where the filename has a date and a description;  I remove the date string, and archive all files with the same name (but different dates) in one zip file.
#>	
[cmdletbinding()]
param(
    [validatescript( { test-path $(split-path $_ -Parent) } )]    
        $archive,

    [validatescript({
        $result = $true
        foreach($location in $_){
            if(-not (test-path $location)){
                $result = $false
            }
        }
        $result
    })]
        [string[]]$path,

    [validatescript({test-path $_})]
        $7zipExe,

    [validateset("7z","zip")]$type = "zip",
    
    [validateset(0, 1, 3, 5, 7, 9)]$compression = 5
)

#loop through files
foreach($file in $path){
    
    #define command
    $command = "$7zipExe a -mx$compression -t$type $archive $file"
    write-verbose $command
    
    #invoke the command
    invoke-expression -command $command
}l

#Add line
=======
﻿ <#
.SYNOPSIS
 Add files to a 7zip archive

.DESCRIPTION
    Add files to a 7zip archive

    Note:  This function does not parse 7zip output
    Note:  IANA 7zip expert.  If you have any tips on important parameters, if my commands are inefficient, etc. please let me know!

.FUNCTIONALITY
    General Command

.PARAMETER archive
    Path to the archive file

.PARAMETER zipExe
    Path to 7z executable

.PARAMETER Type
    7Z or Zip.  Default = Zip

.PARAMETER compression
    compression level.  0 = no compression, 5 = normal compression, 9 = ultra.  Default: 5

.parameter path
    Path to file(s) to compress

.EXAMPLE
    #get all txt files in the root of C:\, return their fullname (their full path)
    $path = get-childitem C:\*.txt | select -ExpandProperty fullname

    Add-7zArchive -archive C:\test.zip -path $path -zipExe \\path\to\7z.exe

    This example gets a list of txt files to compress, adds them to C:\test.zip

.EXAMPLE
    #get all txt files in the root of C:\, return their fullname (their full path)
    $path = get-childitem C:\*.txt | select -ExpandProperty fullname

    foreach($file in $path){
        $fileDetails = get-item $file
        
        #remove extension
        $name = $fileDetails.name.replace($filedetails.extension,"")
        
        #add to a zip file with same name
        Add-7zArchive -archive C:\$name.zip -path $file -zipExe \\path\to\7z.exe

    }

    This example gets a list of txt files to compress
    For each file..
        It finds the filename without the extention
        It adds the file to a zip file with the same name

    I do something similar to this where the filename has a date and a description;  I remove the date string, and archive all files with the same name (but different dates) in one zip file.
#>	
[cmdletbinding()]
param(
    [validatescript( { test-path $(split-path $_ -Parent) } )]    
        $archive,

    [validatescript({
        $result = $true
        foreach($location in $_){
            if(-not (test-path $location)){
                $result = $false
            }
        }
        $result
    })]
        [string[]]$path,

    [validatescript({test-path $_})]
        $7zipExe,

    [validateset("7z","zip")]$type = "zip",
    
    [validateset(0, 1, 3, 5, 7, 9)]$compression = 5
)

#loop through files
foreach($file in $path){
    
    #define command
    $command = "$7zipExe a -mx$compression -t$type $archive $file"
    write-verbose $command
    
    #invoke the command
    invoke-expression -command $command
}
>>>>>>> 34600a805d77d59da65af937a3bf051fd5c91708
