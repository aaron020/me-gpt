provider "aws" {
  region = "eu-west-1"
}

# Get Lambda ARNs using data sources
data "aws_lambda_function" "connect" {
  function_name = "chat-app-connect"
}

data "aws_lambda_function" "disconnect" {
  function_name = "chat-app-disconnect"
}

data "aws_lambda_function" "default" {
  function_name = "chat-app-default"
}

data "aws_lambda_function" "send_message" {
  function_name = "chat-app-send-message"
}

module "websocket_api" {
  source = "./module"
  
  connect_lambda_invoke_arn       = data.aws_lambda_function.connect.invoke_arn
  disconnect_lambda_invoke_arn    = data.aws_lambda_function.disconnect.invoke_arn
  default_lambda_invoke_arn       = data.aws_lambda_function.default.invoke_arn
  send_message_lambda_invoke_arn  = data.aws_lambda_function.send_message.invoke_arn
}

# Expose outputs from the module
output "api_id" {
  description = "The API identifier"
  value       = module.websocket_api.api_id
}

output "api_endpoint" {
  description = "The WebSocket API endpoint"
  value       = module.websocket_api.api_endpoint
}

output "execution_arn" {
  description = "The ARN prefix to be used in lambda permissions"
  value       = module.websocket_api.execution_arn
}