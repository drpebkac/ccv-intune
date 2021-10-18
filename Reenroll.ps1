#All credit goes to https://www.maximerastello.com/manually-re-enroll-a-co-managed-or-hybrid-azure-ad-join-windows-10-pc-to-microsoft-intune-without-loosing-current-configuration/ for the concept
#The intention of this script is automate the method two of the link above.

#Task scheduler directory variables
$EnterpriseMgmtPath = "\Microsoft\Windows\EnterpriseMgmt\"
$IDWIldcard = "*-*-*-*-*"
$TaskDir = "$env:SystemRoot\System32\Tasks\$EnterpriseMgmtPath"

#Get array of MDM tasks
$MDMTasks = @((Get-ScheduledTask -TaskPath ("$EnterpriseMgmtPath" + "$IDWIldcard")).TaskName)

#Get array of MDM Enrollment ID folder in Task Scheduler
$MDMIDDir = @((Get-ChildItem -Path $TaskDir).Name)

foreach($Task in $MDMTasks)
{
  Unregister-ScheduledTask -TaskName $Task -TaskPath $EnterpriseMgmtPath -Confirm:$false

}

foreach($MDMID in $MDMIDDir)
{
  $DirectoryToDelete = "$TaskDir" + "$MDMID"
  $DirectoryCheckEmpty = Get-ChildItem -Path ("$TaskDir" + "$MDMID") | Measure-Object

  if($EmptyDirectoryCheck -eq "0")
  {
    try
    {
      Remove-Item -Recurse -Force $DirectoryToDelete

    }
    catch [Exception]
    {
      $Results = Test-Path -Path $DirectoryToDelete
      Write-Output "The task scheduler directory $DirectoryToDelete is $Results"

    }

  }
  else
  {
    Write-Output "$DirectoryToDelete is not empty and will not be deleted."
    Write-Output "Please delete manually then try again"
    exit

  }

}

$Key1 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Enrollments' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key2 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Enrollments\Status' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key3 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key4 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key5 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key6 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key7 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger' | Where { $_.Name -like "*-*-*-*-*" } ).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"
$Key8 = (Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions' | Where { $_.Name -like "*-*-*-*-*" }).Name -replace "HKEY_LOCAL_MACHINE","HKLM:"

#I'm sure there's a smarter way in doing this
$ArrayToAggregate = @($Key1,$Key2,$Key3,$Key4,$Key5,$Key6,$Key7,$Key8)
$KeysToDelete = @()
 
foreach($Array in $ArrayToAggregate)
{
  $KeysToDelete += $Array

}

foreach($Key in $KeysToDelete)
{
  try
  {
    Remove-Item -Recurse -Force $Key -Confirm:$false

  }
  catch [Exception]
  {
    Write-Output "$Key cannot be deleted. This will be overwriten by next reenrollment"

  }

}

