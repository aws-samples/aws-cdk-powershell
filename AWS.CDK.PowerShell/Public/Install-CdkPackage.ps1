<#
.SYNOPSIS
    Install-CdkPackage installs AWS.CDK.Lib and its dependencies from Nuget.
.DESCRIPTION
    Install-CdkPackage uses Nuget as a package provider to install AWS.CDK.Lib and its dependencies under the -CdkDirectory.

.EXAMPLE
    Install-CdkPackage -CdkDirectory C:\Users\test\sample-app
    # This creates a packages directory under the package directory and 
#>

function Install-CdkPackage {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({
                if (Test-Path $_) {
                    $true
                }
                else {
                    throw "Path $_ is not valid"
                } })
        ]
        [String]$CdkDirectory,
        [Parameter(Mandatory)]
        [String]$PackageName, 
        [Parameter(Mandatory)]
        [String]$PackageVersion
    )
    
    begin {
        $nugetPackageProvider = Test-NugetPackageProvider
        $nugetPackageSource = Test-NugetPackageSource
        $CdkDirectory = (Resolve-Path $CdkDirectory).Path
        $packagesDir = Join-Path -Path $CdkDirectory -ChildPath packages
        if ($nugetPackageProvider.Registered -eq $false) {
            Write-Log 'Nuget package proivder not found' -LogLevel 'ERROR'
        }
        if ($nugetPackageSource.Registered -eq $false) {
            Write-Log 'Nuget package source not found' -LogLevel 'ERROR'
            $packageSourceRegistered = Register-NugetPackageSource
            if (!($packageSourceRegistered.Registered)) {
                Write-Log 'Nuget package source must be registered to proceed' -LogLevel 'ERROR'
            } else {
                $nugetPackageSource = Test-NugetPackageSource
            }
        }
        $output = [PSCustomObject]@{
            Package = $PackageName
            Installed = $false
        }
    }
    process {
        $installPackageArgs = @{
            Name = $PackageName
            RequiredVersion = $PackageVersion
            Scope = "CurrentUser"
            SkipDependencies = $true
            Destination = $packagesDir
            Source = $nugetPackageSource.PackageSourceName
            Force = $true
            Erroraction = "STOP"
        }
        Install-Package @installPackageArgs -OutVariable installPackageResponse | Out-Null
        # Validate the package installation
        $packageInstallationPath = ((Join-Path -Path $packagesDir -ChildPath ("{0}.{1}" -f $PackageName, $PackageVersion)))
        if ($IsWindows) {
            $packageVerified = Test-NugetPackageInstallation -PackagePath $packageInstallationPath -PackageName $PackageName -PackageVersion $PackageVersion
            if ($packageVerified.Verified -eq $true) {
                Write-Log ("Successfully installed the CDK package {0} under {1}" -f $PackageName, $packagesDir)
                $output.Installed = $true 
            } else {
                Write-Log ("Failed to installed the CDK package {0} under {1}" -f $PackageName, $packagesDir) -LogLevel ERROR
                # throwing an exception to stop installing packages
                throw "PackageInstallationError"
            }
        } else {
            # https://github.com/dotnet/core/issues/7688
            # On linux, nuget package verification is not supported without opt-in. 
            # ErrorAction is set as STOP for Install-Package so package installation should be successful. 
            # Setting Installed as true for Linux/MacOS.
            $output.Installed = $true
        }
        return $output
    }
    end {
    }
}