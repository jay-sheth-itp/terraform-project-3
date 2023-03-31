module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "JayShethReq"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  create_role   = false
  # role_name         = aws_iam_role.lambda_dynamodb.name
  lambda_role = aws_iam_role.lambda_dynamodb.arn
  source_path = "C:/Users/JaySheth/terraform/assignment_3/terraform/index.js"

  tags = {
    Name = "jay-sheth"
  }
}

resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowAPIgatewayInvokation"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:587172484624:${aws_api_gateway_rest_api.example.id}/*/*/ride"
}
