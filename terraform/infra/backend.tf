terraform {
  backend "s3" {
    region  = "us-west-2"
    bucket  = "terraform-state-backend-us-west-2"
    encrypt = true
    key     = "lambda/lambda-name/terraform.tfstate"
    profile = "interview"
  }
}
