function Get-NetboxDCIMRegion {
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
        [uint32]$id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$name,

        [Parameter(ParameterSetName = 'Query')]
        [string]$query,

        [Parameter(ParameterSetName = 'Query')]
        [string]$slug,

        [Parameter(ParameterSetName = 'Query')]
        [string]$description,

        [Parameter(ParameterSetName = 'Query')]
        [string]$tag,

        [Parameter(ParameterSetName = 'Query')]
        [string]$parent_id,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$limit,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$offset,

        [switch]$raw
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ById' {
                foreach ($Site_ID in $id) {
                    $Segments = [System.Collections.ArrayList]::new(@('dcim', 'regions', $Site_Id))

                    $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName "Id"

                    $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                    InvokeNetboxRequest -URI $URI -Raw:$Raw
                }
            }

            default {
                $Segments = [System.Collections.ArrayList]::new(@('dcim', 'regions'))

                $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters

                $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                InvokeNetboxRequest -URI $URI -Raw:$Raw
            }
        }
    }
}
