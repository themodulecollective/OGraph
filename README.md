# OGraph
### The Other Graph Module
PowerShell functions for administration of Microsoft 365 services using Graph endpoints.

# Intro
As a system administrator, I became increasingly frustrated with the reality that the Azure AD and MSOL Powershell modules were going away, but the Microsoft.Graph module was far from ready to replace even some basic funcitonalities without hassle. After looking into the Graph web API and its outputs, I realized in many cases it was potentially simpler to wrap a graph web API call in a function than it was to use the availible MG function for what ever task I was working on at the time.

This module is the ongoing process of providing simpler solutions to common tasks within Graph or adding functionality that doesn't currenlty exist in Microsoft.Graph Powershell SDK. Its intended as a companion module to Microsoft.Graph and in many ways relies on it.

For example, Invoke-GraphRequest offers a better experience than Invoke-Restmethod when making the API call. And Connect-MGgraph is great if you already have a token or can use your credentials to authenticate. But I created Connect-OGGraph to allow users to get a new token from an Azure AD application using your access secret or certificate thumbprint and then run the Get-MgGraph function with that token. The example below gets a new token from the application and authenticates to graph within the same function.

```
Connect-OGGraph -ApplicationID f3857fc2-d4a5-1427-8f4c-2bdcd0cd9a2d -TenantID 27f1409e-4f28-4115-8ef5-71058ab01821 -AccessSecret Rb4324~JBiAJclWeG1W239CPgKHlChi9l0423jjdg~

Welcome To Microsoft Graph!
```

Another example of added functionality is Get-GroupLicenseReport. Currenlty there is no clean method to programaticaly get a human readable list of Skus and enabled service plans from a licensing group. This function provides that report by getting Skus used in a tenant and comparing them to the guids provided by the Groups assignedLicenses endpoint.

```
Get-OGGroupLicenseReport -GroupId a215dd48-4e3a-46bf-bb63-8f93a9fcaecc

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

First, Import the module using:

```
Import-Module OGraph
```

Next get connected. If you are using a Azure AD application for your graph permission, you can use a Certificate Thumbprint or Access Secret to generate a new token and authenticate:

```
Connect-OGGraph -ApplicationID [App ID] -TenantID [Tenant ID] -AccessSecret [Access secret]
```

To use your Azure AD credentials:

```
Connect-OGGraph -Online
```

This module uses Graph API v1.0 by default. Run this command to switch between versions:

```
Set-OGVersion -beta
```
