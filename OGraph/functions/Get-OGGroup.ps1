<#
.SYNOPSIS
Get group from Azure AD
.DESCRIPTION
Get group using an Object ID, by searching for a displayname, or getting all groups.

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group

.PARAMETER SearchDisplayName
Get the Group(s) by DisplayName search

.PARAMETER All
Get all Groups from the Microsoft Tenant

.PARAMETER UnifiedAll
Get all Unified Groups from the Microsoft Tenant

.PARAMETER Licensing
Get all Licensing Groups from the Microsoft Tenant

.PARAMETER Property
Include the specified group property(ies) in the output

.EXAMPLE
Get a group by Object ID
Get-OGGroup -GroupId 3175b598-0fa0-4002-aebf-bfbf759c94a7

.NOTES
General notes
#>
Function Get-OGGroup
{
    [CmdletBinding(DefaultParameterSetName = 'OID')]
    param (

        [Parameter(ParameterSetName = 'OID')]
        $GroupId
        ,
        [Parameter(ParameterSetName = 'Search')]
        $SearchDisplayName
        ,
        [Parameter(ParameterSetName = 'All')]
        [Switch]$All
        ,
        [Parameter(ParameterSetName = 'UnifiedAll')]
        [Switch]$UnifiedAll
        ,
        [Parameter(ParameterSetName = 'Licensing')]
        [Switch]$Licensing
        ,
        [Parameter()]
        [string[]]$Property

    )
    $IncludeAttributes =[System.Collections.Generic.List[string]]@('classification', 'createdByAppId', 'createdDateTime', 'deletedDateTime', 'description', 'displayName', 'expirationDateTime', 'groupTypes', 'id', 'infoCatalogs', 'isAssignableToRole', 'isManagementRestricted', 'mail', 'mailEnabled', 'mailNickname', 'membershipRule', 'membershipRuleProcessingState', 'onPremisesDomainName', 'onPremisesLastSyncDateTime', 'onPremisesNetBiosName', 'onPremisesProvisioningErrors', 'onPremisesSamAccountName', 'onPremisesSecurityIdentifier', 'onPremisesSyncEnabled', 'organizationId', 'preferredDataLocation', 'preferredLanguage', 'proxyAddresses', 'renewedDateTime', 'resourceBehaviorOptions', 'resourceProvisioningOptions', 'securityEnabled', 'securityIdentifier', 'theme', 'visibility', 'writebackConfiguration','assignedLicenses')
    $IncludeAttributeString = $($($includeAttributes; $Property) | Sort-Object -unique) -join ','
    switch ($PSCmdlet.ParameterSetName)
    {
        'OID'
        {
            $URI = "/$GraphVersion/groups/$($GroupId)?`$select=$($IncludeAttributeString)"
            get-ognextpage -uri $uri
        }
        'Search'
        {
            $URI = '/' + $GraphVersion + '/groups?$search="displayName:' + $SearchDisplayName + '"&$select=' + $IncludeAttributeString
            Get-OGNextPage -uri $URI -Filter
        }
        'All'
        {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI
        }
        'UnifiedAll'
        {
            $URI = "/$GraphVersion/groups?`$filter=groupTypes/any(c:c+eq+'Unified')&`$select=$($IncludeAttributeString)"
            Get-OGNextPage -Uri $URI -Filter
        }
        'Licensing'
        {
            $URI = "/$GraphVersion/groups?`$select=$($IncludeAttributeString)&`$filter=assignedLicenses/`$count ne 0&`$count=true"
            Get-OGNextPage -Uri $URI -Filter
        }
    }
}