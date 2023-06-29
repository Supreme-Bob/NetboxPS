function New-NetboxDCIMSite {
    <#
    .SYNOPSIS
        Create a new Site to Netbox

    .DESCRIPTION
        Create a new Site to Netbox

    .EXAMPLE
        New-NetboxDCIMSite -name MySite

        Add new Site MySite on Netbox

    #>

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Slug,

        [string]$Facility,

        [uint32]$ASN,

        [decimal]$Latitude,

        [decimal]$Longitude,

        [string]$Contact_Name,

        [string]$Contact_Phone,

        [string]$Contact_Email,

        [int]$Group,

        [int]$Tenant,

        [string]$Status,

        [uint32]$Region,

        [string]$Description,
        
        [string]$Physical_Address,

        [string]$Shipping_address,

        [string]$Comments,

        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'sites'))
        $Method = 'POST'

        if (-not $PSBoundParameters.ContainsKey('slug')) {
            $PSBoundParameters.Add('slug', $name)
        }

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        if ($PSCmdlet.ShouldProcess($name, 'Create new Site')) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
}
