resource "aws_api_gateway_deployment" "aws_lambda_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.aws_lambda_api.id
  stage_name  = var.stages["stage1"]

  variables = {
    "version"  = var.git_tag
    "lambda_mapper_name" = var.lambda_mapper_name["stage1"]
    "lambda_mapper_alias" = var.lambda_mapper_alias["stage1"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_settings" "aws_lambda_api_gateway_method_settings1" {
  rest_api_id = aws_api_gateway_rest_api.aws_lambda_api.id
  stage_name  = var.stages["stage1"]
  method_path = "*/*"

  settings {
    metrics_enabled    = var.stage_settings["stage1"]["metrics_enabled"]
    logging_level      = var.stage_settings["stage1"]["logging_level"]
    data_trace_enabled = var.stage_settings["stage1"]["data_trace_enabled"]
  }
}

resource "aws_api_gateway_usage_plan" "aws_lambda_api_usage_plan_stage1" {
  name = "api-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.aws_lambda_api.id
    stage  = var.stages["stage1"]
  }

  quota_settings {
    limit  = var.stage_settings["stage1"]["quota_limit"]
    offset = var.stage_settings["stage1"]["quota_offset"]
    period = var.stage_settings["stage1"]["quota_period"]
  }

  throttle_settings {
    burst_limit = var.stage_settings["stage1"]["burst_limit"]
    rate_limit  = var.stage_settings["stage1"]["rate_limit"]
  }
}
