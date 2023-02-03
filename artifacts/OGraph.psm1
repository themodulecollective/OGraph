###############################################################################################
# Module Variables
###############################################################################################
$ModuleVariableNames = ('OGraphConfiguration','GraphVersion')
$ModuleVariableNames.ForEach( { Set-Variable -Scope Script -Name $_ -Value $null })
$Script:GraphVersion = 'v1.0'

###############################################################################################
# Module Removal
###############################################################################################
#Clean up objects that will exist in the Global Scope due to no fault of our own . . . like PSSessions

$OnRemoveScript = {
  # perform cleanup
  Write-Verbose -Message 'Removing Module Items from Global Scope'
}

$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript

<#
.SYNOPSIS
Add Group Member

.DESCRIPTION
Add a group member using its object id or user principal name. If using the later, a lookup is performed with get-oguser to get the Object ID for the user.

Permissions: https://learn.microsoft.com/en-us/graph/api/group-post-members?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER MemberId
Parameter description

.EXAMPLE
Add-OGGroupMember -GroupObjectId 3175b598-0fa0-4002-aebf-bfbf759c94a7 -UserObjectId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Add-OGGroupMember {
    [CmdletBinding(DefaultParameterSetName = 'MID')]

    param (
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $GroupId,
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $UserPrincipalName,
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        $MemberId
    )

    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $MemberId = Get-OGUser -UserPrincipalName $UserPrincipalName
            $MemberId = $MemberId.Id
        }
    }
    $URI = "/$GraphVersion/groups/$GroupID/members/`$ref"
    $Body = [PSCustomObject]@{
        '@odata.id' = "https://graph.microsoft.com/$GraphVersion/directoryObjects/$MemberId"
    }
    $account_params = @{
        Uri    = $URI
        Body   = $Body | ConvertTo-Json
        Method = 'POST'
    }
    Invoke-MgGraphRequest @Account_params
}
<#
.SYNOPSIS
Get API Token from Azure AD app using Access Secret or Certificate Thumprint, then authenticate to graph with the token. Or authenticate using user credentials.

.DESCRIPTION
This function allows easy Authentication to Azure AD application authentication tokens or User Credentials. To get a Azure AD application token, provide the tenant ID, Application ID, and either an access secret or certificate thumbprint. The token with automatically authenticate the session after a valid token is acquired or online credentials are entered. If you have an existing token, paste it into accesstoken.

.PARAMETER ApplicationID
Parameter description

.PARAMETER TenantId
Parameter description

.PARAMETER AccessSecret
Parameter description

.PARAMETER CertificateThumbprint
Parameter description

.PARAMETER Online
Parameter description

.PARAMETER Scope
Parameter description

.PARAMETER AccessToken
Parameter description

.EXAMPLE
Authenticate to graph with application access secret:
Connect-OGGraph -ApplicationID f3857fc2-d4a5-1427-8f4c-2bdcd0cd9a2d -TenantID 27f1409e-4f28-4115-8ef5-71058ab01821 -AccessSecret Rb4324~JBiAJclWeG1W239CPgKHlChi9l0423jjdg~

