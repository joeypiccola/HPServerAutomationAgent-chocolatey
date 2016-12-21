$ErrorActionPreference = 'Stop'
$packageName = 'HPServerAutomationAgent'
$softwareName = 'HP SA Agent'
$installerType = 'MSI' 
$silentArgs = '/qn REMOVE_MSI_ONLY=1 FORCE=1'
$validExitCodes = @(0, 3010, 1605, 1614, 1641)

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1)
{
    $key | % { 
        $file = "$($_.UninstallString)"  
        if ($installerType -eq 'MSI') {
            $silentArgs = "$($_.PSChildName) $silentArgs"
            $file = ''
        }
        
        Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs "$silentArgs" -ValidExitCodes $validExitCodes -File "$file"
        
        write-host "Sleeping 30 seconds before cleaning up files"
        sleep -seconds 30
        # clean up after the python and msi Uninstaller
        # this is sloppy but mocks what the original agent_uninstall.bat
        Get-ChildItem -Path 'C:\Program Files\Opsware\agent' -Include * -File -Recurse | foreach { $_.Delete()}
        Remove-Item -Recurse -Path 'C:\Program Files\Opsware'
    }
}
elseif ($key.Count -eq 0)
{
    Write-Warning "$packageName has already been uninstalled by other means."
}
elseif ($key.Count -gt 1)
{
    Write-Warning "$key.Count matches found!"
    Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
    Write-Warning "Please alert package maintainer the following keys were matched:"
    $key | % {Write-Warning "- $_.DisplayName"}
}