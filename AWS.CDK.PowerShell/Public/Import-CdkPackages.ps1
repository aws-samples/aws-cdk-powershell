<#
.SYNOPSIS
    Import-CdkPackages imports assembly dependencies for AWS CDK v2. 
.DESCRIPTION
    Import-CdkPackages imports assembly files located under the packages (default name) directory located at -CdkDirectory. 
    In order to use AWS CDK constructs, it is required to import AWS.CDK.Lib and its dependencies. 
    Impoprt-CdkPackages simplifies the import process. 
.EXAMPLE
    Import-CdkPackages -CdkDirectory C:\Users\test\sample-app
#>

function Import-CdkPackages {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
            if(Test-Path $_){
                $true
            } else {
                throw "Path $_ is not valid"
            }})
        ]
        [String]$CdkDirectory,
        [Parameter(DontShow)]
        [String]$DependencyDirectoryName = "packages",
        [Parameter(DontShow)]
        [PSCustomObject[]]$TargetPackages = $packages
    )
    
    begin {
        # Resolving a relative path to the absolute path
        Write-Verbose ("Resolving {0} to an absolute path" -f $CdkDirectory)
        $CdkDirectory = (Resolve-Path $CdkDirectory).Path
        Write-Verbose ("Absolute path for the pacakge directory {0}" -f $CdkDirectory)
    }
    
    process {
        foreach ($package in $TargetPackages) {
            $childPath = ("{0}/{1}.{2}/lib/{3}/{4}.dll" -f $DependencyDirectoryName, $package.Name, $package.Version, $package.Framework, $package.Name)
            Write-Log ("Importing {0}" -f $childPath)
            $assemblyPath = Join-Path -Path $CdkDirectory -ChildPath $childPath 
            try {
                Add-Type -Path $assemblyPath
            } catch {
                throw ("Unable to load {0} `Error: {1}" -f $assemblyPath, $_.ErrorDetails)
            }
        }
    }
    
    end {
    }
}