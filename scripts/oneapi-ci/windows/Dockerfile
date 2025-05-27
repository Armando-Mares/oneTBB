FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Setting default values for arguments
ARG PROXY=http://proxy-dmz.intel.com:912
ARG SECURE_PROXY=http://proxy-dmz.intel.com:912
ARG NO_PROXY=localhost,127.0.0.1,intel.com,.intel.com

# Setting Proxy
ENV http_proxy=$PROXY \
    https_proxy=$SECURE_PROXY \
    ftp_proxy=$SECURE_PROXY \
    no_proxy=$NO_PROXY \
    chocolateyProxyLocation=$PROXY
ARG USER=root

# Create TEMP directory
RUN mkdir C:\TEMP

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Copy necessary scripts
COPY set_proxy.ps1 C:/
COPY ms_vs_2019.ps1 C:/TEMP
COPY ms_vs_2017.ps1 C:/TEMP

# Run PowerShell script to set proxy
RUN ["powershell.exe", "-f", "c:/set_proxy.ps1"]

# Install Chocolatey
RUN curl -o C:\TEMP\choco_install.ps1 https://community.chocolatey.org/install.ps1
RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; C:\TEMP\choco_install.ps1
RUN choco feature enable -n allowGlobalConfirmation && \
    choco config set cacheLocation C:\Chococache

# System Registry Tweaks
RUN REG ADD "HKLM\Software\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
RUN REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f /reg:64
RUN REG ADD "HKLM\System\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f /reg:64
RUN ["powershell.exe", "-f", "c:/TEMP/ms_vs_2019.ps1"]
RUN ["powershell.exe", "-f", "c:/TEMP/ms_vs_2017.ps1"]

# Install CMake
RUN choco install cmake --version=3.27.3 --installargs 'ADD_CMAKE_TO_PATH=System'
RUN refreshenv

# Install additional software via Chocolatey
RUN choco install cygwin --params="/InstallDir:c:\cygwin64" && \
    choco install miniforge3 --params="'/AddToPath:1'" && \
    choco install tar --source=cygwin && \
    choco install git && \
    choco install 7zip && \
    choco install wget && \
    choco install strawberryperl && \
    choco install curl mingw openssh openssl tartool unzip

# Add Miniforge3 to PATH
RUN setx PATH "$env:path;C:\tools\miniforge3;C:\tools\miniforge3\Scripts;C:\tools\miniforge3\Library\bin"

# Set TEMP and TMP to C:\Temp
RUN rmdir /S /Q C:\TEMP && mkdir C:Temp
RUN powershell -Command \
    "[Environment]::SetEnvironmentVariable('TEMP', 'C:\Temp', [System.EnvironmentVariableTarget]::User); \
    [Environment]::SetEnvironmentVariable('TMP', 'C:\Temp', [System.EnvironmentVariableTarget]::User); \
    New-Item -ItemType Directory -Force -Path 'C:\Temp'"

# Refresh environment to pick up new PATH
RUN refreshenv

# Install Python 3.12, conda-build, and configure conda
RUN conda install -y python=3.12 conda-build && \
    echo conda-build:> %USERPROFILE%\.condarc && echo   pkg_format: 1 >> %USERPROFILE%\.condarc

# Set pip trusted hosts
RUN pip config set global.trusted-host "pypi.org files.pythonhosted.org pypi.python.org af-satgoneapi.devtools.intel.com"
RUN pip config list

# Clean up and verify installations
SHELL ["cmd", "/S", "/C"]
RUN refreshenv
RUN cmake --version && git --version && \
    curl -V && tar --help && 7z && unzip && wget --version && \
    conda --version && python --version && pip list && \
    openssl --version && systeminfo
RUN set
