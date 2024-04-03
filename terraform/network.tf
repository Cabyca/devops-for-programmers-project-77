# cеть

resource "yandex_vpc_network" "net" {
  # name = "tfhexlet"
  name = var.network_name
}

# подсеть

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.192.0/24"]
}