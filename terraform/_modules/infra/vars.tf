variable "lambda_name" {
  type = object({
    lambda = object({
      s3_repo       = string #The bucket name that contains Lambda source code
      s3_key        = string #The path to the source code in S3 bucket
      handler       = string #The entrypoint in code
      memory_size   = string #Amount of memory in Lambda function [MB]
      timeout       = string #The amount of time Lambda function has to run [seconds]
      publish       = string #Whether to publish creation/change as new Lambda function version
      runtime       = string #The runtime environment for the Lambda function
      log_retention = string #The number of time to retain AWS Lambda logs in CloudWatch Logs (in Days)
    })
    env_variables = object({
      s3_bucket_name   = string
    })
  })
}

variable "common_tags" {
  type = map(string)
}