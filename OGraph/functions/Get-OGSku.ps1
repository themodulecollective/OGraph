<#
.SYNOPSIS
Get Skus available in the connected Microsoft tenant

.DESCRIPTION
Gets Skus available in the connected Microsoft Tenant and allows the inclusion of "human readable" DisplayNames.

.PARAMETER IncludeDisplayName
Includes "human readable" display names in the output for both skus and serviceplans.

.PARAMETER ServicePlanDelimiter
Specify the delimiter for the ServicePlanNames and ServicePlanDisplayNames.  Defaults to ";".

.EXAMPLE
Get-OGSku

.NOTES
Permissions Required: https://learn.microsoft.com/en-us/graph/api/subscribedsku-list?view=graph-rest-1.0&tabs=http
#>
Function Get-OGSku
{
    [CmdletBinding()]
    [OutputType([System.Array],[System.String])]
    param(
        [switch]$IncludeDisplayName
        ,
        [parameter()]
        [ValidateLength(1,1)]
        [string]$ServicePlanDelimiter = ';'
    )

    $Uri = "/$GraphVersion/subscribedSkus"
    $ReadableHash = @{}
    $rawSku = get-ognextpage -uri $Uri
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

    foreach ($s in $rawSku)
    {
        [PSCustomObject]@{
            'AccountName' = $s.AccountName
            'AccountID' = $s.AccountID
            'AppliesTo' = $s.AppliesTo
            'CapabilityStatus' = $s.CapabilityStatus
            'id' = $s.id
            'skuid' = $s.skuid
            'skupartnumber'= $s.skupartnumber
            'prepaidUnitsEnabled'= $s.prepaidUnits.enabled
            'consumedUnits' = $s.consumedUnits
            'nonConsumedUnits'= $s.prepaidUnits.Enabled - $s.consumedUnits
            'skuDisplayName' = $ReadableHash[$s.skuid]
            'servicePlanIDs' = $s.ServicePlans.foreach({$_.ServicePlanID}) -join $ServicePlanDelimiter
            'servicePlanNames' = $s.ServicePlans.foreach({$_.ServicePlanName}) -join $ServicePlanDelimiter
            'servicePlanDisplayNames' = $s.ServicePlans.foreach({$ReadableHash[$_.ServicePlanID]}).where({$null -ne $_}) -join $ServicePlanDelimiter
            'SubscriptionIDs' = $s.SubscriptionIDs
            'ServicePlans' = $s.ServicePlans
            'PrepaidUnits' = $s.PrepaidUnits
        }
    }
}