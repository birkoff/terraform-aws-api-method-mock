provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

resource "aws_api_gateway_method" "api-method" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${var.api_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "api-method-integration" {
  depends_on              = ["aws_api_gateway_method.api-method"]
  rest_api_id             = "${var.api_id}"
  resource_id             = "${var.api_resource_id}"
  http_method             = "${aws_api_gateway_method.api-method.http_method}"
  integration_http_method = "${var.http_method}"
  type                    = "MOCK"
  content_handling        = "CONVERT_TO_TEXT"

  request_templates {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "ok" {
  depends_on  = ["aws_api_gateway_method.api-method", "aws_api_gateway_integration.api-method-integration"]
  rest_api_id = "${var.api_id}"
  resource_id = "${var.api_resource_id}"
  http_method = "${aws_api_gateway_method.api-method.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "ok-integration-response" {
  depends_on  = ["aws_api_gateway_method_response.ok", "aws_api_gateway_method.api-method", "aws_api_gateway_integration.api-method-integration"]
  rest_api_id = "${var.api_id}"
  resource_id = "${var.api_resource_id}"
  http_method = "${aws_api_gateway_method.api-method.http_method}"
  status_code = "${aws_api_gateway_method_response.ok.status_code}"

  response_templates = {
    "application/json" = ""
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'${var.allow_methods}'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
