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
            $groups = @(Get-OGGroup -Licensing)
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
            $skuHash = @{} #hashtable to be populated with key SkuID and value SKU detail object
            $spHash = @{} #hashtable to be populated with key service plan ID and value service plan detail object
            $spPerSku = @{} #hasthable to be populated with key SkuID and value ServicePlanIDs collection
            foreach ($s in $skus)
            {
                $sku = [PSCustomObject]@{
                    type                          = 'Sku'
                    skuDisplayName                = $ReadableHash[$s.skuid]
                    skuName                       = $s.skuPartNumber
                    prepaidUnitsEnabled           = $s.prepaidUnitsEnabled
                    consumedUnits                 = $s.consumedUnits
                    nonConsumedUnits              = $s.nonConsumedUnits
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
                    $spHash[$servicePlan.servicePlanId + '_' + $sku.skuID] = $servicePlan
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
                    $gskuid = $_
                    $gsp = @($spPerSku[$gskuid])
                    $gsp.foreach({ $spHash[$_ + '_' + $gskuid] })
                }) | Select-Object -ExcludeProperty type -Property $outputProperties
        }
    }
}