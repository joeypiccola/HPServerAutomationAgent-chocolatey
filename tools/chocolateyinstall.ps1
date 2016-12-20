$ErrorActionPreference = 'Stop';

$packageName= 'HPServerAutomationAgent'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# gen the system location
$location =  ($env:computername).substring(0,3)
switch ($location)
{
  'DEN'
  {
    $gw = 'den.-.com'
  }
  'SEA'
  {
    $gw = 'sea.-.com'
  }
  Default
  {
    # this will simply cause the installer to fail as it cannot connect to fail.com:3001 (at least I hope).
    $gw = 'fail.com'
  }
}

Write-host "Settting OpsWare gateway to: `"$gw`""

$packageArgs = @{
  packageName    = $packageName
  url            = 'https://artifactory.-.com/artifactory/win-binaries/opsware-agent-45.0.47353.0-win32-6.3-X64.exe'
  checksum       = '0F6673A033CE50B77A30EBA28ED1A357169FC5C9F6E3152E76322D798260B894'
  checksumtype   = 'sha256' 
  fileType       = 'exe'
  silentArgs     = "--force_full_hw_reg --force_sw_reg --opsw_gw_addr $gw`:3001"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs