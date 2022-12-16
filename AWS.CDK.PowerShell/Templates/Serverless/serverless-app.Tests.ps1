#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0" }

BeforeAll {
    # Use #Requires AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell
    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory $PSScriptRoot

    # Dot source the app file
    . .\serverless-app.ps1
}
# This unit test uses Pester for testing framework and Amazon.CDK.Assertions to assert against CDK applications.
# https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.html
# https://docs.aws.amazon.com/cdk/v2/guide/testing.html
Describe "AWS CDK Serverless App" {
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
    Context 'New-CdkLambdaFunctionDefaultProps' {
        It 'Returns an Amazon.CDK.AWS.Lambda.FunctionProps object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $lambdaProps = New-CdkLambdaFunctionDefaultProps
            $lambdaProps | Should -BeOfType ([Amazon.CDK.AWS.Lambda.FunctionProps])
        }
    }
    Context "New-CdkLambdaFunction" {
        BeforeAll {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $lambdaProps = New-CdkLambdaFunctionDefaultProps
            $lambda = New-CdkLambdaFunction -Stack $testStack -LambdaProps $lambdaProps -LambdaResourceName 'test-function'
            $template = [Amazon.CDK.Assertions.Template]::FromStack($testStack)
        }
        It 'Has AWS::Lambda::Function resource with default settings' {
            # Lambda test
            $lambdaTestProps = New-Object "System.Collections.Generic.Dictionary[String,Object]"

            # Checking Handler and Runtime properties
            $lambdaTestProps.Add("Handler", "index.lambda_handler")
            $lambdaTestProps.Add("Runtime", "python3.9")

            # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Assertions.Template.html#Amazon_CDK_Assertions_Template_HasResourceProperties_System_String_System_Object_
            $template.HasResourceProperties('AWS::Lambda::Function', $lambdaTestProps)
        }
        It 'Has 1 AWS::Lambda::Function resource' {
            $template.ResourceCountIs('AWS::Lambda::Function', 1)
        }
    }
    Context "New-CdkRestApiWithLambdaDefaultProps" {
        It 'Returns an Amazon.CDK.AWS.APIGateway.LambdaRestApiProps object' {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $lambdaProps = New-CdkLambdaFunctionDefaultProps
            $lambda = New-CdkLambdaFunction -Stack $testStack -LambdaProps $lambdaProps -LambdaResourceName 'test-function'
            $apiProps = New-CdkRestApiWithLambdaDefaultProps -LambdaFunction $lambda
            $apiProps | Should -BeOfType ([Amazon.CDK.AWS.APIGateway.LambdaRestApiProps])
        }
    }
    Context "New-CdkRestApiWithLambda" {
        BeforeAll {
            $testApp = New-CdkApp
            $testStack = New-CdkStack -App $testApp -Name 'test-stack'
            $lambdaProps = New-CdkLambdaFunctionDefaultProps
            $lambda = New-CdkLambdaFunction -Stack $testStack -LambdaProps $lambdaProps -LambdaResourceName 'test-function'
            $restApiProps = New-CdkRestApiWithLambdaDefaultProps -LambdaFunction $lambda
            $restApi = New-CdkRestApiWithLambda -Stack $testStack -RestApiProps $restApiProps -RestApiResourceName 'test-restapi'
            $template = [Amazon.CDK.Assertions.Template]::FromStack($testStack)
        }
        It 'has 1 AWS::ApiGateway::RestApi resource' {
            $template.ResourceCountIs('AWS::ApiGateway::RestApi', 1)
        }
    }
}