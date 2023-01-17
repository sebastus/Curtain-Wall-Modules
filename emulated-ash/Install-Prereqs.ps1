Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Accounts -RequiredVersion 2.2.8
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Billing -RequiredVersion 0.11.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Compute -RequiredVersion 3.3.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.DataBoxEdge -RequiredVersion 1.1.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Dns -RequiredVersion 0.11.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.EventHub -RequiredVersion 1.4.3
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.IotHub -RequiredVersion 0.11.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.KeyVault -RequiredVersion 0.11.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Monitor -RequiredVersion 1.6.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Network -RequiredVersion 1.2.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Resources -RequiredVersion 0.12.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Storage -RequiredVersion 2.6.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Az.Websites -RequiredVersion 0.11.0

Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Backup.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Azurebridge.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Commerce.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Compute.Admin -RequiredVersion 1.1.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.ContainerRegistry.Admin -RequiredVersion 0.2.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.ContainerService.Admin -RequiredVersion 0.1.0
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Deployment.Admin -RequiredVersion 1.0.1
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Fabric.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Gallery.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.InfrastructureInsights.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Keyvault.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Network.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Storage.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Subscriptions -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Subscriptions.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Update.Admin -RequiredVersion 1.0.2
Install-Module -Repository 'PSGallery' -Scope AllUsers -Name Azs.Syndication.Admin -RequiredVersion 0.1.161
