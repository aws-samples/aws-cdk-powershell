# This is an AWS CDK EC2 app code in PowerShell

param (
    [Parameter(DontShow)]
    [Switch]
    $Test,
    # S3BucketResourceName and CdkStackName parameters can be specified under app in cdk.json
    # "app": "pwsh unittest-app.ps1 -S3BucketResourceName test -CdkStackName test-stack"
    [Parameter()]
    [String]
    $S3BucketResourceName = 'aws-cdk-powershell-s3-bucket',
    [Parameter()]
    [String]
    $CdkStackName = 'aws-cdk-powershell-s3'
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
    [Amazon.CDK.Stack]$stack = New-Object Amazon.CDK.Stack -ArgumentList($App, $Name)
    return [Amazon.CDK.Stack]$stack 
}

function New-CdkS3BucketDefaultProps {
    [OutputType([Amazon.CDK.AWS.S3.BucketProps])]
    param ()
    [Amazon.CDK.AWS.S3.BucketProps]$Props = [Amazon.CDK.AWS.S3.BucketProps]@{
        # Set properties as needed
        # This is the default parameters
        # https://docs.aws.amazon.com/cdk/api/v2/dotnet/api/Amazon.CDK.AWS.S3.BlockPublicAccess.html
        BlockPublicAccess      = [Amazon.CDK.AWS.S3.BlockPublicAccess]::BLOCK_ALL
        Encryption             = [Amazon.CDK.AWS.S3.BucketEncryption]::S3_MANAGED
        ServerAccessLogsPrefix = 'logs'
        Versioned              = $true
    }
    return [Amazon.CDK.AWS.S3.BucketProps]$Props 
}

function New-CdkS3Bucket {
    [OutputType([Amazon.CDK.AWS.S3.Bucket])]
    param (
        [Amazon.CDK.AWS.S3.BucketProps]$Props, 
        [String]$S3BucketResourceName, 
        [Amazon.CDK.Stack]$Stack
    )
    [Amazon.CDK.AWS.S3.Bucket]$s3Bucket = New-Object Amazon.CDK.AWS.S3.Bucket -ArgumentList ($Stack, $S3BucketResourceName, $Props)
    return [Amazon.CDK.AWS.S3.Bucket]$s3Bucket 
}

function main {
    # Use #Require AWS.CDK.PowerShell if you have the module located under $env:PSModulePath 
    Import-Module AWS.CDK.PowerShell

    # Import all the CDK packages
    Import-CdkPackages -CdkDirectory  $PSScriptRoot  
    
    [Amazon.CDK.App]$cdkApp = New-CdkApp
    [Amazon.CDK.Stack]$cdkStack = New-CdkStack -App $cdkApp -Name $CdkStackName
    [Amazon.CDK.AWS.S3.BucketProps]$s3Props = New-CdkS3BucketDefaultProps
    [Amazon.CDK.AWS.S3.Bucket]$s3Bucket = New-CdkS3Bucket -Props $s3Props -S3BucketResourcename $S3BucketResourceName -Stack $cdkStack
    # Call synth() to synthesize a template
    $cdkApp.synth()
}

if (!($Test)) {
    main
}