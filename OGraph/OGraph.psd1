#
# Module manifest for module 'OGraph'
#
# Generated by: Ben Pulido, Mike Campbell
#
# Generated on: 1/5/2022
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = '.\OGraph.psm1'

    # Version number of this module.
    ModuleVersion        = '0.0.1.17'

    # Supported PSEditions
    CompatiblePSEditions = @('Core', 'Desktop')

    # ID used to uniquely identify this module
    GUID                 = 'd0ec49db-0a7f-481f-bac6-8e0c6a30188f'

    # Author of this module
    Author               = 'Ben Pulido, Mike Campbell'

    # Company or vendor of this module
    CompanyName          = 'The Module Collective'

    # Copyright statement for this module
    Copyright            = 'Copyright 2024 The Module Collective'

    # Description of the functionality provided by this module
    Description          = 'PowerShell functions for administration of Microsoft 365 services using Graph endpoints'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '7.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules      = @('Microsoft.Graph.Authentication')

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'Add-OGGroupMember'
        'Connect-OGGraph'
        'Get-OGGraphVersion'
        'Get-OGCalendar'
        'Get-OGChatMembership'
        'Get-OGDriveUser'
        'Get-OGGroup'
        'Get-OGGroupDrive'
        'Get-OGGroupEvent'
        'Get-OGGroupMember'
        'Get-OGGroupLicense'
        'Get-OGGroupLicenseReport'
        'Get-OGSite'
        'Get-OGSiteList'
        'Get-OGSiteListColumn'
        'Get-OGSiteListItem'
        'Get-OGSiteListItemVersion'
        'Get-OGNextPage'
        'Get-OGReadableSku'
        'Get-OGSku'
        'Get-OGUser'
        'Get-OGUserDrive'
        'Get-OGUserEvent'
        'Get-OGUserLastLogin'
        'Get-OGUserSku'
        'New-OGSiteListItem'
        #'Remove-OGChatMember'
        'Remove-OGChatMessage'
        'Remove-OGDriveItemById'
        'Remove-OGGroupMember'
        'Remove-OGSiteListItem'
        'Set-OGUser'
        'Set-OGGraphVersion'
        'Update-OGSiteListItem'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    #CmdletsToExport      = @()

    # Variables to export from this module
    #VariablesToExport    = ''

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    #AliasesToExport      = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @(
                'Microsoft'
                'Graph'
                'Office365'
                'PowerShell'
                'AzureAD'
                'EntraID'
            )

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/themodulecollective/OGraph'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
