# Объявление переменных для конфиденциальных параметров

# OAuth
variable "yc_token" {}
variable "yc_folder_id" {}
variable "yc_postgresql_version" {}
variable "db_user" {}
variable "db_password" {}
variable "db_name" {}

# Добавление прочих переменных

locals {
  network_name = "network"
  subnet_name = "subnet"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84.0"
    }
  }
}

provider "yandex" {
  zone  = "ru-central1-a"
  folder_id = var.yc_folder_id
  token = var.yc_token
}

# Сеть

resource "yandex_vpc_network" "net" {
  # name = "tfhexlet"
  name = local.network_name
}

# Подсеть

resource "yandex_vpc_subnet" "subnet" {
  name           = local.subnet_name
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.192.0/24"]
}

# ------------------------------------------------

# Балансировщик нагрузки

# создание целевой группы

resource "yandex_alb_target_group" "target_group" {
  name      = "my-target-group"
  folder_id = var.yc_folder_id

  target {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
    ip_address = "${yandex_compute_instance.vm1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
    ip_address = "${yandex_compute_instance.vm2.network_interface.0.ip_address}"
  }
}

# ---------------------------------------------------

# Image из которого будут установлен докер

data "yandex_compute_image" "img" {
  family = "container-optimized-image"
}

# Бэкенд

resource "yandex_alb_backend_group" "test-backend-group" {
  name      = "my-backend-group"

  http_backend {
    name = "test-http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.target_group.id}"]
     
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
      healthcheck_port = 80
    }
  }
}

# http-роутер

resource "yandex_alb_http_router" "tf-router" {
  name      = "my-http-router"
  
}

# виртуал-хост

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name      = "my-virtual-host"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout = "3s"
      }
    }
  }
}

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


# сам балансировщик

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "my-load-balancer"

  network_id  = yandex_vpc_network.net.id
  
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet.id 
    }
  }
  
  # добавить сюда 443

  # listener {
  #   name = "my-listener"
  #   endpoint {
  #     address {
  #       external_ipv4_address {
  #       }
  #     }
  #     ports = [ 80 ]
  #   }    
  #   http {
  #     handler {
  #       http_router_id = yandex_alb_http_router.tf-router.id
  #     }
  #   }
  # }

  #resource "yandex_alb_http_router" "tf-router" {
  #name      = "my-http-router"
  #}

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        certificate_ids = ["fpq1j2b0a17o9l6vpq1o"]
        http_handler {
          http_router_id = yandex_alb_http_router.tf-router.id
        }
      }
    }
  }

  
}


# БД

resource "yandex_mdb_postgresql_cluster" "dbcluster" {
  name        = "tfhexlet"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.net.id
  depends_on  = [yandex_vpc_network.net, yandex_vpc_subnet.subnet]

  config {
    version = var.yc_postgresql_version
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 15
    }
    postgresql_config = {
      max_connections = 100
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet.id
  }
}

resource "yandex_mdb_postgresql_user" "dbuser" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_user
  password   = var.db_password
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}

resource "yandex_mdb_postgresql_database" "db" {
  cluster_id = yandex_mdb_postgresql_cluster.dbcluster.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.dbuser.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}


# Создание инстансов

resource "yandex_compute_instance" "vm1" {
  name = "hexlet1"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.network_interface[0].nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      <<EOT
sudo docker run -d -p 0.0.0.0:80:3000 \
  -e DB_TYPE=postgres \
  -e DB_NAME=${var.db_name} \
  -e DB_HOST=${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn} \
  -e DB_PORT=6432 \
  -e DB_USER=${var.db_user} \
  -e DB_PASS=${var.db_password} \
  ghcr.io/requarks/wiki:2.5
EOT
    ]
  }
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}


resource "yandex_compute_instance" "vm2" {
  name = "hexlet2"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.network_interface[0].nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      <<EOT
sudo docker run -d -p 0.0.0.0:80:3000 \
  -e DB_TYPE=postgres \
  -e DB_NAME=${var.db_name} \
  -e DB_HOST=${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn} \
  -e DB_PORT=6432 \
  -e DB_USER=${var.db_user} \
  -e DB_PASS=${var.db_password} \
  ghcr.io/requarks/wiki:2.5
EOT
    ]
  }
  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}
