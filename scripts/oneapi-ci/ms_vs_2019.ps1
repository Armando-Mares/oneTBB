$PROXY_INTEL = "http://proxy-dmz.intel.com:912"
$PROXY_BYPASS = "localhost;127.0.0.1;*.intel.com"
[System.Environment]::SetEnvironmentVariable('PROXY', ${PROXY_INTEL})
[System.Environment]::SetEnvironmentVariable('SECURE_PROXY', ${PROXY_INTEL})
[System.Environment]::SetEnvironmentVariable('NO_PROXY', 'localhost,127.0.0.1,*.intel.com')
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

Set-ExecutionPolicy Bypass -Scope Process -Force

echo "Set System-wide proxies to ${PROXY_INTEL}"
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "${PROXY_INTEL}"
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1

echo "Show system-wide proxies"
Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object ProxyServer, ProxyEnable

$VS_VERSION = 2019
$VS_RELEASE = 16
$VS_MPC = 09262
$VS_INSTALLER = "vs_Professional_${VS_VERSION}.exe"
$VS_PRODUCTKEY = "PRODUCT_KEY_HERE" # Replace with your actual product key
$VS_INSTALL_DIR = "C:\Program Files (x86)\Microsoft Visual Studio\${VS_VERSION}\Professional"
$VS_INSTALLER_SYSTEM = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe"

if (!( Test-Path "$VS_INSTALLER"))
{
    echo "Download Visual Studio ${VS_VERSION}"
    echo "From: [ https://aka.ms/vs/${VS_RELEASE}/release/vs_Professional.exe ]"
    $WebClient = New-Object System.Net.WebClient
    $WebProxy = New-Object System.Net.WebProxy("http://proxy-dmz.intel.com:912", $true)
    $WebProxy.BypassList = $PROXY_BYPASS
    $WebClient.Proxy = $WebProxy
    $WebClient.DownloadFile("https://aka.ms/vs/${VS_RELEASE}/release/vs_Professional.exe", "${VS_INSTALLER}")
    echo "Downloading completed!"
}

echo "Installing Visual Studio ${VS_VERSION}..."
echo "to ${VS_INSTALL_DIR}"

$exit_code = Start-Process "${VS_INSTALLER}" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "--quiet --wait --norestart --nocache --locale en-US",
"--installPath ""${VS_INSTALL_DIR}""",
"--add Microsoft.VisualStudio.Component.CoreEditor",
"--add Microsoft.VisualStudio.Workload.CoreEditor",
"--add Microsoft.VisualStudio.Component.Azure.Waverton.BuildTools",
"--add Microsoft.Component.MSBuild",
"--add Microsoft.VisualStudio.Component.Static.Analysis.Tools",
"--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices",
"--add Microsoft.VisualStudio.Component.PortableLibrary",
"--add Microsoft.Net.Component.4.7.2.SDK",
"--add Microsoft.Net.Component.4.7.2.TargetingPack",
"--add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites",
"--add Microsoft.Component.ClickOnce",
"--add Microsoft.VisualStudio.Component.TextTemplating",
"--add Microsoft.Net.Component.4.5.TargetingPack",
"--add Microsoft.Net.Component.4.6.TargetingPack",
"--add Microsoft.VisualStudio.Component.DiagnosticTools",
"--add Microsoft.VisualStudio.Component.Debugger.JustInTime",
"--add Microsoft.VisualStudio.Component.NuGet",
"--add Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions",
"--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core",
"--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
"--add Microsoft.VisualStudio.Component.VC.CMake.Project",
"--add Microsoft.VisualStudio.Component.Windows81SDK",
"--add Microsoft.VisualStudio.Workload.NativeDesktop",
"--add Microsoft.VisualStudio.Component.VSSDK",
"--add Microsoft.VisualStudio.ComponentGroup.VisualStudioExtension.Prerequisites",
"--add Microsoft.VisualStudio.Workload.VisualStudioExtension",
"--add Microsoft.VisualStudio.Component.Roslyn.Compiler",
"--add Microsoft.VisualStudio.Component.Roslyn.LanguageServices",
"--add Microsoft.VisualStudio.Workload.NativeCrossPlat",
"--add Microsoft.VisualStudio.Component.AspNet45",
"--add Microsoft.VisualStudio.Component.CoreBuildTools",
"--add Microsoft.VisualStudio.Component.Roslyn.Compiler",
"--add Microsoft.VisualStudio.Component.VC.Tools.ARM",
"--add Microsoft.VisualStudio.Component.VC.Tools.ARM64",
"--add Microsoft.VisualStudio.Component.VC.Tools.ARM64EC",
"--add Microsoft.VisualStudio.Component.VC.CoreIde",
"--add Microsoft.VisualStudio.Component.VC.ASAN",
"--add Microsoft.VisualStudio.Component.VC.14.20.ARM",
"--add Microsoft.VisualStudio.Component.VC.ATLMFC",
"--add Microsoft.VisualStudio.Component.Windows10SDK.18362",
"--productKey ${VS_PRODUCTKEY}"

echo "Finished installation Visual Studio ${VS_VERSION}"
echo "Exit code is ${exit_code.ExitCode}"

if (${exit_code.ExitCode} -ne 0)
{
    if (${exit_code.ExitCode} -eq 3010)
    {
        exit ${exit_code.ExitCode}
    }
}

#Start-Sleep -Seconds 5
#echo "Updating Visual Studio ${VS_VERSION}..."
#$exit_code = Start-Process "${VS_INSTALLER_SYSTEM}" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "repair --quiet --nocache --locale en-US",
#"--installPath ""${VS_INSTALL_DIR}"""

#Start-Sleep -Seconds 5
#echo "Updating Visual Studio ${VS_VERSION}..."
#$exit_code = Start-Process "${VS_INSTALLER_SYSTEM}" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "updateAll --quiet --nocache --locale en-US"

Start-Sleep -Seconds 5
echo "Forced activation"
$activation = Start-Process "${VS_INSTALL_DIR}\Common7\IDE\StorePID.exe" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "${VS_PRODUCTKEY} 09262"
Start-Sleep -Seconds 5
echo "Check call devenv.com"
$check = Start-Process "${VS_INSTALL_DIR}\Common7\IDE\devenv.com" -Wait -NoNewWindow -ArgumentList "/?"

echo "Disabling auto updates and notifications"
$disable_update_notify = Start-Process "${VS_INSTALL_DIR}\Common7\IDE\VsRegEdit.exe" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "set ""${VS_INSTALL_DIR}"" HKCU ExtensionManager AutomaticallyCheckForUpdates2Override dword 0"
$confirm_disable_update_notify = Start-Process "${VS_INSTALL_DIR}\Common7\IDE\VsRegEdit.exe" -Wait -NoNewWindow -Verbose -PassThru -ArgumentList "read ""${VS_INSTALL_DIR}"" HKCU ExtensionManager AutomaticallyCheckForUpdates2Override dword"
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\VisualStudio\Setup' -Name "BackgroundDownloadDisabled" -Type DWord -Value 1 -Verbose

setx VS2019INSTALLDIR "${VS_INSTALL_DIR}"
echo "Add to PATH var ${VS_INSTALL_DIR}"
setx PATH "$env:path;${VS_INSTALL_DIR}"

echo "Delete ${VS_INSTALLER}"
rm ${VS_INSTALLER}

echo "Call vswhere"
$check = Start-Process """C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe""" -Wait -NoNewWindow -Verbose -PassThru



exit ${exit_code.ExitCode}
