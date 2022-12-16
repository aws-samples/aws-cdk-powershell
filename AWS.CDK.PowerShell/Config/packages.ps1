# packages.ps1 contains a list of dependencies for Amazon CDK in PowerShell packages. 
@(
    [PSCustomObject]@{
        # https://www.nuget.org/packages/Amazon.CDK.Lib
        'Name' = 'Amazon.CDK.Lib'
        'Version' = '2.55.1'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.AwsCliV1'
        'Version' = '2.2.30'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.KubectlV20'
        'Version' = '2.1.1'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.CDK.Asset.NodeProxyAgentV5'
        'Version' = '2.0.38'
        'Framework' = 'netcoreapp3.1'
    },
    [PSCustomObject]@{
        'Name' = 'Amazon.JSII.Runtime'
        'Version' = '1.72.0'
        'Framework' = 'netcoreapp3.1'
    }
    [PSCustomObject]@{
        'Name' = 'Constructs'
        'Version' = '10.1.78'
        'Framework' = 'netcoreapp3.1'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.DependencyInjection'
        'Version' = '7.0.0'
        'Framework' = 'netstandard2.1'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.DependencyInjection.Abstractions'
        'Version' = '7.0.0'
        'Framework' = 'netstandard2.1'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.1'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Abstractions'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Console'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Newtonsoft.Json'
        'Version' = '13.0.2'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Options'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Logging.Configuration'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Options.ConfigurationExtensions'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Primitives'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration.Abstractions'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
    [PSCustomObject]@{
        'Name' = 'Microsoft.Extensions.Configuration.Binder'
        'Version' = '6.0.0'
        'Framework' = 'netstandard2.0'
    }
)