.NOTES
General notes
#>
Function Connect-OGGraph {
    [CmdletBinding(DefaultParameterSetName = 'Online')]
    param (
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $ApplicationID,
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $TenantId,
        [Parameter(Mandatory,
            Parametersetname = 'Secret')]
        $AccessSecret,
        [Parameter(Mandatory,
            Parametersetname = 'Cert')]
        $CertificateThumbprint,
        [Parameter(Mandatory,
            Parametersetname = 'Online')]
        [Switch]$Online,
        [Parameter(Parametersetname = 'Online')]
        [array]$Scope,
        [Parameter(Mandatory,
            Parametersetname = 'Token')]
        $AccessToken

    )
    switch ($PSCmdlet.ParameterSetName) {
        'Secret' {
            $Body = @{
                Grant_Type    = 'client_credentials'
                Scope         = 'https://graph.microsoft.com/.default'
                client_Id     = $ApplicationID
                Client_Secret = $AccessSecret
            }
            $ConnectGraph = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body $Body
            $script:GraphAPIKey = $ConnectGraph.access_token
            Connect-MgGraph -AccessToken $GraphAPIKey
        }
        'Cert' {
            $splat = @{
                ClientID              = $ApplicationID
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            Connect-MGGraph @splat
        }
        'Online' {
            if ($null -ne $scope) {
                Connect-MgGraph -Scopes $scope
            }
            else {
                Connect-MgGraph
            }
        }
        'Token' {
            Connect-MgGraph -AccessToken $AccessToken
        }
    }
}
<#
.SYNOPSIS
List Calendars for a user or specify a users calendar with the calendars guid.

.DESCRIPTION
List Calendars for a user or specify a users calendar with the calendars guid.

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-calendars?view=graph-rest-1.0&tabs=http

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER Id
Parameter description

.EXAMPLE
Get-OGCalendar -UserPrincipalName jdoe@contoso.com

.NOTES
General notes
#>
Function Get-OGCalendar {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName,
        [Parameter(Mandatory = $false)]$Id
    )
    if (-not [string]::IsNullOrWhiteSpace($id)) {
        $URI = "/$GraphVersion/users/$UserPrincipalName/calendars/$id"
        Get-OGNextPage -uri $URI
    }
    else {
        $URI = "/$GraphVersion/users/$UserPrincipalName/calendars"
        Get-OGNextPage -uri $URI
    }
}
<#
.SYNOPSIS
Get group from Azure AD
.DESCRIPTION
Get group using an Object ID, by searching for a displayname, or getting all groups.

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER SearchDisplayName
Parameter description

.PARAMETER All
Parameter description

.PARAMETER Property
Parameter description

.EXAMPLE
Get a group by Object ID
Get-OGGroup -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroup {
    [CmdletBinding(DefaultParameterSetName = 'OID')]
    param (
        [Parameter(ParameterSetName = 'OID')]
        $GroupId,
        [Parameter(ParameterSetName = 'Search')]$SearchDisplayName,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All,
        [Parameter()]
        [string[]]$Property
    )
    $includeAttributes = 'classification', 'createdByAppId', 'createdDateTime', 'deletedDateTime', 'description', 'displayName', 'expirationDateTime', 'groupTypes', 'id', 'infoCatalogs', 'isAssignableToRole', 'isManagementRestricted', 'mail', 'mailEnabled', 'mailNickname', 'membershipRule', 'membershipRuleProcessingState', 'onPremisesDomainName', 'onPremisesLastSyncDateTime', 'onPremisesNetBiosName', 'onPremisesProvisioningErrors', 'onPremisesSamAccountName', 'onPremisesSecurityIdentifier', 'onPremisesSyncEnabled', 'organizationId', 'preferredDataLocation', 'preferredLanguage', 'proxyAddresses', 'renewedDateTime', 'resourceBehaviorOptions', 'resourceProvisioningOptions', 'securityEnabled', 'securityIdentifier', 'theme', 'visibility', 'writebackConfiguration'
    $IncludeAttributeString = $($includeAttributes; $property) -join ','
    switch ($PSCmdlet.ParameterSetName) {
        'OID' {
            $URI = "/$GraphVersion/groups/$($GroupId)?`$select=$($IncludeAttributeString)"
            get-ognextpage -uri $uri
        }
        'Search' {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)`$search=`"displayName:$SearchDisplayName`""
            Get-OGNextPage -uri $URI -Filter
        }
        'All' {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
    }
}
<#
.SYNOPSIS
Get the license skus applied by a group

.DESCRIPTION
Gets the license skus applied by a group and any disabled service plans of those skus

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.EXAMPLE
Get-OGGroupLicense -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicense {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$GroupId
    )
    $URI = "/$GraphVersion/groups/$GroupId/assignedLicenses"
    Get-OGNextPage -uri $URI

}
<#
.SYNOPSIS
Report all Enabled and Disabled service plans applied by a group

.DESCRIPTION
Report all Enabled and Disabled service plans applied by a group

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER All
Parameter description

