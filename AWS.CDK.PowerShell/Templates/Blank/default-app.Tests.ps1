#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }

BeforeAll {
    # Use #Requires AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell
    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory $PSScriptRoot

    # Dot source the app file
    . .\default-app.ps1
}
# This unit test uses Pester for testing framework and Amazon.CDK.Assertions to assert against CDK applications.
# https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.html
# https://docs.aws.amazon.com/cdk/v2/guide/testing.html
Describe "AWS CDK EC2 App" {
    Context 'New-CdkApp' {
        It 'Returns an Amazon.CDK.App object' {
            $testApp = New-CdkApp
            $testApp | Should -BeOfType ([Amazon.CDK.App])
        }
    }
    Context 'New-CdkStack' {
        It 'Returns an Amazon.CDK.Stack object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $testStack | Should -BeOfType ([Amazon.CDK.Stack])
        }
    }
}