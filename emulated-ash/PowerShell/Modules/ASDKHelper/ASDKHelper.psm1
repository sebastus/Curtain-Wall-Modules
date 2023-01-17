
function Install-Azcopy {
	Invoke-WebRequest -Uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile "$($env:USERPROFILE)\Downloads\azcopy.zip"
	Expand-Archive "$($env:USERPROFILE)\Downloads\azcopy.zip" -DestinationPath "$($env:USERPROFILE)\Downloads\azcopy\"
	Copy-Item "$($env:USERPROFILE)\Downloads\azcopy\azcopy_windows_amd64_10.*\azcopy.exe" "$($env:LOCALAPPDATA)\Microsoft\WindowsApps\"
	Unblock-File "$($env:LOCALAPPDATA)\Microsoft\WindowsApps\azcopy.exe"
	Remove-Item "$($env:USERPROFILE)\Downloads\azcopy.zip" -Force
	Remove-Item "$($env:USERPROFILE)\Downloads\azcopy\" -Recurse -Force
	& azcopy --version
}

function Install-Edge {
	Invoke-WebRequest -Uri 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0d5f98e6-819e-49ab-8dc3-e65d8f27815b/MicrosoftEdgeEnterpriseX64.msi' -OutFile "$($env:USERPROFILE)\Downloads\MicrosoftEdgeEnterpriseX64.msi"
	& msiexec /qn /i "$($env:USERPROFILE)\Downloads\MicrosoftEdgeEnterpriseX64.msi"
}

function Install-VSCode {
	Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64' -OutFile "$($env:USERPROFILE)\Downloads\vscode-win32-x64.exe"
	& "$($env:USERPROFILE)\Downloads\vscode-win32-x64.exe" /VERYSILENT
}

function Install-Tools {
	[CmdletBinding()]
	param()

	Install-Azcopy
	Install-Edge
	Install-VSCode
}

function Expand-SystemDisk {
	$partSize = Get-Volume -DriveLetter "$(($env:SystemDrive)[0])" | Get-PartitionSupportedSize
	Resize-Partition -DriveLetter "$(($env:SystemDrive)[0])" -Size $partSize.SizeMax
}

function Set-AdminAccountName {
	Get-LocalUser | Where-Object SID -like 'S-1-5-21-*-500' | Rename-LocalUser -NewName 'Administrator'
}

function Disable-InternetExplorerESC {
	$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
	$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
	Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
	Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
}

function Edit-BareMetalTest {
	$baremetalFilePath = "$env:SystemDrive:\CloudDeployment\Roles\PhysicalMachines\Tests\BareMetal.Tests.ps1"
	$baremetalFile = Get-Content -Path $baremetalFilePath
	$baremetalFile = $baremetalFile.Replace('$isVirtualizedDeployment = ($Parameters.OEMModel -eq ''Hyper-V'')', '$isVirtualizedDeployment = ($Parameters.OEMModel -eq ''Hyper-V'') -or $isOneNode') 
	Set-Content -Value $baremetalFile -Path $baremetalFilePath -Force
}

function Install-ASDKPackages {
	if (!(Test-Path -Path "$env:SystemDrive:\CloudDeployment\Setup\BootstrapAzureStackDeployment.ps1" -PathType Leaf)) {
		throw "The file $env:SystemDrive:\CloudDeployment\Setup\BootstrapAzureStackDeployment.ps1 does not exist."
	}

	Install-PackageProvider -Name NuGet -Force | Out-Null
	Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
	Push-Location "$env:SystemDrive\CloudDeployment\Setup"
	$NuGetManifestPath = "$env:SystemDrive\CloudDeployment\Setup\CloudBuilderNuGets.xml"
	$NugetStorePath = "$env:SystemDrive\CloudDeployment\NuGetStore"
	. .\BootstrapAzureStackDeployment.ps1 -NuGetManifestPath $NuGetManifestPath -NugetStorePath $NugetStorePath

	Edit-BareMetalTest
	Pop-Location
}

