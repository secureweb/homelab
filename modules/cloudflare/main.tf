resource "cloudflare_record" "wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*"
  value   = "82.22.59.193"
  type    = "A"
}
