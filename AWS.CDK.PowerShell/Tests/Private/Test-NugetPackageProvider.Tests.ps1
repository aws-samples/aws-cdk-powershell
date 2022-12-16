param (
    [Parameter()]
    [String]
    $ModulePath
)

BeforeAll {
    Import-Module $ModulePath
}

InModuleScope 'AWS.CDK.PowerShell' {
    Describe 'Test-NugetPackageProvider' {
        BeforeAll {
            $noNugetExpectedOutput = [PSCustomObject]@{
                Provider   = "Nuget"
                Registered = $false
            }
            $noNugetRegisterExpectedOutput = [PSCustomObject]@{
                Provider   = "Nuget"
                Registered = $false
            }
            $nugetFoundExpectedOutput = [PSCustomObject]@{
                Provider   = "Nuget"
                Registered = $true
            }
        }
        It 'No nuget provider found in package provider list' {
            Mock Get-PackageProvider { return $null }
            $noNugetOutput = Test-NugetPackageProvider
            $noNugetOutput.Provider | Should -Be $noNugetExpectedOutput.Provider
            $noNugetOutput.Registered | Should -Be $noNugetExpectedOutput.Registered
        }
        It 'No nuget provider found in package provider list and register nuget' {
            Mock Get-PackageProvider { return $null }
            $noNugetRegisterOutput = Test-NugetPackageProvider
            $noNugetRegisterOutput.Provider | Should -Be $noNugetRegisterExpectedOutput.Provider
            $noNugetRegisterOutput.Registered | Should -Be $noNugetRegisterExpectedOutput.Registered
        }
        It 'Nuget found in package provider list' {
            Mock Get-PackageProvider { return @{
                Name    = 'NuGet'
                Version = 3.0.0.1
                # DynamicOption not mocked because this is not testing NuGet package commands
            } }
            $nugetFoundOutput = Test-NugetPackageProvider
            $nugetFoundOutput.Provider | Should -Be $nugetFoundExpectedOutput.Provider
            $nugetFoundOutput.Registered | Should -Be $nugetFoundExpectedOutput.Registered
        }
    }
}