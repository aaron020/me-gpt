terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_ssm_parameter" "claude_api_token" {
  name  = "claude_api_token"
  type  = "SecureString"
  value = var.claude_api_token
}