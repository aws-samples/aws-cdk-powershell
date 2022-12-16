#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }

<#
.SYNOPSIS
    Invoke-CdkPesterTests invokes all the Pester tests under a specified test path
.DESCRIPTION
    Invoke-CdkPesterTests is used to run all the unit tests for the AWS.CDK.PowerShell module. 
.EXAMPLE
    Invoke-CdkPesterTests -ModulePath $env:PSModulePath\AWS.CDK.PowerShell -TestPath $env:PSModulePath\AWS.CDK.PowerShell\Tests
    This runs all the tests available under $env:PSModulePath\AWS.CDK.PowerShell\Tests directory.
#>

param (
    [Parameter(Mandatory)]
    [ValidateScript({
        if(Test-Path $_){
            $true
        } else {
            throw "Path $_ is not valid"
        }})
    ]
    [String]
    $ModulePath,
    [Parameter(Mandatory)]
    [ValidateScript({
        if(Test-Path $_){
            $true
        } else {
            throw "Path $_ is not valid"
        }})
    ]
    [String]
    $TestPath
)

$configuration = New-PesterConfiguration
$configuration.CodeCoverage.Enabled = $true
$modulePsFiles = Get-ChildItem (Join-Path -Path $ModulePath -ChildPath Private), (Join-Path -Path $ModulePath -ChildPath Public) -File -Recurse -Include *.ps1
$configuration.CodeCoverage.Path = $modulePsFiles 
$configuration.Run.Path = $TestPath
$container = New-PesterContainer -Path $TestPath -Data @{ 'ModulePath' = $ModulePath }
$configuration.Run.Container = $container

Invoke-Pester -Configuration $configuration