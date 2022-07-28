$ErrorActionPreference = "Stop"

If (-not(Test-Path "C:\DeploymentStuff")){
    
    New-Item -Path "C:\DeploymentStuff" -ItemType "Directory"
}

If (-not(Test-Path "C:\DeploymentStuff\ScriptLog.log")){
    
    New-Item -Path "C:\DeploymentStuff\ScriptLog.log" -ItemType "File"
}

Add-Content -Value "********************************"      -Path "C:\DeploymentStuff\ScriptLog.log"
Add-Content -Value "Deployment Script Extension Log by G2" -Path "C:\DeploymentStuff\ScriptLog.log"
Add-Content -Value "********************************"      -Path "C:\DeploymentStuff\ScriptLog.log"



If (-not(Test-Path "C:\ProgramData\chocolatey\choco.exe")){

    Try{
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    Catch {

        Add-Content -Value "something did not work when trying to install Choco" -Path "C:\DeploymentStuff\ScriptLog.log"

        Exit 999
    }



}

Add-Content -Value "Choco Installed properly" -Path "C:\DeploymentStuff\ScriptLog.log"


choco install notepadplusplus -y 
choco install vlc -y
choco install 7zip.install -y
choco install fslogix -y

Add-Content -Value "Apps installed" -Path "C:\DeploymentStuff\ScriptLog.log"


 Try{
        New-Item -Path HKLM:\SOFTWARE\FSLogix\Profiles -Force
        New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "Enabled" -Value "1" -PropertyType "DWORD"
        New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "VHDLocations" -Value "\\zorgstorage1.file.core.windows.net\zorgshare1" -PropertyType "String"

    }
    Catch {

        Add-Content -Value "something did not work when trying to set FSLogix reg keys" -Path "C:\DeploymentStuff\ScriptLog.log"

        Exit 998
    }


Add-Content -Value "Reg keys installed" -Path "C:\DeploymentStuff\ScriptLog.log"

Add-Content -Value "Starting Windows Update" -Path "C:\DeploymentStuff\ScriptLog.log"


 Try{

        Install-PackageProvider NuGet -Force
        Set-PSRepository PSGallery -InstallationPolicy Trusted
        Install-Module PSWindowsUpdate -SkipPublisherCheck -Force -Confirm:$false
    }
    Catch {

        Add-Content -Value "something did not work when trying to install PSWindowsUpdate module" -Path "C:\DeploymentStuff\ScriptLog.log"

        Exit 998


    }



Get-WindowsUpdate -AcceptAll -Install -AutoReboot -RecurseCycle 3

Exit 0