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
    param (
        [switch]$StoreCSV
    )

    $PreDownloadedCSV = Join-Path -Path $PSScriptRoot -ChildPath 'OGReadableSku.csv'
    switch (Test-Path -Path $PreDownloadedCSV -Type Leaf)
    {
        $True
        {
            Import-Csv $PreDownloadedCSV
        }
        $False
        {
            try {
                Invoke-WebRequest -Uri $url -OutFile $joinPath
                $url = "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv"
                $temp = Get-PSDrive -Name "Temp"
                $TempPath = Join-Path -Path $temp.Root -ChildPath "OGReadableSku.csv"
                Import-CSV $TempPath
            }
            catch {
                Out-Null
            }
        }
    }
    switch ($StoreCSV)
    {
        $True
        {
            Move-Item -Path $TempPath -Destination $PreDownloadedCSV -Force -Confirm:$false
        }
    }
}