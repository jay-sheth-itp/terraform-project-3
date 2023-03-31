output "username_https_git_cred" {
  value = aws_iam_service_specific_credential.jay_sheth_HTTPS_credentials.service_user_name
}

output "password_https_git_cred" {
  value = aws_iam_service_specific_credential.jay_sheth_HTTPS_credentials.service_password
  sensitive = true
}

