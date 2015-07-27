[string]$a = get-content C:\0\1.xml
$a.Replace("<ol style='list-style-type:none'><li>","").replace("</li></ol>","") > c:\0\2.xml