function Initialize-HostOS {
	[CmdletBinding()]
	param()

	Expand-SystemDisk

	$roleData = "$env:SystemDrive:\CloudDeployment\Configuration\Roles\Infrastructure\BareMetal\OneNodeRole.xml"
	if (!(Test-Path -Path $roleData -PathType Leaf)) {
		Install-ASDKPackages
	}

	Disable-InternetExplorerESC

	Set-AdminAccountName

	Restart-Computer
}

function Get-LatestImdsVersion {
	return (Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/versions' -Headers @{ Metadata = 'true' }).apiVersions | Sort-Object -Descending | Select-Object -First 1
}

function Get-KeyVault {
	# Get an access token for Azure Management API using the VM managed idenity
	$latestImdsVer = Get-LatestImdsVersion

	$instanceMetadata = (Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance?api-version=$($latestImdsVer)" -Headers @{ Metadata = 'true' }).compute

	$token = (Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=$($latestImdsVer)&resource=https%3A%2F%2Fmanagement.azure.com" -Headers @{ Metadata = 'true' }).access_token
	
	$keyVault = (Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$($instanceMetadata.subscriptionId)/resourceGroups/$($instanceMetadata.resourceGroupName)/resources?`$filter=resourceType eq 'Microsoft.KeyVault/vaults'&api-version=2022-05-01" -Headers @{Authorization = "Bearer $token" }).value | Select-Object -First 1

	return $keyVault.Name
}

function Get-KeyVaultSecret {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $SecretName
	)

	$KeyVaultName = Get-KeyVault

	# Get an access token for KeyVault using the VM managed idenity
	$latestImdsVer = Get-LatestImdsVersion
	$token = (Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=$($latestImdsVer)&resource=https%3A%2F%2Fvault.azure.net" -Headers @{ Metadata = 'true' }).access_token

	return ConvertTo-SecureString -AsPlainText -Force -String (Invoke-RestMethod -Uri "https://$($KeyVaultName).vault.azure.net/secrets/$($SecretName)?api-version=7.0" -Headers @{Authorization = "Bearer $token" }).value
}

function Get-StackCredentials {
	[CmdletBinding()]
	param ()

	$password = Get-KeyVaultSecret -SecretName 'AdminPassword'
	$creds = [PSCustomObject]@{
		LocalAdmin = New-Object -TypeName PSCredential -ArgumentList @('Administrator', $password)
		CloudAdmin = New-Object -TypeName PSCredential -ArgumentList @('AzureStack\CloudAdmin', $password)
		StackAdmin = New-Object -TypeName PSCredential -ArgumentList @('AzureStack\AzureStackAdmin', $password)
	}
	return $creds
}

function Get-NtpServer {
	[CmdletBinding()]
	param ()

	$latestImdsVer = (Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/versions' -Headers @{ Metadata = 'true' }).apiVersions | Sort-Object -Descending | Select-Object -First 1
	$location = (Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance?api-version=$($latestImdsVer)" -Headers @{ Metadata = 'true' }).compute.location

	$ntp = switch ($location) {
		northeurope { 'ie.pool.ntp.org' }
		westeurope { 'nl.pool.ntp.org' }
		uksouth { 'ntp1.npl.co.uk' }
		ukwest { 'ntp1.npl.co.uk' }
		default { 'pool.ntp.org' }
	}

	$ntpIP = (Resolve-DnsName -Name $ntp | Select-Object -First 1).IP4Address

	return $ntpIP
}

function Install-ASDK {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $AadTenant,

		[Parameter(Mandatory = $false)]
		[string] $NtpServer = $null
	)

	$creds = Get-StackCredentials
	if ($null -eq $NtpServer) {
		$NtpServer = Get-NtpServer
	}

	Set-Location "$env:SystemDrive:\CloudDeployment\Setup"
	.\InstallAzureStackPOC.ps1 -AdminPassword $creds.LocalAdmin.Password -InfraAzureDirectoryTenantName $AadTenant -DNSForwarder '168.63.129.16' -TimeServer $NtpServer
}