.EXAMPLE
Get-OGGroupLicenseReport -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicenseReport {

    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]$GroupId,
        [Parameter(Mandatory, ParameterSetName = 'All')][switch]$All
    )
    switch ($PSCmdlet.ParameterSetName) {

        'All' {
            $groups = Get-OGGroup -all -property assignedLicenses | Where-Object assignedLicenses -NE $null
            $groups.foreach({ Get-OGGroupLicenseReport -groupid $_.id })
        }

        'Single' {
            $skus = Get-OGSkus
            $skusReadable = Get-OGReadableSku
            $group = Get-OGGroup -groupid $groupid
            $ReadableHash = @{}
            $skuHash = @{}
            $spHash = @{}
            $spPerSku = @{}
            foreach ($sR in $skusReadable) {
                $ReadableHash[$sR.GUID] = $sR.Product_Display_Name
                $ReadableHash[$sR.Service_Plan_Id] = $sR.Service_Plans_Included_Friendly_Names
            }
            foreach ($s in $skus) {
                $sku = [PSCustomObject]@{
                    type                          = 'Sku'
                    skuDisplayName                = $ReadableHash[$s.skuid]
                    skuName                       = $s.skuPartNumber
                    #prepaidUnits                  = $s.prepaidUnits
                    prepaidUnitsEnabled           = $s.prepaidUnits.Enabled
                    consumedUnits                 = $s.consumedUnits
                    nonConsumedUnits              = $($s.prepaidUnits.Enabled - $s.consumedUnits)
                    skuAppliesTo                  = $s.appliesTo
                    skuId                         = $s.skuId
                    servicePlanName               = $null
                    servicePlanId                 = $null
                    servicePlanProvisioningStatus = $null
                    servicePlanAppliesTo          = $null
                }
                $skuHash[$sku.skuId] = $Sku
                $splans = @($s.servicePlans)
                foreach ($sp in $splans) {
                    $servicePlan = [PSCustomObject]@{
                        type                          = 'ServicePlan'
                        skuDisplayName                = $ReadableHash[$s.skuid]
                        skuName                       = $s.skuPartNumber
                        #skuPrepaidUnits               = $s.prepaidUnits
                        skuPrepaidUnitsEnabled        = $s.prepaidUnits.Enabled
                        skuConsumedUnits              = $s.consumedUnits
                        skuNonConsumedUnits           = $sku.nonConsumedUnits
                        skuAppliesTo                  = $s.appliesTo
                        skuId                         = $s.skuId
                        servicePlanDisplayName        = $ReadableHash[$sp.servicePlanId]
                        servicePlanName               = $sp.servicePlanName
                        servicePlanId                 = $sp.servicePlanId
                        servicePlanProvisioningStatus = $sp.provisioningStatus
                        servicePlanAppliesTo          = $sp.appliesTo
                    }
                    $spHash[$servicePlan.servicePlanId] = $servicePlan
                }
                $spPerSku[$s.skuid] = $splans.servicePlanId
            }
            $groupLicense = Get-OGGroupLicense -GroupId $GroupId
            $outputProperties = @(
                @{Name = 'groupId'; Expression = { $group.id } }
                @{Name = 'groupDisplayName'; Expression = { $group.DisplayName } }
                @{Name = 'type'; Expression = { 'ServicePlanPerSku' } }
                'skuDisplayName'
                'skuName'
                'skuId'
                'skuPrepaidUnits'
                'skuPrepaidUnitsEnabled'
                'skuConsumedUnits'
                'skuNonConsumedUnits'
                'skuAppliesTo'
                'servicePlanDisplayName'
                'servicePlanName'
                'servicePlanId'
                'servicePlanProvisioningStatus'
                'servicePlanAppliesTo'
                @{Name = 'servicePlanIsEnabled'; Expression = { $_.serviceplanid -notin $groupLicense.disabledPlans } }
            )

            @($grouplicense.skuid).foreach({
                    $gsp = @($spPerSku[$_])
                    $gsp.foreach({ $spHash[$_] })
                }) | Select-Object -ExcludeProperty type -Property $outputProperties
        }
    }
}
<#
.SYNOPSIS
Get calendar events for a group

