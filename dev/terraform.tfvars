terraformer_bucket = ""
main_aws_profile = ""
aws_region="us-east-1"

stage_settings = {
  stage1 = {
    quota_limit = 100
    quota_offset = 2
    quota_period = "WEEK"
    burst_limit = 5
    rate_limit  = 10
    enable_access_log = 0
    logging_level = "INFO"
    data_trace_enabled = false
    metrics_enabled = false
    retention_days = 7
  }
  stage2 = {
    quota_limit = 100
    quota_offset = 2
    quota_period = "WEEK"
    burst_limit = 5
    rate_limit  = 10
    enable_access_log = 1
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
    retention_days = 7
  }
}

lambda_mapper_name = {
  stage1     = "notification-lambda"
  stage2     = "notification-lambda"
}

permissions_boundary_arn = "arn:aws"