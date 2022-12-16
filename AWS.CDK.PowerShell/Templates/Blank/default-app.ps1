# This is a default blank AWS CDK app code in PowerShell

param (
    [Parameter(DontShow)]
    [Switch]
    $Test,
    # CdkStackName parameter can be specified under app in cdk.json
    # "app": "pwsh unittest-app.ps1 -CdkStackName test-stack"
    [Parameter()]
    [String]$CdkStackName = 'aws-cdk-powershell'
)

function New-CdkApp {
    [OutputType([Amazon.CDK.App])]
    param ()
    # Instantiating an object for CDK props, CDK and Stack to create a plain CloudFormation template
    # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AppProps.html
    # Use props and pass it to the Amazon.CDK.App constructor if you need to override settings
    # $props = New-Object Amazon.CDK.AppProps
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

function main {
    # Use #Require AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell

    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory  $PSScriptRoot  
    
    [Amazon.CDK.App]$cdkApp = New-CdkApp
    [Amazon.CDK.Stack]$cdkStack = New-CdkStack -App $cdkApp -Name $CdkStackName

    # Call synth() to synthesize a template
    $cdkApp.synth()
}

if (!($Test)) {
    main
}