.DESCRIPTION
Get calendar events for a group or provide a filter queary to filter the results.
NOTE: Delegated Permission Only
Permissions: https://learn.microsoft.com/en-us/graph/api/group-get-event?view=graph-rest-1.0&tabs=http
.PARAMETER GroupId
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get all calendar events for a group
Get-OGGroupEvent -GroupId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Get-OGGroupEvent {

    param (
        [Parameter(Mandatory = $True)]$GroupId,
        [Parameter(Mandatory = $False)]$Filter
    )
    if ($filter) {

        $URI = "/$GraphVersion/groups/$GroupId/events?`$filter=$filter"
        Get-OGNextPage -URI $URI
    }
    else {
        $URI = "/$GraphVersion/groups/$GroupId/events"
        Get-OGNextPage -URI $URI
    }

}


<#
.SYNOPSIS
Get Members of a Group in Azure AD

.DESCRIPTION
Get Members of a Group in Azure AD

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.EXAMPLE
Get-OGGroupMember -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroupMember {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$GroupId
    )
    $URI = "/$GraphVersion/groups/$GroupId/members"
    Get-OGNextPage -uri $URI

}
<#
.SYNOPSIS
Get specified or all Sharepoint Online Sites in a tenant

.DESCRIPTION
Get specified or all Sharepoint Online Sites in a tenant

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER All
Parameter description

.PARAMETER IncludePersonalSites
Parameter description

.EXAMPLE
Get-OGSite -SiteId f232e745-0801-4705-beb6-4d9880fc92b4

.NOTES
General notes
#>
Function Get-OGSite {

    [CmdletBinding(DefaultParameterSetName = 'SID')]
    Param(
        [Parameter(Mandatory,
            ParameterSetName = 'SID')]$SiteId,
        [Parameter(Mandatory,
            ParameterSetName = 'All')][Switch]$All,
        [Parameter(Mandatory = $False,
            ParameterSetName = 'All')][Switch]$IncludePersonalSites
    )
    switch ($PSCmdlet.ParameterSetName) {
        'SID' {
            $account_params = @{
                Uri         = "/$GraphVersion/sites/$SiteId"
                Method      = 'GET'
                OutputType  = 'PSObject'
                ContentType = 'application/json'
            }
            Invoke-MgGraphRequest @Account_params
        }
        'All' {
            $URI = "/$GraphVersion/sites/?$search=*"
            $allResults = Get-OGNextPage -uri $URI
            switch ($IncludePersonalSites) {
                True { $allResults }
                False { $allResults | Where-Object WebUrl -NotLike '*/personal/*' }
            }
        }
    }
}
<#
.SYNOPSIS
Get the lists in a Sharepoint Online Site

.DESCRIPTION
Get the lists in a Sharepoint Online Site

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.EXAMPLE
Get-OGSiteList -SiteId b767d342-3712-492a-94dc-504304cb8412

.NOTES
General notes
#>
Function Get-OGSiteList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists"
    Get-OGNextPage -uri $URI

}


<#
.SYNOPSIS
Get columns contained in an SPO site list

.DESCRIPTION
Get columns contained in an SPO site list

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER ListId
Parameter description

.EXAMPLE
Get-OGSiteListColumn -SiteId b767d342-3712-492a-94dc-504304cb8412 -ListId c1e7d5b3-ed9e-409e-a956-9d77df7c1ec3

.NOTES
General notes
#>
Function Get-OGSiteListColumn {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId
    )
    $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/Columns"
    Get-OGNextPage -uri $URI

}


<#
.SYNOPSIS
Get items in a SPO List

.DESCRIPTION
Get items in a SPO List

Permissions: https://learn.microsoft.com/en-us/graph/api/site-get?view=graph-rest-1.0&tabs=http
.PARAMETER SiteId
Parameter description

.PARAMETER ListId
Parameter description

.PARAMETER ItemId
Parameter description

.EXAMPLE
Get-OGSiteListItem -SiteId a3299706-eac5-46a1-b5eb-5709bea18e89 -ListId 79aafc35-e805-491c-bf19-f0b6c28b6be0
.NOTES
General notes
#>
Function Get-OGSiteListItem {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$SiteId,
        [Parameter(Mandatory)]$ListId,
        [Parameter(Mandatory = $false)]$ItemId
    )
    if ($ItemId) {
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?expand=fields"
        $response = Get-OGNextPage -uri $URI | Where-Object id -EQ $ItemId
        $response.fields
    }
    else {
        $URI = "/$GraphVersion/sites/$SiteId/lists/$ListId/items?expand=fields"
        $response = Get-OGNextPage -uri $URI
        $response.fields
    }

}


