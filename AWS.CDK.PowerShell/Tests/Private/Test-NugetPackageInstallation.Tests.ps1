param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

InModuleScope 'AWS.CDK.PowerShell' {
    Describe 'Test-NugetPackageInstallation' {
        BeforeAll {
            $mockPackageName = "AWS.Dummy.CDK"
            $mockPackageVersion = "1.0.0"
            $expectedString = ("Successfully verified package '{0}.{1}'." -f $mockPackageName, $mockPackageVersion)
            $unexpectedString = ("test")
            $funcOutput = @("dummy message", $expectedString)
            $testPath = "TestDrive:\"
        }
        It 'Successfully registered a nuget package source' {
            Mock Invoke-NugetVerify { return $funcOutput } 
            $testPackageInstallationOutput = Test-NugetPackageInstallation -PackagePath $testPath -PackageName $mockPackageName -PackageVersion $mockPackageVersion
            $testPackageInstallationOutput.PackageName | Should -Be $mockPackageName
            $testPackageInstallationOutput.Verified | Should -Be $true
        }
        It 'Successfully registered a nuget package source' {
            Mock Invoke-NugetVerify { return $unexpectedString } 
            $failedPackageInstallationOutput = Test-NugetPackageInstallation -PackagePath $testPath -PackageName $mockPackageName -PackageVersion $mockPackageVersion
            $failedPackageInstallationOutput.PackageName | Should -Be $mockPackageName
            $failedPackageInstallationOutput.Verified | Should -Be $false
        }
    }
}