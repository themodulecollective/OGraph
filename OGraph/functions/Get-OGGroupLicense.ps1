<#
.SYNOPSIS
Get the license skus applied by a group

.DESCRIPTION
Gets the license skus applied by a group and any disabled service plans of those skus

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group

.EXAMPLE
Get-OGGroupLicense -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicense
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]$GroupId
        ,
        [switch]$IncludeDisplayName
<#         ,
        [parameter()]
        [ValidateLength(1,1)]
        [string]$ServicePlanDelimiter = ';' #>
        ,
        [parameter()]
        [switch]$PassthruGroupID
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
    $URI = "/$GraphVersion/groups/$GroupId/assignedLicenses"
    $rawSku = @(Get-OGNextPage -uri $Uri)
    if ($PassthruGroupID) {
        $rawSku = @($rawSku | Select-Object -Property @{n='GroupID';e={$GroupID}},*)
    }
    foreach ($s in $rawSku)
    {
        $s | Select-Object -Property *,
        @{n='skuDisplayName';e = {$ReadableHash[$s.skuid]}}
        #@{n='servicePlanNames';e= {$s.ServicePlans.foreach({$_.ServicePlanName}) -join $ServicePlanDelimiter}},
        #@{n='servicePlanDisplayNames'; e= {$s.ServicePlans.foreach({$ReadableHash[$_.ServicePlanID]}).where({$null -ne $_}) -join $ServicePlanDelimiter}}
    }
}