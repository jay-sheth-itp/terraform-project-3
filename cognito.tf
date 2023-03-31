resource "aws_cognito_user_pool" "jay_user_pool" {
   name = "JaySheth-User-Pool"
   auto_verified_attributes = [ "email" ]
   email_configuration {
     email_sending_account = "DEVELOPER"
     from_email_address = "jay.sheth@intuitive.cloud"
     source_arn = "arn:aws:ses:us-east-1:587172484624:identity/jay.sheth@intuitive.cloud"
   }
}

resource "aws_cognito_user_pool_client" "app_client" {
  name = "JayShethWildRydesClient"
  user_pool_id = aws_cognito_user_pool.jay_user_pool.id
}

# output "AppClientID" {
#   value = aws_cognito_user_pool_client.app_client.id
# }

# output "UserPoolID" {
#   value = aws_cognito_user_pool.jay_user_pool.id
# }

