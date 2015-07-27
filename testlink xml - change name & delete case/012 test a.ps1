[string]$OriginalCase = get-content C:\0\1.xml
$OriginalCase.Replace("<ol style='list-style-type:none'><li>","").replace("</li></ol>","") > c:\0\RemovedZerg.xml



$RemovedZergPath = 'c:\0\RemovedZerg.xml'
$editednamePath = 'c:\0\editedname.xml'

[xml]$x = Get-Content "$RemovedZergPath"
$x.testsuite.testcase | foreach{$_.name = $_.name + " - " + $_.summary.innertext}
$x.save("$editednamePath")



$CaseViewPath = 'c:\0\CaseView.txt'

[xml]$x = get-content $editednamePath
$x.testsuite.testcase | select name,internalid | fl * > $CaseViewPath

