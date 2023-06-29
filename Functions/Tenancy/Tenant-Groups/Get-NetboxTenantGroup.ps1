function Get-NetboxTenantGroup {
    [CmdletBinding(DefaultParameterSetName = 'Query')]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
        [uint32]$id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$name,

        [Parameter(ParameterSetName = 'Query')]
        [string]$Query,

        [Parameter(ParameterSetName = 'Query')]
        [string]$slug,

        [Parameter(ParameterSetName = 'Query')]
        [string]$description,

        [Parameter(ParameterSetName = 'Query')]
        [string]$tag,

        [Parameter(ParameterSetName = 'Query')]
        [string]$parent_id,

        [Parameter(ParameterSetName = 'Query')]
        [string]$parent,

        [Parameter(ParameterSetName = 'Query')]
        [string]$created,

        [Parameter(ParameterSetName = 'Query')]
        [string]$last_updated,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$Limit,

        [Parameter(ParameterSetName = 'Query')]
        [uint16]$Offset,

        [switch]$Raw
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ById' {
                foreach ($Site_ID in $ID) {
                    $Segments = [System.Collections.ArrayList]::new(@('tenancy', 'tenant-groups', $Site_Id))

                    $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName "Id"

                    $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                    InvokeNetboxRequest -URI $URI -Raw:$Raw
                }
            }

            default {
                $Segments = [System.Collections.ArrayList]::new(@('tenancy', 'tenant-groups'))

                $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters

                $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

                InvokeNetboxRequest -URI $URI -Raw:$Raw
            }
        }
    }
}
