[xml]$x = get-content "d:\4.xml"

$c = Get-Content "D:\4 del.txt" |  where {$_ -match "internal"} | foreach {$_.Split(" : ") |select -last 1 }

for($i = 0 ; $i -lt $c.count ; $i++) {
	$d = $x.selectnodes("/testsuite/testcase") | where {$_.internalid -eq $c[$i]}
	$d.parentnode.removechild($d)
}

$x.save(d:\5.xml)