<#
.SYNOPSIS
REcursive Helper function for simplifying graph api requests including next page functionality

.DESCRIPTION
Recursive Helper function for simplifying graph api requests including next page functionality.

.PARAMETER URI
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get-OGNextpage -URI "/v1.0/users"

.NOTES
General notes
#>
Function Get-OGNextPage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$URI,
        [Parameter(Mandatory = $False)][Switch]$Filter
    )
    $account_params = @{
        URI         = $URI
        Method      = 'GET'
        OutputType  = 'PSObject'
        ContentType = 'application/json'
    }
    switch ($filter) {
        $true {
            $account_params.add('Headers', @{})
            $account_params.Headers.add('ConsistencyLevel', 'eventual')
        }
    }
    $Result = Invoke-MgGraphRequest @Account_params
    switch ($null -ne $Result.value) {
        $true {
            $Result.value
        }
        $False {
            $Result | Select-Object -ExcludeProperty '@odata.*'
        }
    }
    if ($result.'@odata.nextlink') {
        Get-OGNextPage -Uri $result.'@odata.nextlink'
    }
}
<#
.SYNOPSIS
Provide human readable description to M365 Service Plans by downloading the csv in the Microsoft Docs reference.

.DESCRIPTION
Provide human readable description to M365 Service Plans by downloading the csv in the Microsoft Docs reference. If the CSV fails to download a local copy will be used for the output. If the download is successful, the local copy will be updated.

.EXAMPLE
Get-OGReadableSku

.NOTES

#>
function Get-OGReadableSku {
    [CmdletBinding()]
    param ()
    $url = "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv"
    $temp = Get-PSDrive -Name "Temp"
    $joinPath = Join-Path -Path $temp.Root -ChildPath "OGReadableSku.csv"
    try { Invoke-WebRequest -Uri $url -OutFile $joinPath }
    catch {
        Out-Null
    }
    if (test-path -Path $joinPath) {
        $output = Import-Csv -Path $joinPath
        Remove-Item -Path $joinPath
        $getLocalCSV = $PSScriptRoot.Substring(0, $PSScriptRoot.Length - 10)
        $joinPath2 = Join-Path -Path $getLocalCSV -ChildPath '\OGReadableSku.csv'
        $output | export-csv -Path $joinPath2
        $output
    }
    else {
        $getLocalCSV = $PSScriptRoot.Substring(0, $PSScriptRoot.Length - 10)
        $joinPath2 = Join-Path -Path $getLocalCSV -ChildPath '\OGReadableSku.csv'
        Import-Csv -Path $joinPath2
    }
}
<#
.SYNOPSIS
Get Azure AD Skus consumed in the tenant

.DESCRIPTION
Long description

Permissions: https://learn.microsoft.com/en-us/graph/api/subscribedsku-list?view=graph-rest-1.0&tabs=http
.EXAMPLE
Get-OGSku

.NOTES
General notes
#>
Function Get-OGSku {
    $Uri = "/$GraphVersion/subscribedSkus"
    get-ognextpage -uri $Uri
}
<#
.SYNOPSIS
Get users from Azure AD

.DESCRIPTION
Get users from Azure AD

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Get Users by userprincipalname

.PARAMETER SearchDisplayName
Search for users by displayname

.PARAMETER All
Get all users in tenant

.PARAMETER Property
Select additional properties of a user

.EXAMPLE
Get-OGUser -UserPrincipalName test@testaccount.onmicrosoft.com

