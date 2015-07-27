[xml]$x = get-content d:\4.xml
$x.testsuite.testcase | select name,internalid | fl * > d:\4.txt