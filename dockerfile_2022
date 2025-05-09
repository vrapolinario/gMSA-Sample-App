FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022
WORKDIR /LogMonitor
COPY LogMonitorConfig.json .
RUN powershell.exe -command wget -uri https://github.com/microsoft/windows-container-tools/releases/download/v1.2.1/LogMonitor.exe -outfile LogMonitor.exe
# Add required Windows features, since they are not installed by default.
RUN powershell -command Install-WindowsFeature "Web-Windows-Auth", "Web-Asp-Net45"
# Create simple ASP.Net page.
RUN powershell -command New-Item -Force -ItemType Directory -Path 'C:\inetpub\wwwroot\app'
COPY default.aspx C:\\inetpub\\wwwroot\\app
COPY Run.ps1 /LogMonitor/
RUN PowerShell -ExecutionPolicy Unrestricted -command /LogMonitor/run.ps1
# Change the startup type of the IIS service from Automatic to Manual
RUN sc config w3svc start=demand
# Enable ETW logging for Default Web Site on IIS
RUN c:\windows\system32\inetsrv\appcmd.exe set config -section:system.applicationHost/sites /"[name='Default Web Site'].logFile.logTargetW3C:"File,ETW"" /commit:apphost
EXPOSE 80
# Start "C:\LogMonitor\LogMonitor.exe C:\ServiceMonitor.exe w3svc"
ENTRYPOINT ["C:\\LogMonitor\\LogMonitor.exe", "C:\\ServiceMonitor.exe", "w3svc"]