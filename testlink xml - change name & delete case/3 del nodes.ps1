$filepath = 'c:\0\editedname.xml'
$deltxt = 'c:\0\CaseView.txt'
$saveto = 'c:\0\ZergCase.xml'
[xml]$x = get-content $filepath

$c = Get-Content $deltxt |  where {$_ -match "internal"} | foreach {$_.Split(" : ") |select -last 1 }

for($i = 0 ; $i -lt $c.count ; $i++) {
	$d = $x.selectnodes("/testsuite/testcase") | where {$_.internalid -eq $c[$i]}
	$d.parentnode.removechild($d)
}

$x.save($saveto)