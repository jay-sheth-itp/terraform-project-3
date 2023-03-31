locals {
  iam_output = {
    username = aws_iam_service_specific_credential.jay_sheth_HTTPS_credentials.service_user_name
    password =  aws_iam_service_specific_credential.jay_sheth_HTTPS_credentials.service_password
  }
}

resource "local_file" "local_file1_jay" {
  content = jsonencode(local.iam_output)
  filename = "${path.module}/iam_output.txt"
}

locals {
  cognito_output = {
    user_pool_id = aws_cognito_user_pool.jay_user_pool.id
    app_client_id = aws_cognito_user_pool_client.app_client.id 
  }
}

resource "local_file" "local_file2_jay" {
  content = jsonencode(local.cognito_output)
  filename = "${path.module}/cognito_soutput.txt"
}