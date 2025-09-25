provider "aws" {
  assume_role {
    role_arn = var.aws_account_arn
  }
  region  = var.main_aws_region
  profile = var.main_aws_profile
}