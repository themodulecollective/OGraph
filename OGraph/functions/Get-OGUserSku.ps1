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
        ,
        [switch]$IncludeDisplayName
        ,
        [parameter()]
        [ValidateLength(1,1)]
        [string]$ServicePlanDelimiter = ';'
        ,
        [parameter()]
        [alias('PassthruUPN')]
        [switch]$PassthruUserPrincipalName
    )

    $ReadableHash = @{}
    switch ($IncludeDisplayName)
    {
        $true
        {
            $skusReadable = Get-OGReadableSku
            foreach ($sR in $skusReadable)
            {
                $ReadableHash[$sR.GUID] = $sR.Product_Display_Name
                $ReadableHash[$sR.Service_Plan_Id] = $sR.Service_Plans_Included_Friendly_Names
            }
        }
    }

    $Uri = "$GraphVersion/Users/$($UserPrincipalName)/licenseDetails"
    $rawSku = Get-OGNextPage -uri $Uri
    if ($PassthruUserPrincipalName) {
        $rawSku = $rawSku | Select-Object -Property @{n='UserPrincipalName';e={$UserPrincipalName}},*
    }
    foreach ($s in $rawSku)
    {
        $s | Select-Object -Property *,
        @{n='skuDisplayName';e = {$ReadableHash[$s.skuid]}},
        @{n='servicePlanNames';e= {$s.ServicePlans.foreach({$_.ServicePlanName}) -join $ServicePlanDelimiter}},
        @{n='servicePlanDisplayNames'; e= {$s.ServicePlans.foreach({$ReadableHash[$_.ServicePlanID]}).where({$null -ne $_}) -join $ServicePlanDelimiter}}
    }
}