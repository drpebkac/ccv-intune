#https://www.inthecloud247.com/set-default-start-menu-with-microsoft-intune/
Set-ExecutionPolicy Bypass -Scope Process -Force
Import-StartLayout -LayoutPath "$PSScriptRoot\startlayout.xml" -MountPath $env:SystemDrive\