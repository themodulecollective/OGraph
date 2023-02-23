<#
.SYNOPSIS
Report all Enabled and Disabled skus and service plans applied by a group

.DESCRIPTION
Report all Enabled and Disabled skus and service plans applied by a group

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http

.PARAMETER GroupId
GroupID (guid) for the group for which to report licensing details.

.PARAMETER All
Includes all groups that have a license assignment.

.PARAMETER IncludeDisplayName
Includes "human readable" Display Names for skus and service plans.

.EXAMPLE
Get-OGGroupLicenseReport -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicenseReport
{

    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        $GroupId,
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [switch]$All,
        [Parameter()]
        [switch]$IncludeDisplayName
    )
    switch ($PSCmdlet.ParameterSetName)
    {

        'All'
        {
            $groups = @(Get-OGGroup -All -Property assignedLicenses).where({$_.assignedLicenses.count -ge 1})
            $getOGGLRParams = @{IncludeDisplayName = $IncludeDisplayName}
            $groups.foreach({ Get-OGGroupLicenseReport -GroupId $_.id @getOGGLRParams})
        }

        'Single'
        {
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
            $skus = Get-OGSku
            $group = Get-OGGroup -GroupId $groupid
            $skuHash = @{}
            $spHash = @{}
            $spPerSku = @{}
            foreach ($s in $skus)
            {
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
                foreach ($sp in $splans)
                {
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