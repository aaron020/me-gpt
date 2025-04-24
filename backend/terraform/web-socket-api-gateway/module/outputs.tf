output "api_id" {
  description = "The API identifier"
  value       = aws_apigatewayv2_api.websocket_api.id
}

output "api_endpoint" {
  description = "The WebSocket API endpoint"
  value       = aws_apigatewayv2_stage.websocket_stage.invoke_url
}

output "execution_arn" {
  description = "The ARN prefix to be used in lambda permissions"
  value       = aws_apigatewayv2_api.websocket_api.execution_arn
}