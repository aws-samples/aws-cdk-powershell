param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

InModuleScope 'AWS.CDK.PowerShell' {
    Describe 'Register-NugetPackageSource' {
        BeforeAll {
            $packageSourceDefaultName = 'NuGetRepository'
        }
        It 'Successfully registered a nuget package source' {
            Mock Register-PackageSource { return $null }
            $noNugetOutput = Register-NugetPackageSource -Add
            $noNugetOutput.PackageSourceName | Should -Be $packageSourceDefaultName
            $noNugetOutput.Registered | Should -Be $true
        }
        It 'Failed to register a nuget package source' {
            Mock Register-PackageSource { throw  'some error' }
            $noNugetOutput = Register-NugetPackageSource -Add
            $noNugetOutput.PackageSourceName | Should -Be ""
            $noNugetOutput.Registered | Should -Be $false
        }
    }
}