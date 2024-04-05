# Балансировщик нагрузки

# сам балансировщик

resource "yandex_alb_load_balancer" "test-balancer" {
  name = "my-load-balancer"

  network_id = yandex_vpc_network.net.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet.id
    }
  }

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

# http-роутер

resource "yandex_alb_http_router" "tf-router" {
  name = "my-http-router"

}

# виртуал-хост

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "3s"
      }
    }
  }
}

# целевая группа

resource "yandex_alb_target_group" "target_group" {
  name      = "my-target-group"
  folder_id = var.yc_folder_id

  target {
    subnet_id  = yandex_vpc_subnet.subnet.id
    ip_address = yandex_compute_instance.vm1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet.id
    ip_address = yandex_compute_instance.vm2.network_interface.0.ip_address
  }
}

# группа бэкэндов

resource "yandex_alb_backend_group" "test-backend-group" {
  name = "my-backend-group"

  http_backend {
    name             = "test-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.target_group.id}"]

    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
      healthcheck_port = 80
    }
  }
}



