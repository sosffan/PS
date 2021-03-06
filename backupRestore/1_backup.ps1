
#模拟取数据
function getSourcePath
{
    $sourcePath = Read-Host "input source data UNC path:"
    #判断path是否存在
    if(!(Test-Path $sourcePath))
    {
        $sourcePath = Read-Host "Path not found. input source data UNC path:"
    }
    return $sourcePath
}

#模拟获取Storage信息
function getStorageInfo
{
    $storageInfo = Read-Host "input folder path, that is used to store data:"
    #判断path是否存在
    if(!(Test-Path $storageInfo))
    {
        $storageInfo = Read-Host "Path not found. ipout folder path, that is used to store the data:"
    }
    return $storageInfo
}



function backupData($jobType)
{
    if ($jobType -eq 'F')
    {
        $jobTime >> $planInfoPath
        $index = Get-ChildItem -Path $sourcePath -Recurse
        $jobPath = $jobFolder
    }
    
    if($jobType -eq 'I')
    {
        $jobTime = (Get-Date).ticks
        $jobTime >> $planInfoPath
        $lastJobTime = (get-content $planInfoPath)[-2]
        $index = Get-ChildItem -Path $sourcePath -Recurse |  where{($_.lastwritetime).ticks -gt $lastJobTime}
        $jobPath = "$jobFolder\$jobTime"
    }
    
    
    $base = (Get-Item $sourcePath).PSParentPath.Substring(38).length
    
    
    if(!(Test-Path "$jobPath\Data"))
        {$dataPath = New-Item -path $jobPath -Name 'Data' -ItemType directory}
        
    else {$dataPath = "$jobPath\Data"}
    
    
    foreach($item in $index)
    {
        "Backing-up $item.fullname"
        $newURL = ($item.FullName).substring($base)

        if($item.PSIsContainer)
        {
            New-Item ("$dataPath\$newURL") -itemtype directory
            $newURL >> "$jobPath\FolderIndex.idx"
            
        }
        else
        {

            Copy-Item $item.fullname -Destination ("$dataPath\$newURL")
            $newURL >> "$jobPath\ItemIndex.idx"
        }
    }
    
}




function startBackupScript()
{
    $planName = Read-Host "Please input plan name"
    $sourcePath = getSourcePath
    $storageInfo = getStorageInfo
    $planInfoPath = $storageInfo + '\' + $planName
    $jobTime = (Get-Date).ticks
    $jobFolder = "$storageInfo\$jobTime"
    
    $runNow = Read-Host "Run job now? (Y/N)"
    if($runNow -eq 'Y')
    {
        backupData('F');
    }
    
    while($True)
    {
        $runIB = Read-Host "would you want to start IB?(Y/N)"
        if($runNow -eq 'Y')
        {
            backupData('I');
        }
        else {return}
    }
}

startBackupScript