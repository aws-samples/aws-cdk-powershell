# This is an AWS CDK Serverless app code in PowerShell

param (
    [Parameter(DontShow)]
    [Switch]
    $Test,
    # EC2ResourceName, VpcResourceName, and CdkStackName parameters can be specified under app in cdk.json
    # "app": "pwsh unittest-app.ps1 -LambdaResourceName test -RestApiResourceName api-test -CdkStackName test-stack",
    [Parameter()]
    [String]$LambdaResourceName = 'aws-cdk-powershell-lambda',
    [Parameter()]
    [String]$RestApiResourceName = 'aws-cdk-powershell-apigw-restapi',
    [Parameter()]
    [String]$CdkStackName = 'aws-cdk-powershell-serverless'
)

function New-CdkApp {
    [OutputType([Amazon.CDK.App])]
    param ()
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.App.html
    [Amazon.CDK.App]$app = New-Object Amazon.CDK.App -ArgumentList @($null)
    return [Amazon.CDK.App]$app 
    
}

function New-CdkStack {
    [OutputType([Amazon.CDK.Stack])]
    param (
        [Amazon.CDK.App]$App, 
        [String]$Name
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.Stack.html
    [Amazon.CDK.Stack]$stack = New-Object Amazon.CDK.Stack -ArgumentList([Amazon.CDK.App]$App, $Name)
    return [Amazon.CDK.Stack]$stack 
}

function New-CdkLambdaFunctionDefaultProps {
    [OutputType([Amazon.CDK.AWS.Lambda.FunctionProps])]
    param ()
    # https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
    $functionCode = @"
import os
import json
        
def lambda_handler(event, context):
    json_region = os.environ['AWS_REGION']
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": json_region
        })
    }
"@
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.Lambda.FunctionProps.html
    $functionProps = New-Object Amazon.CDK.AWS.Lambda.FunctionProps -Property @{
        # Set properties as needed
        Code = [Amazon.CDK.AWS.Lambda.Code]::FromInline($functionCode)
        Handler = 'index.lambda_handler'
        Runtime = [Amazon.CDK.AWS.Lambda.Runtime]::PYTHON_3_9
    }
    return $functionProps    
}

function New-CdkLambdaFunction {
    [OutputType([Amazon.CDK.AWS.Lambda.Function])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.Stack]$Stack,
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.Lambda.FunctionProps]$LambdaProps,
        [String]$LambdaResourceName = 'aws-cdk-powershell-serverless-lambda'
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.Lambda.Function.html
    $function = New-Object Amazon.CDK.AWS.Lambda.Function -ArgumentList ($Stack, $LambdaResourceName, $LambdaProps)
    return $function
}

function New-CdkRestApiWithLambdaDefaultProps {
    [OutputType([Amazon.CDK.AWS.APIGateway.LambdaRestApiProps])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.Lambda.Function]$LambdaFunction
    )
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.APIGateway.LambdaRestApiProps.html
    $restApiProps = New-Object Amazon.CDK.AWS.APIGateway.LambdaRestApiProps -Property @{
        CloudWatchRole = $false
        EndpointTypes = [Amazon.CDK.AWS.APIGateway.EndpointType]::REGIONAL
        Handler = $LambdaFunction
        Proxy = $true
    }
    return $restApiProps
}

function New-CdkRestApiWithLambda {
    [OutputType([Amazon.CDK.AWS.APIGateway.LambdaRestApi])]
    param (
        [Parameter(Mandatory)]
        [Amazon.CDK.Stack]$Stack,
        [Parameter(Mandatory)]
        [Amazon.CDK.AWS.APIGateway.LambdaRestApiProps]$RestApiProps,
        [String]$RestApiResourceName = 'aws-cdk-powershell-serverless-apigw'
    )
    $restApi = New-Object Amazon.CDK.AWS.APIGateway.LambdaRestApi -ArgumentList ($Stack, $RestApiResourceName, $RestApiProps)
    return $restApi
}


function main {
    # Use #Require AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell

    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory  $PSScriptRoot  
    
    # Create Cdk constructs
    [Amazon.CDK.App]$cdkApp = New-CdkApp
    [Amazon.CDK.Stack]$cdkStack = New-CdkStack -App $cdkApp -Name $CdkStackName
    [Amazon.CDK.AWS.Lambda.FunctionProps]$lambdaProps = New-CdkLambdaFunctionDefaultProps
    [Amazon.CDK.AWS.Lambda.Function]$lambda = New-CdkLambdaFunction -Stack $cdkStack -LambdaProps $lambdaProps -LambdaResourceName $LambdaResourceName
    [Amazon.CDK.AWS.APIGateway.LambdaRestApiProps]$restApiProps = New-CdkRestApiWithLambdaDefaultProps -LambdaFunction $lambda
    [Amazon.CDK.AWS.APIGateway.LambdaRestApi]$restApi = New-CdkRestApiWithLambda -Stack $cdkStack -RestApiProps $restApiProps -RestApiResourceName $RestApiResourceName

    # Call synth() to synthesize a template
    $cdkApp.synth()
}

if (!($Test)) {
    main
}