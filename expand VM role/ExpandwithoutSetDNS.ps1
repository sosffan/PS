trap{
write-host "$error[0]"
break
}
$ErrorActionPreference = 'stop'
$DNSServer='192.168.0.4'
$DOMAIN='stgdao.net' 
$Role=hostname

#feature
Import-Module servermanager
function addDotNet {
    #if((get-windowsfeature net-framework).installed) {return}
    add-windowsfeature NET-Framework
    add-windowsfeature web-asp-net,web-net-ext,web-isapi-ext,web-isapi-filter,Web-Mgmt-Console,Web-Metabase,NET-Win-CFAC
    Write-Host "Installed Net Framework"
}
#IIS features
function addIIS {
    addDotNet
    #if((get-windowsfeature web-webserver).installed) {return}
    add-windowsfeature web-webserver
    #add-windowsfeature (sub-features)
    Write-Host "Installed IIS"
}

#update
$AUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$AUSettings.NotificationLevel = 1
$AUSettings.Save()
Write-Host "Changed Windows update"


#firewall
switch -wildcard ($Role)
{
    "*Control*" {$ruleName = 'DAControl'; $rulePort = '14000,14007'; addIIS; break;}
    "*Agent*" {$ruleName = 'DAAgent'; $rulePort = '14004,14007'; addDotNet; break;}
    "*Media*" {$ruleName = 'DAMedia'; $rulePort = '14001-14002,14007'; addDotNet; break;}
    default {Write-host 'The Computer name does not match '; $ruleName = 'DA'; $rulePort = '14000-14004,14007'; addIIS; break}
}
NetSH advfirewall firewall add rule name="$ruleName" dir=in action=allow protocol=tcp localport="$rulePort"
Write-Host "Changed the Firewall setting"

#Domain

if(Test-Connection -Quiet -ComputerName $DNSServer)
{
    if($DOMAINConnection = Test-Connection -Quiet -ComputerName $DOMAIN)
    {
        add-computer -DomainName $DOMAIN
        Write-Host "Add computer to domain $DOMAIN, Computer will Restart in 10 seconds"
        Sleep(10)
        Restart-computer
    }
}