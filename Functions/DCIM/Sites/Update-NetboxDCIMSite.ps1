#region File Update-NetboxDCIMSite.ps1

<#
    .NOTES
    ===========================================================================
     Created with:  VS Code 1.75.0
     Created on:    2023-06-28 13:21
     Created by:    Craig Roser
     Organization:  Sentrian
     Filename:      Update-NetboxDCIMSite.ps1
    ===========================================================================
    .DESCRIPTION
        A description of the file.
#>

Function Update-NetboxDCIMSite {
    <#
        .SYNOPSIS
            Update a Site

        .DESCRIPTION
            Update a Site from Netbox

        .EXAMPLE
            Update-NetboxDCIMSite -Id 1 -name 'Updated Name' -slug 6969 -description 'New Description'

            Update Site with id 1

        .EXAMPLE
            Get-NetboxDCIMSite -name MySite | Update-NetboxDCIMSite -confirm:$false

            Update Site with name MySite without confirmation

    #>

    [CmdletBinding(ConfirmImpact = 'low',
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [uint32]$id,
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$name,
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$slug,
        [string]$facility,
        [uint32]$asn,
        [decimal]$latitude,
        [decimal]$longitude,
        [string]$contact_name,
        [string]$contact_phone,
        [string]$contact_email,
        [int]$group,
        [int]$tenant,
        [string]$status,
        [uint32]$region,
        [string]$description,
        [string]$physical_Address,
        [string]$shipping_address,
        [string]$comments,
        [switch]$raw
    )
    begin {
    }
    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'sites'))
        $CurrentSite = Get-NetboxDCIMSite -Id $Id -ErrorAction Stop
        If (-not $PSBoundParameters.ContainsKey('slug')) {$PSBoundParameters.Add('slug', $CurrentSite.slug)}
        If (-not $PSBoundParameters.ContainsKey('name')) {$PSBoundParameters.Add('name', $CurrentSite.name)}

        $Method = 'PUT'

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters
        $URI = BuildNewURI -Segments $URIComponents.Segments
        If ($pscmdlet.ShouldProcess("$($CurrentSite.Id)", "Update Site")) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
    end {
    }
}

#endregion