resource "aws_api_gateway_rest_api" "aws_lambda_api" {
  name        = "api_gateway_for_lambda"
  description = "AWS API Gateway for Lambda functions"
}

