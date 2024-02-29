# packages.ps1 contains a list of dependencies for Amazon CDK in PowerShell packages. 
@(
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Lib'
        'Version' = '2.130.0'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.AwsCliV1'
        'Version' = '2.2.202'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.KubectlV20'
        'Version' = '2.1.2'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.NodeProxyAgentV6'
        'Version' = '2.0.1'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.JSII.Runtime'
        'Version' = '1.94.0'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Constructs'
        'Version' = '10.3.0'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.DependencyInjection'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.1'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.DependencyInjection.Abstractions'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.1'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.1'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Abstractions'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Console'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Newtonsoft.Json'
        'Version' = '13.0.2'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Options'
        'Version' = '8.0.2'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Configuration'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Options.ConfigurationExtensions'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Primitives'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration.Abstractions'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration'
        'Version' = '8.0.0'
        'Framework' = 'netstandard2.0'
    },
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration.Binder'
        'Version' = '8.0.1'
        'Framework' = 'netstandard2.0'
    }
)
