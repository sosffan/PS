$filepath = 'c:\0\2a.xml'
$saveto = 'c:\0\2a.txt'

[xml]$x = get-content $filepath
$x.testsuite.testsuite.testcase | select name,internalid | fl * > $saveto