# Terraform S3 Backend Bootstrap

This project bootstraps AWS infrastructure for remote Terraform state management, creating an S3 bucket for state storage and a DynamoDB table for state locking.

## Overview

When working with Terraform in a team environment or across multiple environments, it's recommended to store the Terraform state remotely rather than in local files. This project helps you set up the necessary AWS infrastructure:

- S3 bucket with:
  - Versioning enabled
  - Server-side encryption (AES-256)
  - Public access blocked
  - Bucket ownership controls
- DynamoDB table for state locking

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- AWS CLI configured with appropriate credentials
- AWS permissions to create S3 buckets and DynamoDB tables

## Configuration

Copy the example variables file and modify it according to your needs:

```bash
cp backend.auto.tfvars.example backend.auto.tfvars
```

Edit `backend.auto.tfvars`:

```hcl
aws_region     = "eu-west-1"          # AWS region to deploy resources
aws_profile    = "default"            # AWS CLI profile to use
s3_bucket_name = "my-terraform-state" # Name of the S3 bucket (must be globally unique)
tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
}
```

## Deployment

Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Using the Remote Backend

After creating the S3 bucket and DynamoDB table, you can configure other Terraform projects to use this backend. Add the following to your Terraform configurations:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-bucket-name" # Output: s3_bucket_name
    key            = "path/to/terraform.tfstate"
    region         = "eu-west-1"        # Your AWS region
    dynamodb_table = "terraform-state-lock" # Output: dynamodb_table_name
    encrypt        = true
    profile        = "your-aws-profile" # Optional
  }
}
```

## Security Considerations

- The S3 bucket has versioning enabled to protect against accidental state deletion
- Server-side encryption is enabled to protect sensitive data in the state file
- Public access to the bucket is completely blocked
- The DynamoDB table prevents concurrent state modifications

## Outputs

- `s3_bucket_name`: Name of the created S3 bucket
- `dynamodb_table_name`: Name of the created DynamoDB table

## Cleanup

To remove all resources created by this project, run:

```bash
terraform destroy
```

**Note:** The S3 bucket has `prevent_destroy = true` set to protect against accidental deletion. You'll need to remove this lifecycle policy in `main.tf` if you truly want to destroy the bucket.
