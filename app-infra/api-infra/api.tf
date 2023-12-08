
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "${var.environment}-${var.app}"
  description = var.api_gateway_description
}

resource "aws_api_gateway_api_key" "sample" {
  name = "sample-${var.environment}-api-key"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_method.api_gateway_post_method,aws_api_gateway_method.api_gateway_post_method]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = var.environment
}

resource "aws_api_gateway_resource" "api_gateway_resource_post" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = var.api_resource_path_post
}

resource "aws_api_gateway_method" "api_gateway_post_method" {
  rest_api_id      = aws_api_gateway_rest_api.api_gateway.id
  resource_id      = aws_api_gateway_resource.api_gateway_resource_post.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_resource" "api_gateway_resource_get" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = var.api_resource_path_get
}
resource "aws_api_gateway_resource" "api_gateway_resource_get_parameter" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_gateway_resource_get.id
  path_part   = "{request_id}"
}

resource "aws_api_gateway_method" "api_gateway_get_method" {
  rest_api_id      = aws_api_gateway_rest_api.api_gateway.id
  resource_id      = aws_api_gateway_resource.api_gateway_resource_get_parameter.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
  request_parameters = {
    "method.request.path.request_id" = true
    "method.request.header.X-Api-Key" : true
  }
}

resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource_get_parameter.id
  status_code = "200"
  http_method = aws_api_gateway_method.api_gateway_get_method.http_method
}

resource "aws_api_gateway_method_response" "get_response_403" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource_get_parameter.id
  status_code = "403"
  http_method = aws_api_gateway_method.api_gateway_get_method.http_method
}

resource "aws_api_gateway_integration" "api_gateway_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource_post.id
  http_method             = aws_api_gateway_method.api_gateway_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${var.app}-${var.environment}-queue"
  credentials             = module.sqs_api_role.role_arn
  passthrough_behavior    = "NEVER"
  request_parameters = {
    "integration.request.header.Content-Type" : "'application/x-www-form-urlencoded'"
  }
  request_templates = {
    "application/json" : "Action=SendMessage&MessageBody=$util.urlEncode($input.body)"
  }
}

resource "aws_api_gateway_method_response" "post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource_post.id
  status_code = "200"
  http_method = aws_api_gateway_method.api_gateway_post_method.http_method
}

resource "aws_api_gateway_integration_response" "successful_sqs_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource_post.id
  http_method = aws_api_gateway_method.api_gateway_post_method.http_method
  status_code = aws_api_gateway_method_response.post_response_200.status_code
}

resource "aws_api_gateway_integration" "api_gateway_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource_get_parameter.id
  http_method             = aws_api_gateway_method.api_gateway_get_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.application_load_balancer.dns_name}/lookup_status/{request_id}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id
  request_parameters = {
    "integration.request.header.X-Api-Key" = "method.request.header.X-Api-Key"
    "integration.request.path.request_id"  = "method.request.path.request_id"
  }
}


resource "aws_api_gateway_usage_plan" "api_gateway_usage_plan" {
  name        = "${var.app}-${var.environment}-usage-plan"
  description = "${var.app}-${var.environment}"
  api_stages {
    api_id = aws_api_gateway_rest_api.api_gateway.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }
}



resource "aws_api_gateway_usage_plan_key" "api_gateway_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.sample.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_gateway_usage_plan.id
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.api_gateway_post_integration, aws_api_gateway_integration.api_gateway_get_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
}



resource "aws_api_gateway_domain_name" "api_domain_name" {
  certificate_arn = var.processing_https_listener_certificate_arn
  domain_name     = "${var.app}.${var.environment}.sample.com"
}


resource "aws_route53_record" "example" {
  name    = aws_api_gateway_domain_name.api_domain_name.domain_name
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.api_domain_name.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api_domain_name.cloudfront_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  domain_name = aws_api_gateway_domain_name.api_domain_name.domain_name
}