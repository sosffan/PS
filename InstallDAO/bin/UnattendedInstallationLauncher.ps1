$ver = $host | select version
if ($ver.Version.Major -gt 1)  {$Host.Runspace.ThreadOptions = "ReuseThread"}
$currentPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Import-Module $currentPath\UnattendedInstallation.dll -DisableNameChecking
&".\bin\Install.ps1"
Set-location $home

