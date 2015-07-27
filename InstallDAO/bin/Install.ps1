[xml]$InstallationInfo = get-content "./InstallationInfo.xml"
#Common Value
$CloudURL = $InstallationInfo.InstallationInformation.CommonValue.AzureCloudURL.value
$ManagerFilePath = $InstallationInfo.InstallationInformation.CommonValue.ManagerFilePath.value
$AgentFilePath = $InstallationInfo.InstallationInformation.CommonValue.AgentFilePath.value


#Default Value
$RemoteTempPath = 'c:\DAOInstallTemp'
$ControlDBPassphrase = 'demo12!@'
$ControlAFPath = './bin/AnswerFile/Control_AnswerFile.xml'
$MediaAFPath = './bin/AnswerFile/Media_AnswerFile.xml'
$AgentAFPath = './bin/AnswerFile/Agent_AnswerFile.xml'
$ReportAFPath = './bin/AnswerFile/Report_AnswerFile.xml'

#---------------
#SQL Azure Server Info
$SQLAzureServer = $InstallationInfo.InstallationInformation.ControlValue.SQLAzureServer.value
$SQLAzureUserName = $InstallationInfo.InstallationInformation.ControlValue.SQLAzureUserName.value
$SQLAzurePWD = $InstallationInfo.InstallationInformation.ControlValue.SQLAzurePassword.value

#--------------

#Install Control 
function CheckInstallControl {
#Control Value
$ControlServerHost = $InstallationInfo.InstallationInformation.ControlValue.ControlServerHost.value
$ControlServerUserName = '.\docaveonline'  
$ControlServerPWD = $InstallationInfo.InstallationInformation.ControlValue.ControlServerPassword.value 
$ControlDBName = $InstallationInfo.InstallationInformation.ControlValue.ControlDBName.value

#Edit control answerfile
[xml]$ControlAF = get-content $ControlAFPath
$ControlAF.ManagerUnattended.SetupData.ControlConfig.ControlDatabaseServer.Value = "$SQLAzureServer"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.ControlDatabaseName.Value = "$ControlDBName"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.ControlDatabaseUsername.Value = "$SQLAzureUserName"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.ControlDatabasePassword.Value = "$SQLAzurePWD"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.ControlDatabasePassphrase.Value = "$ControlDBPassphrase"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.AppPoolUserName.Value = "$ControlServerUserName"
$ControlAF.ManagerUnattended.SetupData.ControlConfig.AppPoolPassword.Value = "$ControlServerPWD"
$ControlAF.save("$ControlAFPath")
Check-ManagerEnvironment -TargetName $ControlServerHost -Username $ControlServerUserName -Password $ControlServerPWD -AnswerFilePath $ControlAFPath -RemoteTempPath $RemoteTempPath -CheckEnvironmentFilePath "$ManagerFilePath\docave.dat" -ProductType docave -ev controlerr
if($controlerr)
{
Write-Host "Check Environment failed. Cancel the DAO Control installation"
}
else { "start to Install Control"
InstallControl
}
}
function InstallControl {
Install-DAManager -TargetName $ControlServerHost -Username $ControlServerUserName -Password $ControlServerPWD  -AnswerFilePath $ControlAFPath -RemoteTempPath $RemoteTempPath -PackageFilesFolder $ManagerFilePath -ProductType docave
}

#----------------------------------------------------
#Install Report
function CheckInstallReport {
#Report Value
$ReportServerHost = $InstallationInfo.InstallationInformation.ReportValue.ReportServerHost.value
$ReportServerUserName = '.\docaveonline'
$ReportServerPWD = $InstallationInfo.InstallationInformation.ReportValue.ReportServerPassword.value
$ReportDBName = $InstallationInfo.InstallationInformation.ReportValue.ReportDBName.value
$AuditorDBName = $InstallationInfo.InstallationInformation.ReportValue.AuditorDBName.value

#Edit report answerfile
[xml]$ReportAF = Get-Content $ReportAFPath
$ReportAF.ManagerUnattended.SetupData.ReportConfig.ReportControlAddress.value = "$CloudURL"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.ReportDatabaseServer.value = "$SQLAzureServer"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.ReportDatabaseName.value = "$ReportDBName"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.ReportDatabaseUserName.value = "$SQLAzureUserName"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.ReportDatabasePassword.value = "$SQLAzurePWD"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.AuditorDatabaseServer.value = "$SQLAzureServer"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.AuditorDatabaseName.value = "$AuditorDBName"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.AuditorDatabaseUserName.value = "$SQLAzureUserName"
$ReportAF.ManagerUnattended.SetupData.ReportConfig.AuditorDatabasePassword.value = "$SQLAzurePWD"
$ReportAF.save("$ReportAFPath")

Check-ManagerEnvironment -TargetName $ReportServerHost -Username $ReportServerUserName -Password $ReportServerPWD -AnswerFilePath $ReportAFPath -RemoteTempPath $RemoteTempPath -CheckEnvironmentFilePath "$ManagerFilePath\docave.dat" -ProductType docave -ev reporterr
if($reporterr)
{
Write-Host "Check Environment failed. Cancel the DAO Report Installation"
}
else {"Start to Install Report"
InstallReport
}
}

