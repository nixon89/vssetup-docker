# Copyright (C) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt in the project root for license information.

# Based on latest image cached by AppVeyor: https://www.appveyor.com/docs/build-environment/#image-updates
FROM microsoft/windowsservercore@sha256:c06b4bfaf634215ea194e6005450740f3a230b27c510cf8facab1e9c678f3a99
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV INSTALLER_VERSION=1.14.190.31519 \
    INSTALLER_URI=https://download.visualstudio.microsoft.com/download/pr/100516681/d68d54e233c956ff79799fdf63753c54/Microsoft.VisualStudio.Setup.Configuration.msi \
    INSTALLER_HASH=8917aa7b4116e574856d43e8e62862c1d6f25512be54917f2ef95f9cac103810

# Download and register the query API
RUN $ErrorActionPreference = 'Stop' ; \
    $VerbosePreference = 'Continue' ; \
    New-Item C:\TEMP -ItemType Directory -ea SilentlyContinue; \
    Invoke-WebRequest -Uri $env:INSTALLER_URI -OutFile C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi; \
    if ((Get-FileHash -Path C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi -Algorithm SHA256).Hash -ne $env:INSTALLER_HASH) { throw 'Download hash does not match' }; \
    Start-Process -Wait -PassThru -FilePath C:\Windows\System32\msiexec.exe -ArgumentList '/i C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi /qn /l*vx C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.log'

ENTRYPOINT ["powershell.exe", "-ExecutionPolicy", "Unrestricted"]
CMD ["-NoExit"]
