resource "aws_api_gateway_stage" "aws_lambda_api_stage" {
  stage_name    = var.stages["stage2"]
  rest_api_id   = aws_api_gateway_rest_api.aws_lambda_api.id
  deployment_id = aws_api_gateway_deployment.aws_lambda_api_deployment.id
  variables = {
    "version"  = var.git_tag
    "lambda_mapper_name" = var.lambda_mapper_name["stage2"]
    "lambda_mapper_alias" = var.lambda_mapper_alias["stage2"]
  }
  depends_on = [aws_api_gateway_deployment.aws_lambda_api_deployment]
  count      = var.enable_stage_2
}

resource "aws_api_gateway_method_settings" "aws_lambda_api_gateway_method_settings2" {
  rest_api_id = aws_api_gateway_rest_api.aws_lambda_api.id
  stage_name  = var.stages["stage2"]
  method_path = "*/*"

  settings {
    metrics_enabled    = var.stage_settings["stage2"]["metrics_enabled"]
    logging_level      = var.stage_settings["stage2"]["logging_level"]
    data_trace_enabled = var.stage_settings["stage2"]["data_trace_enabled"]
  }
  count = var.enable_stage_2
}

resource "aws_api_gateway_usage_plan" "aws_lambda_api_usage_plan_stage2" {
  name = "api-usage-plan-stage2"

  api_stages {
    api_id = aws_api_gateway_rest_api.aws_lambda_api.id
    stage  = var.stages["stage2"]
  }

  quota_settings {
    limit  = var.stage_settings["stage2"]["quota_limit"]
    offset = var.stage_settings["stage2"]["quota_offset"]
    period = var.stage_settings["stage2"]["quota_period"]
  }

  throttle_settings {
    burst_limit = var.stage_settings["stage2"]["burst_limit"]
    rate_limit  = var.stage_settings["stage2"]["rate_limit"]
  }
  count = var.enable_stage_2
}