Function InstallReport
{
Install-DAManager -TargetName $ReportServerHost -Username $ReportServerUserName -Password $ReportServerPWD -AnswerFilePath $ReportAFPath -RemoteTempPath $RemoteTempPath -PackageFilesFolder $ManagerFilePath -ProductType docave
}

#------------------------------------------------------

#Install Media
function CheckInstallMedia {
#Media Value
$MediaServerHost = $InstallationInfo.InstallationInformation.MediaValue.MediaServerHost.value
$MediaServerUserName = '.\docaveonline'
$MediaServerPWD = $InstallationInfo.InstallationInformation.MediaValue.MediaServerPassword.value
#Edit media answerfile
[xml]$MediaAF = get-content $MediaAFPath
$MediaAF.ManagerUnattended.SetupData.MediaConfig.MediaControlAddress.Value = "$CloudURL"
$MediaAF.save("$MediaAFPath")
Check-ManagerEnvironment -TargetName $MediaServerHost -Username $MediaServerUserName -Password $MediaServerPWD -AnswerFilePath $MediaAFPath -RemoteTempPath $RemoteTempPath -CheckEnvironmentFilePath "$ManagerFilePath\docave.dat" -ProductType docave -ev mediaerr
if($mediaerr)
{
Write-Host "Check Environment failed. Cancel the DAO Media installation"
}
else { "start to Install Media"
InstallMedia
}
}

function InstallMedia {
Install-DAManager -TargetName $MediaServerHost -Username $MediaServerUserName -Password $MediaServerPWD  -AnswerFilePath $MediaAFPath -RemoteTempPath $RemoteTempPath -PackageFilesFolder $ManagerFilePath -ProductType docave
}

#Install Agent
function CheckInstallAgent {
#Agent Value
$AgentServerHost = $InstallationInfo.InstallationInformation.AgentValue.AgentServerHost.value
$AgentServerUserName = '.\docaveonline'
$AgentServerPWD = $InstallationInfo.InstallationInformation.AgentValue.AgentServerPassword.value
#Edit agent answerfile
[xml]$AgentAF = get-content $AgentAFPath
$AgentAF.Unattended.SetupData.CommunicationConfig.ControlAddress.Value = "$CloudURL"
$AgentAF.Unattended.SetupData.AgentConfiguration.AgentAuthentication.ManagerPassphrase.Value = "$ControlDBPassphrase"
$AgentAF.Unattended.SetupData.AgentConfiguration.AgentAccount.Username.Value = "$AgentServerUserName"
$AgentAF.Unattended.SetupData.AgentConfiguration.AgentAccount.Password.Value = "$AgentServerPWD"
$AgentAF.save("$AgentAFPath")
Check-AgentEnvironment -TargetName $AgentServerHost  -Username $AgentServerUserName -Password $AgentServerPWD -AnswerFilePath $AgentAFPath -RemoteTempPath $RemoteTempPath -CheckEnvironmentFilePath "$AgentFilePath\docave.dat" -ProductType docave -ev agenterr
if($agenterr)
{
Write-Host "Check Environment failed. Cancel the DAO Media installation"
}
else { "start to Install Agent"
InstallAgent
}
}
function InstallAgent {
Install-DAAgent -TargetName $AgentServerHost -Username $AgentServerUserName -Password $AgentServerPWD -PackageFilesFolder $AgentFilePath -AnswerFilePath $AgentAFPath -RemoteTempPath $RemoteTempPath -ProductType docave
}

"Which DocAve Online Role(s) would you want to install? 
a-(Agent)
c-(Control)
m-(Media)
r-(Report)."
$DAORole = Read-Host "Role: " 
Switch -wildcard ($DAORole) {
"*c*" {CheckInstallControl;sleep(100)}
"*m*" {CheckInstallMedia}
"*a*" {CheckInstallAgent}
"*r*" {CheckInstallReport}
}


