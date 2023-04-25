$ErrorActionPreference = "Stop"

# Configure IIS with authentication.
Import-Module IISAdministration
Start-IISCommitDelay
(Get-IISConfigSection -SectionPath 'system.webServer/security/authentication/windowsAuthentication').Attributes['enabled'].value = $true
(Get-IISConfigSection -SectionPath 'system.webServer/security/authentication/anonymousAuthentication').Attributes['enabled'].value = $false
(Get-IISServerManager).Sites[0].Applications[0].VirtualDirectories[0].PhysicalPath = 'C:\inetpub\wwwroot\app'
Stop-IISCommitDelay

Write-Output "IIS with authentication is ready."