
#exefile.txt contains all executions' full name 
#get-children -path XXX -include *.exe* -exclude *2007* -r >> exefile.txt

$a = get-content c:\abc\exefile.txt
$result="`""+$a.getvalue(0)+"`""
for($i=1;$i -lt $a.length-1;$i++) { 
$result = $result +" `""+$a.getvalue($i)+"`""
}
$result >> c:\abc\files.txt


#cmd: appverif.exe -enable heaps locks handles -for "file path"