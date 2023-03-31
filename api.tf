resource "aws_api_gateway_rest_api" "example" {
  # body = jsonencode({
  #   openapi = "3.0.1"
  #   info = {
  #     title   = "WildRydes"
  #     version = "1.0"
  #   }
  # })

  name = "JayShethWildRydes"

  endpoint_configuration {
    types = ["EDGE"]
  }
}
resource "aws_api_gateway_resource" "ride" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "ride"
  depends_on = [
    aws_api_gateway_rest_api.example
  ]
}
# for cors----------------------------------------------------------------------------------

resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.ride.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  # request_parameters = {
  #   ""
  # }
}

# aws_api_gateway_integration._
resource "aws_api_gateway_integration" "example" {
  rest_api_id      = aws_api_gateway_rest_api.example.id
  resource_id      = aws_api_gateway_resource.ride.id
  http_method      = aws_api_gateway_method.example.http_method
  content_handling = "CONVERT_TO_TEXT"
  uri = module.lambda_function.lambda_function_invoke_arn

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# aws_api_gateway_integration_response._
resource "aws_api_gateway_integration_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = 200

response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
  }
  

#   depends_on = [
#     aws_api_gateway_model.emptyModel
#   ]
}

# aws_api_gateway_method_response._
resource "aws_api_gateway_method_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.ride.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = 200

  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on  = [aws_api_gateway_integration.example]
}
# ------------------------------------------------------------------------------------------------------

resource "aws_api_gateway_authorizer" "authorizer" {
  name          = "jay-sheth-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.example.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.jay_user_pool.arn]
}

resource "aws_api_gateway_method" "method" {

  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.ride.id
  http_method   = "POST"
  #  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id


}


resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "prods"
}



resource "aws_api_gateway_method_response" "method_response" {
    rest_api_id = "${aws_api_gateway_rest_api.example.id}"
    resource_id = "${aws_api_gateway_resource.ride.id}"
    http_method = "${aws_api_gateway_method.method.http_method}"
    status_code = "200"

    response_models = {
         "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
   rest_api_id = "${aws_api_gateway_rest_api.example.id}"
   resource_id = "${aws_api_gateway_resource.ride.id}"
   http_method = "${aws_api_gateway_method.method.http_method}"
   status_code = "${aws_api_gateway_method_response.method_response.status_code}"

   response_templates = {
       "application/json" = ""
   } 
   
  depends_on = [
    aws_api_gateway_integration.integration
  ]
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.ride.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  # integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = module.lambda_function.lambda_function_invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {

    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.ride.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))

  }

  lifecycle {
    create_before_destroy = true
  }
}
# resource "aws_api_gateway_model" "emptyModel" {
#    rest_api_id = aws_api_gateway_rest_api.example.id
#    name = "Empty"
#    description = "This is a default empty schema mode"
#   content_type = "application/json"
#    schema = "{\n  \"$schema\": \"http://json-schema.org/draft-04/schema#\",\n  \"title\": \"Empty Schema\",\n  \"type\": \"object\"\n}"
#  }

# resource "aws_api_gateway_rest_api" "example" {
#   body = jsonencode({
#     openapi = "3.0.1"
#     info = {
#       title   = "JayShethWildRydes"
#       version = "1.0"
#     }
#   })

#   name = "Jay-Sheth-wildrydes"

#   endpoint_configuration {
#     types = ["EDGE"]
#   }
# }
# resource "aws_api_gateway_resource" "ride" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
#   path_part   = "ride"
#   depends_on = [
#     aws_api_gateway_rest_api.example
#   ]
# }

# resource "aws_api_gateway_authorizer" "authorizer" {
#   name          = "Jay-Sheth-authorizer"
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   type          = "COGNITO_USER_POOLS"
#   provider_arns = [aws_cognito_user_pool.jay_user_pool.arn]
# }

# resource "aws_api_gateway_method" "method" {

#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   resource_id   = aws_api_gateway_resource.ride.id
#   http_method   = "POST"
#   authorization = "COGNITO_USER_POOLS"
#   authorizer_id = aws_api_gateway_authorizer.authorizer.id

# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example.id
#   resource_id             = aws_api_gateway_resource.ride.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   depends_on = [
#     module.lambda_function
#   ]
#   uri                     = module.lambda_function.lambda_function_invoke_arn
# }

# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.example.id
#   stage_name    = "jay-stage"
# }

# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.example.id
#   depends_on = [
#     aws_api_gateway_rest_api.example
#   ]
#   stage_name    = "jay-stage"
#   triggers = {

#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.ride.id,
#       aws_api_gateway_method.method.id,
#       aws_api_gateway_integration.integration.id,
#     ]))

#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }


# resource "aws_api_gateway_rest_api" "jay_rest_api" {
#   name = "JayShethWildRy"
# }

# resource "aws_api_gateway_resource" "jay_resource" {
#   parent_id   = aws_api_gateway_rest_api.jay_rest_api.root_resource_id
#   path_part   = "ride"
#   rest_api_id = aws_api_gateway_rest_api.jay_rest_api.id
# }

# resource "aws_api_gateway_method" "jay_method" {
#   authorization = "NONE"
#   http_method   = "POST"
#   resource_id   = aws_api_gateway_resource.jay_resource.id
#   rest_api_id   = aws_api_gateway_rest_api.jay_rest_api.id
# }

# resource "aws_api_gateway_authorizer" "demo" {
#   name                   = "demo"
#   rest_api_id            = aws_api_gateway_rest_api.demo.id
#   authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
#   authorizer_credentials = aws_iam_role.invocation_role.arn
# }


# resource "aws_api_gateway_integration" "example" {
#   http_method = aws_api_gateway_method.jay_method.http_method
#   resource_id = aws_api_gateway_resource.jay_resource.id
#   rest_api_id = aws_api_gateway_rest_api.jay_rest_api.id
#   type        = "MOCK"
# }

# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.jay_rest_api.id

#   triggers = {
#     # NOTE: The configuration below will satisfy ordering considerations,
#     #       but not pick up all future REST API changes. More advanced patterns
#     #       are possible, such as using the filesha1() function against the
#     #       Terraform configuration file(s) or removing the .id references to
#     #       calculate a hash against whole resources. Be aware that using whole
#     #       resources will show a difference after the initial implementation.
#     #       It will stabilize to only change when resources change afterwards.
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.example.id,
#       aws_api_gateway_method.example.id,
#       aws_api_gateway_integration.example.id,
#     ]))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.jay_rest_api.id
#   stage_name    = "example"
# }