
[xml]$x=get-content C:\ffan\testsuites.xml

#to get the objects list which is wanted to edit 
$n1 = $x.GetElementsByTagName('testcase')



for($i=0;$i -lt $n1.count;$i++)

{
    #create Element 'custom_fields'
    $fields = $x.CreateElement('custom_fields')
     
    #create Element 'custom_field'
    $field = $x.CreateElement('custom_field')

    #create Element 'name'
    $name = $x.CreateElement('name')

    #create Element 'value'
    $value = $x.CreateElement('value')

    #get the object wanted to edit
    $item = $n1.item($i)
    $item

    switch($item.importance.InnerText)
    {
        3 {$Priority='High';break}
        2 {$Priority='Normal';break}
        1 {$Priority='Low';break}
    }
    
    #add elements to specified object
    $item.AppendChild($fields)
    $fields.AppendChild($field)
    $field.AppendChild($name)
    $field.AppendChild($value)
    #set value to each element
    $name.InnerText = 'Priority'
    $value.InnerText = "$Priority"
 }
 
 
 $x.save('c:\re\re1.xml')
 
