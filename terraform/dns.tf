resource "yandex_dns_zone" "zone1" {
  name        = "my-private-zone"
  description = "desc"

  labels = {
    label1 = "label-1-value"
  }

  zone             = "cabyca.ru."
  public           = true
}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "cabyca.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_alb_load_balancer.test-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}