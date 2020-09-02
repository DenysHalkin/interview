variable "lambda_name" {
  default = {
    lambda = {
      s3_repo       = "lambda-us-west-2"
      s3_key        = "lambda_name/lambda_name_latest.zip"
      handler       = "lambda-name::lambda_name.Bootstrap::ExecuteFunction"
      memory_size   = 256
      timeout       = 120
      publish       = true
      runtime       = "dotnetcore3.1"
      log_retention = 7
    }
    env_variables = {
      s3_bucket_name = "lambda-name-s3-interview"
    }
  }
}

variable "aws_region" {
  default = "us-west-2"
}

variable "common_tags" {
  default = {
    Project = "Interview"
    Owner   = "Denys Halkin"
  }
}