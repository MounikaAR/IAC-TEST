resource "aws_route53_record" "k8s_api_server_record" {
  zone_id = var.route53_zone_id
  name    = var.record_name
  type    = "A"
  alias {
    name                   =  var.alias_name
    zone_id                =  var.alias_zone_id
    evaluate_target_health = false
  }
}
