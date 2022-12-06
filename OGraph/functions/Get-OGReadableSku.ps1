<#
.SYNOPSIS
Provide human readable description to M365 Service Plans by downloading the csv in the Microsoft Docs reference.

.DESCRIPTION
Provide human readable description to M365 Service Plans by downloading the csv in the Microsoft Docs reference. If the CSV fails to download a local copy will be used for the output. If the download is successful, the local copy will be updated.

.EXAMPLE
Get-OGReadableSku

.NOTES

#>
function Get-OGReadableSku {
    [CmdletBinding()]
    param ()
    $url = "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv"
    $temp = Get-PSDrive -Name "Temp"
    $joinPath = Join-Path -Path $temp.Root -ChildPath "OGReadableSku.csv"
    try { Invoke-WebRequest -Uri $url -OutFile $joinPath }
    catch {
        Out-Null
    }
    if (test-path -Path $joinPath) {
        $output = Import-Csv -Path $joinPath
        Remove-Item -Path $joinPath
        $getLocalCSV = $PSScriptRoot.Substring(0, $PSScriptRoot.Length - 10)
        $joinPath2 = Join-Path -Path $getLocalCSV -ChildPath '\OGReadableSku.csv'
        $output | export-csv -Path $joinPath2
        $output
    }
    else {
        $getLocalCSV = $PSScriptRoot.Substring(0, $PSScriptRoot.Length - 10)
        $joinPath2 = Join-Path -Path $getLocalCSV -ChildPath '\OGReadableSku.csv'
        Import-Csv -Path $joinPath2
    }
}