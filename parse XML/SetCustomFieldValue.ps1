
[xml]$x=get-content C:\re\testsuiteswithKey.xml

$n1 = $x.GetElementsByTagName('testcase')



for($i=0;$i -lt $n1.count;$i++)
#foreach($i in 0..3)
{

    #get test case object
    $item = $n1.item($i)
    $item

    switch($item.importance.InnerText)
    {
        3 {$Priority='High';break}
        2 {$Priority='Normal';break}
        1 {$Priority='Low';break}
    }

    $value = $item.Custom_fields.custom_field.value
    $value.InnerText = "$Priority"
 }
 
 
 $x.save('c:\re\re1.xml')
 
