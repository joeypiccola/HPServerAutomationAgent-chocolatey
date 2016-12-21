#HP Server Automation Chocolatey Package

This is a Chocolatey package to install and uninstall the HP Server Automation Agent (HPSA).

###Install
The install is standard with the exception of a custom switch in place to detect the local system hostname which will then determine what gateway will be used for the install. 

###Uninstall
The uninstall piece mimics what the original agent_unintall.bat script did in three steps. First, python is run to remove the agent service (this happens via chocolateybeforemodify.ps1). Second, the regular chocolateyinstall.ps1 script is run which detects the uninstall string (msi) and then uninstalls the agent (as in add remove programs). Third, a two pass delete process is run to clean up c:\program files. 