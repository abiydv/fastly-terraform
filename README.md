
# Terraform Fastly Module
![terraform](https://github.com/abiydv/ref-docs/blob/master/images/logos/terraform_small.png)
![fastly](https://github.com/abiydv/ref-docs/blob/master/images/logos/fastly_small.png)
![s3](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-s3_small.png)
![ssm](https://github.com/abiydv/ref-docs/blob/master/images/logos/aws-ssm_small.png)

Use this Terraform module to create Fastly services with multiple backends, domains, dictionaries, ACLs, VCL snippets etc.

## Pre-requisites

Functionality in this module assumes the following

1. Use of S3 as the remote backend to save the state info (bucket-name : base-bucket) 

2. Use of AWS SSM paramater store to fetch S3 credentials for log streaming (bucket name & region: configurable as variable)

3. Terraform version 0.12 & above

## Features

1. Supports all VCL snippets - recv, fetch, hit, error, deliver

2. Supports multiple domains, origins

3. Supports multiple ACLs & adding entries to them

4. Supports multiple edge dictionaries - can be used in VCLs

5. Supports S3 log streaming 

## How to use

1. Duplicate the `example-service` directory and modify the values to create Fastly services

2. Export your AWS credentials and Fastly API keys
```
export FASTLY_API_KEY=xxxxxxxxx
export AWS_PROFILE=xxxxxxxxx
```

3. Initialize and execute Terraform
```
terraform init
terraform plan
terraform apply
```

4. Destroy the setup (if needed)
```
terraform destroy
```
