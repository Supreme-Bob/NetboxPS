function New-NetboxDCIMSiteGroup {
    <#
    .SYNOPSIS
        Create a new Site Group to Netbox

    .DESCRIPTION
        Create a new Site Group to Netbox

    .EXAMPLE
        New-NetboxDCIMSiteGroup -name MyGroup

        Add new Site Group MyGroup on Netbox

    #>

    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Slug,

        [int]$Parent,

        [string]$Description,

        [uint16[]]$Tags,

        [switch]$Raw
    )

    process {
        $Segments = [System.Collections.ArrayList]::new(@('dcim', 'site-groups'))
        $Method = 'POST'

        if (-not $PSBoundParameters.ContainsKey('slug')) {
            $PSBoundParameters.Add('slug', $name)
        }

        $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters

        $URI = BuildNewURI -Segments $URIComponents.Segments

        if ($PSCmdlet.ShouldProcess($name, 'Create new Site Group')) {
            InvokeNetboxRequest -URI $URI -Method $Method -Body $URIComponents.Parameters -Raw:$Raw
        }
    }
}