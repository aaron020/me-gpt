provider "aws" {
  region = "eu-west-1"
}

resource "aws_dynamodb_table" "chat-app-table" {
  name           = "chat-app-connections"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "chatId"
  range_key      = "connectionId"

  attribute {
    name = "chatId"
    type = "S"
  }

  attribute {
    name = "connectionId"
    type = "S"
  }

  global_secondary_index {
    name               = "ConnectionIdIndex"
    hash_key           = "connectionId"
    range_key          = "chatId"
    write_capacity     = 2
    read_capacity      = 2
    projection_type    = "KEYS_ONLY"
  }
}