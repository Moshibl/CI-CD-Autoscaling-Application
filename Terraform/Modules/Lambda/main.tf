resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "trigger_jenkins" {
  function_name = "trigger_jenkins_pipeline"
  handler       = "trigger_jenkins.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10

  environment {
    variables = {
      JENKINS_URL = var.jenkins_url
    }
  }

  s3_bucket = var.lambda_bucket
  s3_key    = "lambda.zip"
}

# --------------------------------------------------
# EventBridgeRule
# --------------------------------------------------

resource "aws_cloudwatch_event_rule" "asg_launch_event" {
  name        = "ASG_Instance_Launch"
  description = "Trigger Lambda on ASG instance launch"
  event_pattern = jsonencode({
    source      = ["aws.autoscaling"],
    "detail-type" = ["EC2 Instance Launch Successful"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.asg_launch_event.name
  target_id = "TriggerJenkins"
  arn       = aws_lambda_function.trigger_jenkins.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger_jenkins.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.asg_launch_event.arn
}