.NOTES
General notes
#>
Function Get-OGUser {

    [CmdletBinding(DefaultParameterSetName = 'UPN')]
    param (
        [Parameter(ParameterSetName = 'UPN')]$UserPrincipalName,
        [Parameter(ParameterSetName = 'Search')]$SearchDisplayName,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All,
        [Parameter()]
        [string[]]$Property
    )
    $includeAttributes = 'businessPhones', 'displayName', 'givenName', 'id', 'jobTitle', 'mail', 'mobilePhone', 'officeLocation', 'preferredLanguage', 'surname', 'userPrincipalName'
    $IncludeAttributeString = $($includeAttributes; $Property) -join ','
    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $URI = "/$GraphVersion/users/$($userprincipalname)?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
        'Search' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)`$search=`"displayName:$SearchDisplayName`""
            Get-OGNextPage -uri $URI -filter
        }
        'All' {
            $URI = "/$GraphVersion/users?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
    }
}
<#
.SYNOPSIS
Get user OneDrive Meta information

.DESCRIPTION
Get user OneDrive Meta information

Permissions: https://learn.microsoft.com/en-us/graph/api/drive-get?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Userprincipalname or ID for lookup

.EXAMPLE
Get-OGUserDrive -userprincipalname test.user@domain.com
.NOTES
General notes
#>
Function Get-OGUserDrive {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName
    )
    $URI = "/$GraphVersion/users/$userprincipalname/drive"
    Get-OGNextPage -uri $URI
}
<#
.SYNOPSIS
Get calendar events for a user

.DESCRIPTION
Get calendar events for a user or provide a filter queary to filter the results.

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-events?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Parameter description

.PARAMETER Filter
Parameter description

.EXAMPLE
Get all calendar events for a group
Get-OGUserEvent -GroupId 3fbabd10-7bbc-410d-ba6c-0ba60e863c30

.NOTES
General notes
#>
Function Get-OGUserEvent {
    param (
        [Parameter(Mandatory = $True)]$UserPrincipalName,
        [Parameter(Mandatory = $False)]$Filter
    )
    if ($filter) {
        $URI = "/$GraphVersion/users/$userprincipalname/events?`$filter=$filter"
        Get-OGNextPage -URI $URI -Filter
    }
    else {
        $URI = "/$GraphVersion/users/$userprincipalname/events"
        Get-OGNextPage -URI $URI
    }
}
<#
.SYNOPSIS
Get Azure AD skus for individual user

.DESCRIPTION
Get Azure AD skus for individual user

Permissions: https://learn.microsoft.com/en-us/graph/api/user-list-licensedetails?view=graph-rest-1.0&tabs=http
.PARAMETER UserPrincipalName
Parameter description

.EXAMPLE
Get-OGUserSku -UserPrincipalName jdoe@contoso.com

.NOTES
General notes
#>
Function Get-OGUserSku {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$UserPrincipalName
    )

    $Uri = "$GraphVersion/Users/$($UserPrincipalName)/licenseDetails"
    Get-OGNextPage -uri $Uri
}
<#
.SYNOPSIS
Remove member from Azure AD group membership

.DESCRIPTION
Remove member from Azure AD group membership

Permissions: https://learn.microsoft.com/en-us/graph/api/group-delete-members?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
Parameter description

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER MemberId
Parameter description

.EXAMPLE
Remove-OGGroupMember -ObjectId a3299706-eac5-46a1-b5eb-5709bea18e89 -MemberId b767d342-3712-492a-94dc-504304cb8412

