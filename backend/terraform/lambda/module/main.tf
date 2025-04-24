
// Convert lambda code into a zip file from source_dir
// save the zip file in the output_dir
data "archive_file" "lambda_zip" {
  type = "zip"

  source_dir  = var.lambda_source_dir
  output_path = var.lambda_output_path
}

// Upload lambda zip file to S3 if there is changes
resource "aws_s3_object" "lambda_zip" {
  bucket = var.lambda_deploy_bucket
  key    = var.s3_key
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}

// Create the lambda in aws
resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  s3_bucket        = var.lambda_deploy_bucket
  s3_key           = aws_s3_object.lambda_zip.key
  runtime          = var.runtime
  handler          = var.handler
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  layers = var.common_layer_arn

  environment {
    variables = var.environment_variables
  }

  timeout     = var.timeout
  memory_size = var.memory_size

  # lifecycle {
  #   replace_triggered_by = [var.common_layer_arn[0]]
  # }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Created in ../iam
data "aws_iam_policy" "dynamo_db_policy"{
  name = "LambdaUseDatabase"
}

#Created in ../iam
data "aws_iam_policy" "manage_connections_policy"{
  name = "LambdaManageConnections"
}

#Created in ../iam
data "aws_iam_policy" "access_params" {
  name = "LambdaAccessParams"
}

resource "aws_iam_role_policy_attachment" "lambda_additional_policies" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = data.aws_iam_policy.dynamo_db_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_manage_connections" {
  count = var.allow_manage_connections ? 1 : 0
  role       = aws_iam_role.lambda_exec.name
  policy_arn = data.aws_iam_policy.manage_connections_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_access_params" {
    count = var.allow_access_params ? 1 : 0
    role  = aws_iam_role.lambda_exec.name
    policy_arn = data.aws_iam_policy.access_params.arn
}

resource "aws_lambda_permission" "allow_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_arn
}



