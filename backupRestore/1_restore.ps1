
function getJob
{
    $n = 0
    foreach($job in $planInfo)
    {
        Write-Host " [$n] - $job"
        $n++
    }
}


function getIndex($indexType = 'folder')
{
    if($indexType -eq 'folder')
    {$indexName = 'FolderIndex.idx'}
    elseif($indexType -eq 'item')
    {$indexName = 'ItemIndex.idx'}
    else {Write-Host "index Type error: $indexType"}
    
    for([int]$i = $jobNo; $i -gt 0; $i--)
    {
        $IBjob = $planInfo[$i]
        $IBpath = "$FBpath\$IBjob"
        $index = Get-Content "$IBpath\$indexName"
        $indexResult = getUnion($indexResult,$index)
    }
    
    $index = Get-Content "$FBpath\$indexName"
    $indexResult = getUnion($indexResult, $index)
    return $indexResult
}


function getUnion($sets)
{
    $a = [array]$sets[0]
    $b = [array]$sets[1]
    foreach($record in $b)
    {
        if(!($a -contains $record))
        {
            $a = $a + $record
        }
    }
    return $a
}


function restoreFolderStructure
{
    foreach($folder in $nodes)
    {
        if($folder.contains($node))
        {
            $folderPath_des = "$destination\$folder"
            New-Item $folderPath_des -itemtype directory
        }
    }
}


function restore
{
    $indexName = 'ItemIndex.idx'
    for([int]$i = $jobNo; $i -gt 0; $i--)
    {
        $IBjob = $planInfo[$i]
        $IBpath = "$FBpath\$IBjob"

        $index = get-content "$IBpath\$indexName"
        foreach($record in $index)
        {
            if($record.startswith($node))
            {
                if(!($itemHasBeenRestored -contains $record))
                {
                    $itemPathInStorage = "$IBpath\Data\$record"
                    $itemPathInDestination = "$destination\$record"
                    Copy-Item $itemPathInStorage $itemPathInDestination
                    [array]$itemHasBeenRestored = $itemHasBeenRestored + $record
                }
            }
        }
    }

    $index = Get-Content "$FBpath\$indexName"
    foreach($record in $index)
    {
        if($record.startswith($node))
        {
            if(!($itemHasBeenRestored -contains $record))
            {
                $itemPathInStorage = "$FBpath\Data\$record"
                $itemPathInDestination = "$destination\$record"
                
                Copy-Item $itemPathInStorage $itemPathInDestination
                [array]$itemHasBeenRestored = $itemHasBeenRestored + $record
            }
        }
    }
    return $itemHasBeenRestored
}


#获取Storage信息
$storageInfo = Read-Host "where do you restore data(Storage Path): "

#获取Plan名, 并解析Plan信息
$planName = Read-Host "which plan do you want to use: "
$planInfo = get-content $storageInfo\$planName
$FBjob = $planInfo[0]
$FBpath = "$storageInfo\$FBjob"

#根据Plan信息, 列出所有Job
getJob

#获取Job记录
$jobNo = Read-Host "which job(input serial number): "

#展示此Job可以还原的节点信息(目前Folder Only)
$nodes = getIndex('folder')
$nodes

#选择要restore的节点
$node = Read-Host "which node would you like to restore: "

#选择要restore的位置(attach)
$destination = Read-Host "where to restore:"

#开始restore
restoreFolderStructure
restore