# создание инстансов

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
    ssh-keys = "ubuntu:${file(var.path_to_file)}"
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
    ssh-keys = "ubuntu:${file(var.path_to_file)}"
  }

  depends_on = [yandex_mdb_postgresql_cluster.dbcluster]
}