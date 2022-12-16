# available template names and file paths
$availableTemplates = [PSCustomObject]@{
    blank = [PSCustomObject]@{
        name = 'Blank'
        script = 'default-app.ps1'
        cdk = 'cdk.json'
        test = 'default-app.Tests.ps1'
    }
    ec2 = [PSCustomObject]@{
        name = 'EC2'
        script = 'ec2-app.ps1'
        cdk = 'cdk.json'
        test = 'ec2-app.Tests.ps1' 
    }
    s3 = [PSCustomObject]@{
        name = 'S3'
        script = 's3-app.ps1'
        cdk = 'cdk.json'
        test = 's3-app.Tests.ps1'
    }
    serverless = [PSCustomObject]@{
        name = 'Serverless'
        script = 'serverless-app.ps1'
        cdk = 'cdk.json'
        test = 'serverless-app.Tests.ps1'
    }
}

# defining the object to store file content
$templatesContent = [PSCustomObject]@{
    blank = [PSCustomObject]@{
        script = ''
        cdk = ''
        test = ''
    }
    ec2 = [PSCustomObject]@{
        script = '' 
        cdk = ''
        test = ''
    }
    s3 = [PSCustomObject]@{
        script = ''
        cdk = ''
        test = ''
    }
    serverless = [PSCustomObject]@{
        script = ''
        cdk = '' 
        test = '' 
    }
}