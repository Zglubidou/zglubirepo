$ErrorActionPreference = "Stop"

Start-Sleep -Seconds 60

$Path = "C:\DeploymentStuff"
$LogFileName = "ScriptLog.log"
$ScriptFullPath = "$Path\$LogFileName"


If (-not(Test-Path $Path)){
    
    New-Item -Path $Path -ItemType "Directory" -Force
}

If (-not(Test-Path $ScriptFullPath)){
    
    New-Item -Path $ScriptFullPath -ItemType "File" -Force
}

Add-Content -Value "********************************"      -Path $ScriptFullPath
Add-Content -Value "Deployment Script Extension Log by G2" -Path $ScriptFullPath
Add-Content -Value "********************************"      -Path $ScriptFullPath


If (-not(Test-Path "C:\ProgramData\chocolatey\choco.exe")){

    Try{
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    Catch {

        Add-Content -Value "something did not work when trying to install Choco" -Path $ScriptFullPath

        Exit 999
    }



}

Add-Content -Value "Choco Installed properly" -Path $ScriptFullPath


choco install notepadplusplus -y 
choco install vlc -y
choco install 7zip.install -y
choco install fslogix -y
choco install microsoft-edge -y

Add-Content -Value "Apps installed" -Path $ScriptFullPath


 Try{
        New-Item -Path HKLM:\SOFTWARE\FSLogix\Profiles -Force
        New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "Enabled" -Value "1" -PropertyType "DWORD"
        New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "VHDLocations" -Value "\\zorgstorage1.file.core.windows.net\zorgshare1" -PropertyType "String"

    }
    Catch {

        Add-Content -Value "something did not work when trying to set FSLogix reg keys" -Path $ScriptFullPath

        Exit 998
    }


Add-Content -Value "Reg keys installed" -Path $ScriptFullPath

Add-Content -Value "Starting Windows Update" -Path $ScriptFullPath


 Try{

        Install-PackageProvider NuGet -Force
        Set-PSRepository PSGallery -InstallationPolicy Trusted
        Install-Module PSWindowsUpdate -SkipPublisherCheck -Force -Confirm:$false
    }
    Catch {

        Add-Content -Value "something did not work when trying to install PSWindowsUpdate module" -Path $ScriptFullPath

        Exit 998


    }



Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

Exit 0