output "id" {
  value = "${aws_api_gateway_method.api-method.id}"
}

output "http_method" {
  value = "${aws_api_gateway_method.api-method.http_method}"
}

output "ok_response" {
  value = "${aws_api_gateway_method_response.ok.status_code}"
}
