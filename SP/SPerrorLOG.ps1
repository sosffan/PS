$MESS=Read-host "Input the Correlation ID"
$date = get-date
"
______________________________________
$date" >>"./SharePointERRORLogs.txt
"
$LOG=get-splogevent|where{$_.correlation -eq $MESS}|where{$_.level -eq "critical"}|foreach-object{$_.message>>"./SharePointERRORLogs.txt"}


if($log -match "TaxonomyPicker.ascx failed")
{"
This is not causing any issues except for a wrong ULS log message a single time in a web application process life time, the exception is caught and that template file is skipped. This message should be treated as log noise and can be ignored.">>"./SharePointERRORLogs.txt"}

elseif($log -match "DocAve")
{"
Please check your DocAve status, to stop the DocAve service may fix this issue">>"./SharePointERRORLogs.txt"
}
#$a=ipconfig
#send-mailmessage -attachments "./SharePointERRORLogs.txt" -smtpserver "192.168.10.250" -subject "SPerrorLog" -to "ffan@avepoint.com" -body "$a" -from "ffan@avepoint.com"
invoke-item "./SharePointERRORLogs.txt"