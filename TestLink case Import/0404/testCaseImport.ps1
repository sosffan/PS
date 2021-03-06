#suite, subsuite, title, summary, priority, steps, result
#row1
#...
#ooo
#$excelpath = 'E:\111\book2.xlsx'
#$xmlpath = 'e:\111\testcaseFF.xml'
$excelpath = Read-Host "Enter the Excel file path "
$xmlpath = Read-Host "Enter the XML file path " 
$sheetorder = 1 # sheet order
$order = 0 # suite column number is $order+1; title is $order+3
$a = New-Object -com excel.application 
$b=$a.workbooks.open($excelpath)
$sheet1 = $a.sheets.item($sheetorder) #turn to sheet
$x = 1 #case number
$startime = get-date
$cells=$sheet1.Cells
"<?xml version=`"1.0`" encoding=`"UTF-8`"?>" | out-file -filepath $xmlpath -encoding utf8 # optionals
$suite = $cells.item(1,1).formula
"
Create Suite " + $suite
"<testsuite name=`"$suite`" ><node_order><![CDATA[1]]></node_order><details><![CDATA[]]></details>" | out-file -filepath $xmlpath -encoding utf8 -append 
for($i=2;$cells.item($i,$order+2).formula -ne 'ooo';$i++)  #check suite "ooo" to stop: to input test suite
{ 
    $subsuite = $cells.item($i,$order+2).formula
    if($subsuite -ne "")
    {	
	"	-Create Subsuite " + $subsuite
        "<testsuite name=`"$subsuite`" ><node_order><![CDATA[1]]></node_order><details><![CDATA[]]></details>" | out-file -filepath $xmlpath -encoding utf8 -append     
        do # do while: To input test Case
        {
            $casetitle = $cells.item($i,$order+3).Formula    
            $summary = $cells.item($i,$order+4).formula   
            $priority = $cells.item($i,$order+5).formula  
            $steps = $cells.item($i,$order+6).formula    
            $results = $cells.item($i,$order+7).formula
            $result = $results.Replace("`n","<br/>")		
            $step = $steps.Replace("`n","<br/>")
	    switch($priority){
	    high {$importance=3;break}
	    normal {$importance=2;break}
	    low {$importance=1;break}
	    }
            if($casetitle -ne "")  
            {     
                "		|-Case " + $x + ": "  + "`"" + $casetitle + "`" is adding..."      
                #$internalid = Get-Random -Maximum 500000 -Minimum 400000 # externalid internalid
                #$nodeid = 100+$i         #nodeorder
                "<testcase internalid=`"`" name=`"$casetitle`"><node_order><![CDATA[]]></node_order><externalid><![CDATA[]]></externalid><version><![CDATA[1]]></version>
                <summary><![CDATA[$summary]]></summary>
                <preconditions><![CDATA[$Preconditions]]></preconditions><execution_type><![CDATA[1]]></execution_type><importance><![CDATA[$importance]]></importance>
                <steps><step><step_number><![CDATA[1]]></step_number><actions><![CDATA[<p>$step</p>]]></actions><expectedresults><![CDATA[<p>$result</p>]]></expectedresults><execution_type><![CDATA[ 1]]></execution_type></step></steps>
                <custom_fields><custom_field><name><![CDATA[Priority]]></name><value><![CDATA[$priority]]></value></custom_field></custom_fields>
                </testcase>" | out-file -filepath $xmlpath -encoding utf8 -append
                $x++
            } # if case  
            $i++             
        } while($cells.item($i,$order+2).formula -eq '') # do while
        $i-- # do while will make $i added one more at the last circulate, use $i--  to make it correct
        "</testsuite>" | out-file -filepath $xmlpath -encoding utf8 -Append
    } # if suite   
} # for suite
"</testsuite>"| out-file -filepath $xmlpath -encoding utf8 -append 
$a.Quit()
$a = $null
"
ooo
"