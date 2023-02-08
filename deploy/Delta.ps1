if((Test-Path -Path deploysource)){
    Remove-Item -Path deploysource -Force -Recurse
}
[xml]$xml = Get-Content "manifest/package.xml"
[array]$packageTypes = $xml.package.types
$sourcepath='force-app/main/default/'
$sourcefile=''
$destinationpath='deploysource'

$csv = Import-Csv "deploy/sfdccomponentslist.csv"

## create deploySource folder
if(!(Test-Path -Path $destinationpath)){
    New-Item -ItemType directory -Path $destinationpath
}

foreach($packagetypename in $packageTypes){
    $foldername=$packagetypename.name

### Looping file members tag for respective folder based on xml
    foreach ($filename in $packagetypename.members){

        ###Loop over sf components csv list to find get folder for current file package file type.
        for($i=0; $i -le $csv.Rows.count; $i++){

            if($foldername -eq $csv.types[$i]){
                $sourcefile=$sourcepath+$csv.FolderName[$i]+'/'+$filename+'.'+'*'

                if($sourcefile.Length -gt 0){
                    $destinationpath_final=$destinationpath+'/'+$csv.FolderName[$i]
                    Write-Host $destinationpath_final
                    ###create a new folder in the destination
                    if(!(Test-Path -Path $destinationpath_final)){
                        Write-Host "Create Folder"
                        New-Item -itemType directory -Path $destinationpath_final
                    }
                    Copy-Item -path $sourcefile $destinationpath_final -Force -Recurse
                }
            }
        }
    }
}
Copy-Item -Path manifest\package.xml $destinationpath