param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

Describe 'Install-CdkPackage' {
    BeforeAll {
        Mock Install-Package { return $null }
        $testDrive = "TestDrive:\"
    }
    It 'Successfully installs a package' {
        InModuleScope 'AWS.CDK.PowerShell' -Parameters $_ {
            Mock Test-NugetPackageProvider { return @{ Registered = $true } }
            Mock Test-NugetPackageSource { return @{ 
                Registered = $true 
                PackageSourceName = "NuGetRepository" 
            } }
            Mock Test-NugetPackageInstallation { return @{ Verified = $true } }
            $successfulOutput = Install-CdkPackage -CdkDirectory $testDrive -PackageName $packages[0].Name -PackageVersion $packages[0].Version
            $successfulOutput.Installed | Should -Be $true
        }
    }
    It 'Fails to install a package' {
        InModuleScope 'AWS.CDK.PowerShell' -Parameters $_ {
            Mock Test-NugetPackageProvider { return @{ Registered = $true } }
            Mock Test-NugetPackageSource { return @{ Registered = $true } }
            Mock Test-NugetPackageInstallation { return @{ Verified = $true } }
            { Install-CdkPackage -CdkDirectory $testDrive -PackageName 'dummy' -PackageVersion '0.0.0' } | Should -Throw
        }
    }
    It 'Throws an exception when an invalid package directory is passed' {
        { Install-CdkPackage -CdkDirectory 'invalid package root' -PackageName 'dummy' -PackageVersion '0.0.0'} | Should -Throw
    }
}
