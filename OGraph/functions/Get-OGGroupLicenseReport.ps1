<#
.SYNOPSIS
Report all Enabled and Disabled service plans applied by a group

.DESCRIPTION
Report all Enabled and Disabled service plans applied by a group

Permissions: https://learn.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http
.PARAMETER GroupId
Parameter description

.EXAMPLE
Get-OGGroupLicenseReport -GroupId f6557fc2-d4a5-4266-8f4c-2bdcd0cd9a2d

.NOTES
General notes
#>
Function Get-OGGroupLicenseReport
{

    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]$GroupId,
        [Parameter(Mandatory, ParameterSetName = 'All')][switch]$All
    )
    switch ($PSCmdlet.ParameterSetName)
    {

        'All'
        {
            $groups = Get-OGGroup -all -property assignedLicenses | Where-Object assignedLicenses -NE $null
            $groups.foreach({ Get-OGGroupLicenseReport -groupid $_.id })
        }

        'Single'
        {
            $skus = Get-OGSkus
            $group = Get-OGGroup -groupid $groupid
            $skuHash = @{}
            $spHash = @{}
            $spPerSku = @{}
            foreach ($s in $skus)
            {
                $sku = [PSCustomObject]@{
                    type                          = 'Sku'
                    skuName                       = $s.skuPartNumber
                    prepaidUnits                  = $s.prepaidUnits
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
                        skuName                       = $s.skuPartNumber
                        skuPrepaidUnits               = $s.prepaidUnits
                        skuPrepaidUnitsEnabled        = $s.prepaidUnits.Enabled
                        skuConsumedUnits              = $s.consumedUnits
                        skuNonConsumedUnits           = $sku.nonConsumedUnits
                        skuAppliesTo                  = $s.appliesTo
                        skuId                         = $s.skuId
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
                'skuName'
                'skuId'
                'skuPrepaidUnits'
                'skuPrepaidUnitsEnabled'
                'skuConsumedUnits'
                'skuNonConsumedUnits'
                'skuAppliesTo'
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