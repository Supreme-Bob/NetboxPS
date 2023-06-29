function New-NetboxDCIMRegion {
    <#
    .SYNOPSIS
        Create a new Region to Netbox

    .DESCRIPTION
        Create a new Region to Netbox

    .EXAMPLE
        New-NetboxDCIMRegion -name MyRegion

        Add new Region MyRegion on Netbox

    #>

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$name,

        [string]$slug,

        [int]$parent,

        [string]$description,

        [uint16[]]$tags,
        
        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'regions'))
        $Method = 'POST'

        if (-not $PSBoundParameters.ContainsKey('slug')) {
            $PSBoundParameters.Add('slug', $name)
        }

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        if ($PSCmdlet.ShouldProcess($name, 'Create new Region')) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
}