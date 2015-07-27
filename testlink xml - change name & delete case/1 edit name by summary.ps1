$filepath = 'c:\0\2.xml'
$saveto = 'c:\0\2a.xml'


[xml]$x = Get-Content "$filepath"

$x.testsuite.testcase | foreach{$_.name = $_.name + " - " + $_.summary.innertext}

$x.save("$saveto")