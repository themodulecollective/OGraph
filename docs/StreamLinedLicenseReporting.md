```PowerShell
# requires PowerShell 7.x
# uses Microsoft.Graph module(s), specifically Connect-MGGraph and Invoke-MgGraphRequest from Microsoft.Graph.Authentication
# uses the ImportExcel module for exporting to an Excel spreadsheet Install-Module OGraph #default installs into current user location, use -scope AllUsers to install at the machine level Install-Module ImportExcel #default installs into current user location, use -scope AllUsers to install at the machine level Import-Module OGraph
# Configure an App Registration in Azure AD for License Reporting and/or other automated reporting.  Setup Certificate based authentication (recommended) and/or Client Secret based authentication. Minimum permissions: Group.Read.All, Organization.Read.All, User.Read
# Connect to Microsoft Graph
Connect-OGraph -TenantID [your tenant ID] - ApplicationID [your app registration ID] -CertificateThumbprint [certificate thumbprint] # OR -ClientSecret [Your ClientSecret]
# Configures the pivot table definition
$PTD = New-PivotTableDefinition -PivotTableName PivotReport -PivotRows 'groupDisplayName','skuDisplayName','servicePlanDisplayName' -PivotColumns 'servicePlanIsEnabled' -PivotData @{'servicePlanIsEnabled'='Count'} -NoTotalsInPivot -SourceWorksheet 'GroupLicensingReport'
# Optional:  Downloads the Readable SKUs from Microsoft and stores it in the OGraph module folder. Otherwise, the file is downloaded but not stored each time Get-OGGroupLicenseReport is run. May require admin rights depending on the module installation scope.
Get-OGReadableSKU -StoreCSV
# Gets the raw licensing report per group and then exports and formats the data in an excel worksheet and related Pivot Table.
Get-OGGroupLicenseReport -All | Export-Excel -Path C:\Local\TenantGroupLicensingReport.xlsx -Table SkusAndPlansPerGroup -TableStyle Medium11 -WorksheetName GroupLicensingReport -PivotTableDefinition $PTD
```