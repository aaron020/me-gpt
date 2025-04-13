provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_policy" "policy" {
  name        = "LambdaUseDatabase"
  path        = "/"
  description = "Policy to allow my lambdas to use the database"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy" "manage_connections" {
  name        = "LambdaManageConnections"
  path        = "/"
  description = "Policy to allow my lambdas to manage connections"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "execute-api:ManageConnections",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "retrieve_params" {
  name        = "LambdaAccessParams"
  path        = "/"
  description = "Policy allowing to retrieve and decrypt params"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}