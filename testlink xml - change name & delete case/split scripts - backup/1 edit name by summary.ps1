$filepath = 'd:\a\sitelevel.xml'
$saveto = 'd:\a\site 1.xml'


[xml]$x = Get-Content "$filepath"

$x.testsuite.testcase | foreach{$_.name = $_.summary.innertext}

$x.save("$saveto")