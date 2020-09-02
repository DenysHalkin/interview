module "infra" {
  source = "../_modules/infra"

  lambda_name = var.lambda_name
  common_tags = var.common_tags
}