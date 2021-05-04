if((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled")
{
  Write-Host "Windows Linux Subsystem already enabled"
  Write-Host "No action taken"
  exit
  
}
else
{
  try
  {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    
  }
  catch [Exception]
  {
    Write-Host "Linux Subsystem will not be installed for unknown reasons.
    
  }
   
  
