resource "aws_cloudwatch_log_group" "aws_cloudwatch_log_stage1" {
  name = "aws_cloudwatch_log_stage1"
  retention_in_days = var.stage_settings["stage1"]["retention_days"]
}

resource "aws_cloudwatch_log_group" "aws_cloudwatch_log_stage2" {
  name = "aws_cloudwatch_log_stage2"
  retention_in_days = var.stage_settings["stage2"]["retention_days"]
}

