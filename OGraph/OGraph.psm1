$ModuleFolder = Split-Path $PSCommandPath -Parent
$Scripts = Join-Path -Path $ModuleFolder -ChildPath 'scripts'
$Functions = Join-Path -Path $ModuleFolder -ChildPath 'functions'

$Script:ModuleFiles = @(
    $(Join-Path -Path $Scripts -ChildPath 'Initialize.ps1')
    # Load Functions
    $(Join-Path -Path $functions -ChildPath 'Add-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Connect-OGGraph.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGChatMembership.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGDriveUser.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGraphVersion.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGCalendar.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroup.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupDrive.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupLicense.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupLicenseReport.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupEvent.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGGroupSite.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSite.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteList.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListColumn.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListItem.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListItemFailureField.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteListItemVersion.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSiteSubsite.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGNextPage.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGReadableSku.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGSku.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUser.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserDrive.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserEvent.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserLastLogin.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserRegistrationDetail.ps1')
    $(Join-Path -Path $functions -ChildPath 'Get-OGUserSku.ps1')
    $(Join-Path -Path $functions -ChildPath 'New-OGSiteListItem.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGChatMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGChat.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGDriveItemById.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGGroupMember.ps1')
    $(Join-Path -Path $functions -ChildPath 'Remove-OGSiteListItem.ps1')
    $(Join-Path -Path $functions -ChildPath 'Set-OGUser.ps1')
    $(Join-Path -Path $functions -ChildPath 'Set-OGGraphVersion.ps1')
    $(Join-Path -Path $functions -ChildPath 'Update-OGSiteListItem.ps1')
    # Finalize / Run any Module Functions defined above
    $(Join-Path -Path $Scripts -ChildPath 'RunFunctions.ps1')
)

foreach ($f in $ModuleFiles) {
    . $f
}