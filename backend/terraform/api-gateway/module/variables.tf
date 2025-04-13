variable "connect_lambda_invoke_arn" {
  description = "ARN for the connect Lambda function"
  type        = string
}

variable "disconnect_lambda_invoke_arn" {
  description = "ARN for the disconnect Lambda function"
  type        = string
}

variable "default_lambda_invoke_arn" {
  description = "ARN for the default Lambda function"
  type        = string
}

variable "send_message_lambda_invoke_arn" {
  description = "ARN for the send-message Lambda function"
  type        = string
}
