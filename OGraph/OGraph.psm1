$ModuleFolder = Split-Path $PSCommandPath -Parent

$Scripts = Join-Path -Path $ModuleFolder -ChildPath 'scripts'
$Functions = Join-Path -Path $ModuleFolder -ChildPath 'functions'

# Write-Information -MessageData "Scripts Path  = $Scripts" -InformationAction Continue
# Write-Information -MessageData "Functions Path  = $Functions" -InformationAction Continue

$Script:ModuleFiles = @(
    $(Join-Path -Path $Scripts -ChildPath 'Initialize.ps1')
    # Load Functions
    $(Join-Path -Path $functions -ChildPath 'Add-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Connect-OGGraph.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGCalendar.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroup.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupLicense.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupLicenseReport.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupEvents.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSite.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteList.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListColumns.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListItem.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGNextPage.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSkus.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUser.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserDrive.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserEvents.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserSkus.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Set-OGUser.ps1')
    $(Join-Path -Path $functions -ChildPath 'Set-OGGraphVersion.ps1')
    # Finalize / Run any Module Functions defined above
    $(Join-Path -Path $Scripts -ChildPath 'RunFunctions.ps1')
)

# Write-Information -MessageData $($ModuleFiles -join ';') -InformationAction Continue

foreach ($f in $ModuleFiles) {
    . $f
}