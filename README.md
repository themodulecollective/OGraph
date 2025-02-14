# OGraph
### The Other Graph Module
PowerShell functions for administration of Microsoft 365 services using Graph endpoints.

# Intro
With the looming deprecation of the Azure AD and MSOL Powershell modules some functionality is not readily available or straightforward to achieve using the Microsoft.Graph modules. This module is part of the ongoing process of providing solutions to common tasks within Graph or adding functionality that doesn't currently exist in Microsoft.Graph Powershell SDK. It's intended as a companion module to Microsoft.Graph and relies on it for authentication.

For example, Invoke-MgGraphRequest offers a better experience than Invoke-Restmethod when making the API call. And Connect-MGgraph is great if you already have a token or can use your credentials to authenticate. Connect-OGGraph allows a users to get a new token from an Azure AD application using your access secret or certificate thumbprint and then run the Get-MgGraph function with that token. The example below gets a new token from the application and authenticates to Graph within the same function.

``` Powershell
Connect-OGGraph -ApplicationID f3857fc2-d4a5-1427-8f4c-2bdcd0cd9a2d -TenantID 27f1409e-4f28-4115-8ef5-71058ab01821 -AccessSecret Rb4324~JBiAJclWeG1W239CPgKHlChi9l0423jjdg~

Welcome To Microsoft Graph!
```

Another example of added functionality is Get-GroupLicenseReport. Currently, there is no clean method to programmatically get a human-readable list of Skus and enabled service plans from a licensing group. This function provides that report by getting Skus used in a tenant and comparing them to the guids provided by the Groups assignedLicenses endpoint.

``` Powershell
Get-OGGroupLicenseReport -GroupId a215dd48-4e3a-46bf-bb63-8f93a9fcaecc -IncludeDisplayName

groupDisplayName              : LicensingTest
type                          : ServicePlanPerSku
skuProductDisplayName         : Microsoft Flow Free
skuName                       : FLOW_FREE
skuId                         : f30db892-07e9-47e9-837c-80727f46fd3d
skuPrepaidUnits               : @{enabled=10000; suspended=0; warning=0}
skuPrepaidUnitsEnabled        : 10000
skuConsumedUnits              : 5
skuNonConsumedUnits           : 9995
skuAppliesTo                  : User
servicePlanProductDisplayName : EXCHANGE FOUNDATION
servicePlanName               : EXCHANGE_S_FOUNDATION
servicePlanId                 : 113feb6c-3fe4-4440-bddc-54d774bf0318
servicePlanProvisioningStatus : Success
servicePlanAppliesTo          : Company
servicePlanIsEnabled          : True

groupId                       : a215dd48-4e3a-46bf-bb63-8f93a9fcaecc
groupDisplayName              : LicensingTest
type                          : ServicePlanPerSku
skuProductDisplayName         : Microsoft Flow Free
skuName                       : FLOW_FREE
skuId                         : f30db892-07e9-47e9-837c-80727f46fd3d
skuPrepaidUnits               : @{enabled=10000; suspended=0; warning=0}
skuPrepaidUnitsEnabled        : 10000
skuConsumedUnits              : 5
skuNonConsumedUnits           : 9995
skuAppliesTo                  : User
servicePlanProductDisplayName : Common Data Service - VIRAL
servicePlanName               : DYN365_CDS_VIRAL
servicePlanId                 : 17ab22cd-a0b3-4536-910a-cb6eb12696c0
servicePlanProvisioningStatus : Success
servicePlanAppliesTo          : User
servicePlanIsEnabled          : True

groupId                       : a215dd48-4e3a-46bf-bb63-8f93a9fcaecc
groupDisplayName              : LicensingTest
type                          : ServicePlanPerSku
skuProductDisplayName         : Microsoft Flow Free
skuName                       : FLOW_FREE
skuId                         : f30db892-07e9-47e9-837c-80727f46fd3d
skuPrepaidUnits               : @{enabled=10000; suspended=0; warning=0}
skuPrepaidUnitsEnabled        : 10000
skuConsumedUnits              : 5
skuNonConsumedUnits           : 9995
skuAppliesTo                  : User
servicePlanProductDisplayName : Flow Free
servicePlanName               : FLOW_P2_VIRAL
servicePlanId                 : 50e68c76-46c6-4674-81f9-75456511b170
servicePlanProvisioningStatus : Success
servicePlanAppliesTo          : User
servicePlanIsEnabled          : False
```

# Getting Started

Install the module using:

``` Powershell
Install-Module OGraph
```

Import the module using:

``` Powershell
Import-Module OGraph
```

Next get connected. If you are using a Azure AD application for your graph permission, you can use a Certificate Thumbprint or Access Secret to generate a new token and authenticate:

``` Powershell
Connect-OGGraph -ApplicationID [App ID] -TenantID [Tenant ID] -AccessSecret [Access secret]
```

To use your Azure AD credentials:

``` Powershell
Connect-OGGraph -Online
```

This module uses Graph API v1.0 by default. Run this command to switch between versions:

``` Powershell
Set-OGVersion -beta
```

# Creating an AzureAD application

In order to use endpoints that require application-only permission or to restrict application permission scope within your tenant, you may want to create a custom AzureAD application. Follow these high-level steps to create one:
1. Navigate to your AureAD Home and click App Registrations or follow this link:
   https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps
2. Click new registration in the main pane above 'All Registrations' and complete the form in the method appropriate to your needs
3. Once the registration completes, and you are redirected to your apps 'Essentials' area, note the Application ID and the Tenant ID because you will need them to authenticate in PowerShell later.

Now you need to add the appropriate permissions for the Module functions you intend to use. For example, if you would like to use the Group licensing report functions, then you need to add permissions for the group Graph API endpoints.

4. Click 'API Permissions' in the navigation column to the left of the blade
5. Click 'Add a permission' in the main panel
6. Near the top of the Request API Permission pop out, you should see Microsoft Graph. Click the Microsoft Graph button.
7. Next, select Application Permissions

This screen allows you to search and select from all of the available Graph API permission. To get the group license report, we need two permission:

    - Organization.Read.All
    - Group.Read.All

8. Search for and select the two permissions, then click the 'Add Permissions' button at the bottom of the popout

For the permissions you've added to work, admin consent needs to be granted for each new permission. If you are an admin with sufficient privileges, you can click the 'Grant admin consent for [Tenant Name]' button at the top. If you aren't an admin, you will need to work with one to grant your application permissions.

9. Click the 'Grant admin consent for [Tenant Name]'

Now you have an application with permission granted. Only one other step is needed to use your application to authenticate your module.

10. Click 'Certificates & secrets' in the navigation column to the left of the blade
11. Click the 'New Client Secret' button
12. In the popout, select the expiration date for the secret and click 'Add' at the bottom
13. Copy the 'Value' of your new secret to a secure location for later use. Once this page refreshes, you will no longer be able to access the value

Now you have done the minimum requirements to create an app registration with permissions in Graph and get an access secret. You can successfully run:

``` Powershell
Connect-OGGraph -TenantId [Tenant ID Guid] -ApplicationID [Application ID Guid] -AccessSecret [Access Secret Value]
Get-OGGroupLicenseReport -All -IncludeDisplayName
```
