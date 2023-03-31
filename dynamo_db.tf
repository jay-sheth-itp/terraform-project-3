module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "jay-sheth-dynamo-db"
  hash_key = "RideId"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  autoscaling_enabled = true
  attributes = [
    {
      name = "RideId"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}