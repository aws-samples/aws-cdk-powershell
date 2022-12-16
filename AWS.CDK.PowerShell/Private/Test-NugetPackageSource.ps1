<#
.SYNOPSIS
    Test-NugetPackageSource checks if Nuget package source is added to the list of package sources.
.DESCRIPTION
    Test-NugetPackageSource calls Get-PackgeSource to check if Nuget is added to the package source list. 
    Nuget is required to install CDK packages.
.EXAMPLE
    Test-NugetPackageSource
    # This tests if Nuget package source exists in package source list. 
#>

function Test-NugetPackageSource {
    [CmdletBinding()]
    param ()
    
    begin {
        $output = [PSCustomObject]@{
            PackageSourceName = ""
            Registered = $false
        }
    }
    
    process {
        # Check if a package source with a Nuget API endpoint location is found 
        $nugetPackageSourceExist = Get-PackageSource | Where-Object{$_.Location -eq $nugetSourceUri}
        if ($null -ne $nugetPackageSourceExist)  {
            $output.Registered = $true
            $output.PackageSourceName = $nugetPackageSourceExist.Name
        } 
        return $output
    }
    
    end {
    }
}