.NOTES
General notes
#>
Function Remove-OGGroupMember {

    [CmdletBinding(DefaultParameterSetName = 'MID', SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $GroupId,
        [Parameter(Mandatory,
            ParameterSetName = 'UPN')]
        $UserPrincipalName,
        [Parameter(Mandatory,
            ParameterSetName = 'MID')]
        $MemberId
    )
    switch ($PSCmdlet.ParameterSetName) {
        'UPN' {
            $MemberId = Get-OGUser -UserPrincipalName $UserPrincipalName
            $MemberId = $MemberId.Id
        }
    }
    $URI = "/$GraphVersion/groups/$GroupId/members/$MemberId/`$ref"
    $account_params = @{
        Uri    = $URI
        Method = 'DELETE'
    }
    if ($PSCmdlet.ShouldProcess($GroupID, "remove member $($UserPrincipalName)$($MemberId)")) {
        Invoke-MgGraphRequest @Account_params
    }
}
<#
.SYNOPSIS
Set basic fields for a user object or disable an account

.DESCRIPTION
Updated UPN, disable a user, Set firstname, lastname, or displayname

Permissions: https://learn.microsoft.com/en-us/graph/api/user-update?view=graph-rest-1.0&tabs=http

.PARAMETER UserPrincipalName
Parameter description

.PARAMETER NewUserPrincipalName
Parameter description

.PARAMETER accountEnabled
Parameter description

.PARAMETER FirstName
Parameter description

.PARAMETER LastName
Parameter description

.PARAMETER DisplayName
Parameter description

.EXAMPLE
Set-OGUser -UserPrincipalName jdoe@contoso.com -accountEnabled $false

.NOTES
General notes
#>
Function Set-OGUser {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]$UserPrincipalName,
        [Parameter(Mandatory = $false)][String]$NewUserPrincipalName,
        [Parameter(Mandatory = $false)][String]$accountEnabled,
        [Parameter(Mandatory = $false)][String]$FirstName,
        [Parameter(Mandatory = $false)][String]$LastName,
        [Parameter(Mandatory = $false)][String]$DisplayName
    )
    $User = Get-OGUser -UserPrincipalName $UserPrincipalName
    $bodyparams = @{}
    switch ($PSBoundParameters.Keys) {
        'NewUserPrincipalName' {
            $bodyparams.add('userPrincipalName', $NewUserPrincipalName)
        }
        'accountEnabled' {
            $bodyparams.add('accountEnabled', $accountEnabled)
        }
        'FirstName' {
            $bodyparams.add('givenName', $FirstName)
        }
        'LastName' {
            $bodyparams.add('surname', $LastName)
        }
        'DisplayName' {
            $bodyparams.add('displayName', $DisplayName)
        }
    }
    $Body = [PSCustomObject]@{}
    $body | Add-Member $bodyparams
    $account_params = @{
        Uri         = "/$GraphVersion/users/$($User.Id)"
        body        = $body | ConvertTo-Json -Depth 5
        Method      = 'PATCH'
        ContentType = 'application/json'
    }
    if ($PSCmdlet.ShouldProcess($UserPrincipalName, "set $($bodyparams.keys)")) {
        Invoke-MgGraphRequest @Account_params | Out-Null
    }
}
<#
.SYNOPSIS
Switch between graph api versions beta and v1.0

.DESCRIPTION
Switch between graph api versions beta and v1.0

.PARAMETER Beta
Parameter description

.PARAMETER v1
Parameter description

.EXAMPLE
Set-OGGraphVersion -Beta

.NOTES
General notes
#>
Function Set-OGGraphVersion {

    [CmdletBinding(DefaultParameterSetName = 'v1', SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Beta')][switch]$Beta,
        [Parameter(Mandatory = $false,
            ParameterSetName = 'v1')][switch]$v1
    )
    if ($PSCmdlet.ShouldProcess("Graph Version", "set Graph API version to $($PSCmdlet.ParameterSetName)")) {
        switch ($PSCmdlet.ParameterSetName) {
            'Beta' {
                $Script:GraphVersion = 'beta'
            }
            'v1' {
                $Script:GraphVersion = 'v1.0'
            }
        }
    }
}


###############################################################################################
# Import User's Configuration
###############################################################################################
#Import-OGConfiguration
###############################################################################################
# Setup Tab Completion
###############################################################################################
# Tab Completions for IM Definition Names
<# $ImDefinitionsScriptBlock = {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
  $MyParams = @{ }
  if ($null -ne $fakeBoundParameter.InstallManager)
  {
    $MyParams.InstallManager = $fakeBoundParameter.InstallManager
  }
  if ($null -ne $wordToComplete)
  {
    $MyParams.Name = $wordToComplete + '*'
  }
  $MyNames = Get-IMDefinition @MyParams |
    Select-Object -expandProperty Name

  foreach ($n in $MyNames)
  {
    [System.Management.Automation.CompletionResult]::new($n, $n, 'ParameterValue', $n)
  }
}

Register-ArgumentCompleter -CommandName @(
  'Get-IMDefinition'
  'Set-IMDefinition'
  'Remove-IMDefinition'
  'Update-IMInstall'
) -ParameterName 'Name' -ScriptBlock $ImDefinitionsScriptBlock #>

