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
        $s | Select-Object -Property *,
        @{n='prepaidUnitsEnabled';e= {$_.prepaidUnits.enabled}},
        @{n='nonConsumedUnits';e= {$($s.prepaidUnits.Enabled - $s.consumedUnits)}},
        @{n='skuDisplayName';e = {$ReadableHash[$s.skuid]}},
        @{n='servicePlanIDs';e= {$s.ServicePlans.foreach({$_.ServicePlanID}) -join $ServicePlanDelimiter}},
        @{n='servicePlanNames';e= {$s.ServicePlans.foreach({$_.ServicePlanName}) -join $ServicePlanDelimiter}},
        @{n='servicePlanDisplayNames'; e= {$s.ServicePlans.foreach({$ReadableHash[$_.ServicePlanID]}).where({$null -ne $_}) -join $ServicePlanDelimiter}}
    }
}