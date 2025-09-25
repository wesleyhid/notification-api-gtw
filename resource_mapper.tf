resource "aws_api_gateway_resource" "aws_lambda_api_mapper_resource" {
  count = var.lambda_mapper_name["stage1"] != "" || var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.aws_lambda_api.id
  parent_id   = aws_api_gateway_rest_api.aws_lambda_api.root_resource_id
  path_part   = "mapper"
}

resource "aws_api_gateway_resource" "aws_lambda_api_mapper_sender_resource" {
  count = var.lambda_mapper_name["stage1"] != "" || var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.aws_lambda_api.id
  parent_id   = aws_api_gateway_resource.aws_lambda_api_mapper_resource[count.index].id
  path_part   = "{sender}"
}

resource "aws_api_gateway_method" "aws_lambda_api_method_for_mapper" {
  count = var.lambda_mapper_name["stage1"] != "" || var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  rest_api_id      = aws_api_gateway_rest_api.aws_lambda_api.id
  resource_id      = aws_api_gateway_resource.aws_lambda_api_mapper_sender_resource[count.index].id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = false
  request_parameters = {
    "method.request.path.sender" = true
  }
}

resource "aws_api_gateway_integration" "aws_lambda_api_integration_mapper" {
  count = var.lambda_mapper_name["stage1"] != "" || var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  rest_api_id             = aws_api_gateway_rest_api.aws_lambda_api.id
  resource_id             = aws_api_gateway_resource.aws_lambda_api_mapper_sender_resource[count.index].id
  http_method             = aws_api_gateway_method.aws_lambda_api_method_for_mapper[count.index].http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.aws_account_arn}:function:$${stageVariables.lambda_mapper_name}:$${stageVariables.lambda_mapper_alias}/invocations"
  request_parameters = {
    "integration.request.path.sender" = "method.request.path.sender"
  }
}

resource "aws_iam_role" "api_gateway_execution_role" {
  count = var.lambda_mapper_name["stage1"] != "" || var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  name = "aws_iam_role_api_gateway_execution_role"
  permissions_boundary = var.permissions_boundary_arn
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigtw_invoke_lambda_stage1" {
  count = var.lambda_mapper_name["stage1"] != "" ? 1 : 0
  name = "aws_iam_role_policy_stage1"
  role = aws_iam_role.api_gateway_execution_role[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "arn:aws:lambda:${var.aws_region}:${var.aws_account_arn}:function:${var.lambda_mapper_name["stage1"]}:${var.lambda_mapper_alias["stage1"]}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigtw_invoke_lambda_stage2" {
  count = var.lambda_mapper_name["stage2"] != "" ? 1 : 0
  name = "aws_iam_role_policy_stage2"
  role = aws_iam_role.api_gateway_execution_role[count.index].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "arn:aws:lambda:${var.aws_region}:${var.aws_account_arn}:function:${var.lambda_mapper_name["stage2"]}:${var.lambda_mapper_alias["stage2"]}"
      }
    ]
  })
}