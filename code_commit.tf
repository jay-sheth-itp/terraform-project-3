resource "aws_codecommit_repository" "jay_sheth_codecommit" {
  repository_name = "JayShethWildRydes"
  description = "Repo for Wild rydes project"
}
output "codecommit_repo_name" {
  value = aws_codecommit_repository.jay_sheth_codecommit.repository_id
}