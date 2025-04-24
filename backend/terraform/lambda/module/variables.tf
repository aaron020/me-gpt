variable "lambda_deploy_bucket" {
  description = "Name of existing S3 bucket used to deploy lambda functions"
  type        = string
  default     = "lambda-deploy-bucket-partially-normally-feasible-drake"
}

variable "lambda_source_dir" {
  description = "Directory containing Lambda function code"
  type        = string
}

variable "lambda_output_path" {
  description = "Path where the Lambda zip file will be created"
  type        = string
}

variable "s3_key" {
  description = "S3 object key for the Lambda deployment package"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.11"
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role for the Lambda function"
  type        = string
  default     = "serverless_lambda_role_checker"
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Memory size for the Lambda function in MB"
  type        = number
  default     = 128
}

variable "allow_manage_connections" {
  description = "If set to true, we allow this lambda to manage connections"
  type = bool
  default = false
}

variable "allow_access_params" {
  description = "If set to true, we all this allow to access param store"
  type = bool
  default = false
}

variable "common_layer_arn"{
  description = "Chat app common layer arn"
  type = list(string)
}

variable "api_gateway_arn" {
  description = "ARN of API gateway that is allowed to call the lambdas"
  type = string
  default = "arn:aws:execute-api:eu-west-1:471112781107:7v06mm1h35/*/*"
}