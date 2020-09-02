#Create a role for Lambda function
resource "aws_iam_role" "lambda" {
  name               = "lambda-role"
  description        = "AWS IAM Role for Lambda function"
  assume_role_policy = file("${path.module}/files/policies/role.json")

  tags = merge(
    var.common_tags,
    {
      "Name" = "lambda-role"
    }
  )
}

#Get policy for Lambda function
resource "aws_iam_policy" "lambda" {
  name        = "lambda-policy"
  description = "IAM Policy for Lambda function"

  policy = templatefile("${path.module}/files/policies/lambda-policy.json", {
    s3_bucket_name    = var.lambda_name.env_variables.s3_bucket_name
  })
}

#Attach policy to the role for Lambda function
resource "aws_iam_policy_attachment" "lambda" {
  name       = "lambda-policy-attachment"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.lambda.arn
}

#Get file that contains the hash of source code
data "aws_s3_bucket_object" "lambda_hash" {
  bucket = var.lambda_name.lambda.s3_repo
  key    = "${var.lambda_name.lambda.s3_key}.base64Hash"
}

#Create Lambda function
resource "aws_lambda_function" "lambda" {
  function_name    = "lambda-name"
  description      = "Lambda function Description"
  s3_bucket        = var.lambda_name.lambda.s3_repo
  s3_key           = var.lambda_name.lambda.s3_key
  memory_size      = var.lambda_name.lambda.memory_size
  timeout          = var.lambda_name.lambda.timeout
  handler          = var.lambda_name.lambda.handler
  role             = aws_iam_role.lambda.arn
  runtime          = var.lambda_name.lambda.runtime
  source_code_hash = data.aws_s3_bucket_object.lambda_hash.body
  publish          = var.lambda_name.lambda.publish

  environment {
    variables = {
      S3_BUCKET_NAME = var.lambda_name.env_variables.s3_bucket_name
    }
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "lambda-name"
    }
  )
}

#Configure CloudWatch log group for Lambda function
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.lambda_name.lambda.log_retention

  tags = merge(
    var.common_tags,
    {
      "Name" = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
    }
  )
}

#Create event rule for Lambda
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "lambda-schedule"
  description         = "Fires at 12:30PM every Monday and Tuesday"
  schedule_expression = "cron(30 12 ? * Mon,Tue *)"
}

resource "aws_cloudwatch_event_target" "schedule" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "lambda-name-check"
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}