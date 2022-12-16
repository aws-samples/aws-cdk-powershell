<#
.SYNOPSIS
    Test-NugetPackageInstallation checks if Nuget package is installed properly.
.DESCRIPTION
    Test-NugetPackageInstallation verifies a nuget package.
.EXAMPLE
    Test-NugetPackageInstallation PackagePath . -PackageName -PackageVersion
#>

function Test-NugetPackageInstallation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $PackagePath,
        [Parameter(Mandatory)]
        [String] $PackageName,
        [Parameter(Mandatory)]
        [String] $PackageVersion
    )
    
    begin {
        $output = [PSCustomObject]@{
            PackageName = $PackageName
            Verified = $false
        }
    }
    
    process {
        $packageVerfied = Invoke-NugetVerify -PackagePath $PackagePath
        $packageVerfiedLastMessage = $packageVerfied[-1].ToString()
        $expectedString = ("Successfully verified package '{0}.{1}'." -f $PackageName, $PackageVersion)
        # last line of nuget verify command returns the expected message
        if ($packageVerfiedLastMessage -eq $expectedString)  {
            $output.Verified = $true
        } else {
            Write-Log "Unable to verify a package" -LogLevel ERROR
        }
        return $output
    }
    
    end {
    }
}