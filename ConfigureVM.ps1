$ErrorActionPreference = "stop"

If (-not(Test-Path "C:\ProgramData\chocolatey\choco.exe")){

    Try{
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    Catch {

        Write-Host "something did not work"
        Exit 999
    }



}


choco install notepadplusplus -y
choco install vlc -y
choco install 7zip.install -y
choco install fslogix -y

New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "Enabled" -Value "1" -PropertyType "DWORD"
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name "VHDLocations" -Value "\\zorgstorage1.file.core.windows.net\zorgshare1" -PropertyType "DWORD"


Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module PSWindowsUpdate -SkipPublisherCheck -Force -Confirm:$false

Get-WindowsUpdate -AcceptAll -Install -ErrorAction Continue