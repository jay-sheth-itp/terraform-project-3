resource "aws_amplify_app" "jay_sheth_amplify" {    
  name       = "JayShethWildRydes"
  repository = aws_codecommit_repository.jay_sheth_codecommit.clone_url_http
  build_spec = <<-EOT
version: 1
frontend:
  phases:
    # IMPORTANT - Please verify your build commands
    build:
      commands: []
  artifacts:
    # IMPORTANT - Please verify your build output directory
    baseDirectory: /
    files:
      - '**/*'
  cache:
    paths: []

EOT
    enable_branch_auto_build = true
    iam_service_role_arn = aws_iam_role.amplify-codecommit.arn
}

resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.jay_sheth_amplify.id
  branch_name = "master"
  stage     = "PRODUCTION"
}


# resource "aws_amplify_domain_association" "jay_sheth_amplify_domain" {
#   app_id = aws_amplify_app.jay_sheth_amplify.id
#   domain_name = "jay-sheth-wildrydes.dns-poc-onprem.tk"
  
#   sub_domain {
#     branch_name = aws_amplify_branch.master.branch_name
#     prefix = ""
#   }
# }