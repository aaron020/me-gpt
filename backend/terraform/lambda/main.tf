provider "aws" {
  region = "eu-west-1"
}

data "aws_lambda_layer_version" "common_layer"{
  layer_name = "chat-app-common-layer"
}

data "aws_lambda_layer_version" "anthropic_layer" {
  layer_name = "anthropic-layer-v7"
}

module "connect_lambda" {
  source = "./module"

  function_name           = "chat-app-connect"
  lambda_output_path      = "${path.module}/build/chat-app-connect.zip"
  lambda_source_dir       = "${path.module}/../../src/connect"
  handler                 = "app.connect"
  s3_key                  = "chat-app-connect.zip"
  lambda_role_name        = "ChatAppConnectLambdaRole"
  runtime                 = "python3.11"
  timeout                 = 300
  memory_size             = 256
  allow_manage_connections  = true
  common_layer_arn        = [data.aws_lambda_layer_version.common_layer.arn]
}

module "disconnect_lambda" {
  source = "./module"

  function_name           = "chat-app-disconnect"
  lambda_output_path      = "${path.module}/build/chat-app-disconnect.zip"
  lambda_source_dir       = "${path.module}/../../src/disconnect"
  handler                 = "app.disconnect"
  s3_key                  = "chat-app-disconnect.zip"
  lambda_role_name        = "ChatAppDisconnectLambdaRole"
  runtime                 = "python3.11"
  timeout                 = 300
  memory_size             = 256
  allow_manage_connections  = true
  common_layer_arn        = [data.aws_lambda_layer_version.common_layer.arn]
}

module "default_lambda" {
  source = "./module"

  function_name           = "chat-app-default"
  lambda_output_path      = "${path.module}/build/chat-app-default.zip"
  lambda_source_dir       = "${path.module}/../../src/default"
  handler                 = "app.default"
  s3_key                  = "chat-app-default.zip"
  lambda_role_name        = "ChatAppDefaultLambdaRole"
  runtime                 = "python3.11"
  timeout                 = 300
  memory_size             = 256
  common_layer_arn        = [data.aws_lambda_layer_version.common_layer.arn]
}

module "send_message_lambda" {
  source = "./module"

  function_name             = "chat-app-send-message"
  lambda_output_path        = "${path.module}/build/chat-app-send-message.zip"
  lambda_source_dir         = "${path.module}/../../src/send-message"
  handler                   = "app.send_message"
  s3_key                    = "chat-app-send-message.zip"
  lambda_role_name          = "ChatAppSendMessageLambdaRole"
  runtime                   = "python3.11"
  timeout                   = 300
  memory_size               = 256
  allow_manage_connections  = true
  allow_access_params       = true
  common_layer_arn          = [data.aws_lambda_layer_version.common_layer.arn, data.aws_lambda_layer_version.anthropic_layer.arn,
                               "arn:aws:lambda:eu-west-1:015030872274:layer:AWS-Parameters-and-Secrets-Lambda-Extension:12"]
}


module "list_chats_lambda" {
  source                    = "./module"
  function_name             = "chat-app-list-chats"
  lambda_output_path        = "${path.module}/build/chat-app-list-chats.zip"
  lambda_source_dir         = "${path.module}/../../src/list-chats"
  handler                   = "app.list_chats"
  s3_key                    = "chat-app-list-chats.zip"
  lambda_role_name          = "ChatAppListChatsLambdaRole"
  runtime                   = "python3.11"
  timeout                   = 300
  memory_size               = 256
  allow_manage_connections  = false
  allow_access_params       = false
  common_layer_arn          = [data.aws_lambda_layer_version.common_layer.arn]
  api_gateway_arn           = "arn:aws:execute-api:eu-west-1:471112781107:ln0ldctvwl/*/*/*"
}