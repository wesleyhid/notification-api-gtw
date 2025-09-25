variable "terraformer_bucket" {
}

variable "aws_region" {
}

variable "aws_account_arn" {
}

variable "stages" {
  default = {
    stage1 = "dev"
    stage2 = "prod"
  }
}

variable "stage_settings" {
  default = {
    stage1 = {
      quota_limit          = 100
      quota_offset         = 2
      quota_period         = "WEEK"
      burst_limit          = 5
      rate_limit           = 10
      enable_access_log    = 0
      logging_level        = "INFO"
      data_trace_enabled   = false
      metrics_enabled      = false
      retention_days       = 7
    }
    stage2 = {
      quota_limit          = 100
      quota_offset         = 2
      quota_period         = "WEEK"
      burst_limit          = 5
      rate_limit           = 10
      enable_access_log    = 1
      logging_level        = "INFO"
      data_trace_enabled   = true
      metrics_enabled      = true
      retention_days       = 7
    }
  }
}

variable "git_tag" {
}

variable "enable_stage_2" {
  default = 0
}

variable "main_aws_region" {
  default = ""
}

variable "main_aws_profile" {
  default = ""
}

variable "lambda_mapper_name" {
  default = {
    stage1 = ""
    stage2 = ""
  }
}

variable "lambda_mapper_alias" {
  default = {
    stage1 = "stable"
    stage2 = "stable"
  }
}

variable "permissions_boundary_arn" {default = ""}