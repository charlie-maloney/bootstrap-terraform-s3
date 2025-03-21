variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
}
variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
