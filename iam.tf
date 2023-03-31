resource "aws_iam_user" "jay_sheth_IAM_user" {
  name = "JayShethUser"
}

resource "aws_iam_user_policy_attachment" "jay_sheth_user_policy_attachment" {
  user       = aws_iam_user.jay_sheth_IAM_user.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_service_specific_credential" "jay_sheth_HTTPS_credentials" {
  service_name = "codecommit.amazonaws.com"
  user_name    = aws_iam_user.jay_sheth_IAM_user.name
}

data "aws_iam_policy_document" "assume_role_amplify" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

#IAM role providing read-only access to CodeCommit
resource "aws_iam_role" "amplify-codecommit" {
  name                = "JayAmplifyCodeCommit"
  assume_role_policy  = join("", data.aws_iam_policy_document.assume_role_amplify.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}

resource "aws_iam_role" "lambda_dynamodb" {
  name = "JayShethWildRydesLambda"

  inline_policy {
    name = "DynamoDBWriteAccess"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Sid      = "VisualEditor0",
          Effect   = "Allow",
          Action   = "dynamodb:PutItem",
          Resource = "arn:aws:dynamodb:us-east-1:587172484624:table/jay-sheth-dynamo-db"
        }
      ]
    })
  }

  assume_role_policy  = join("",data.aws_iam_policy_document.assume_role_lambda.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}
