# Image из которого будут установлен докер

data "yandex_compute_image" "img" {
  family = "container-optimized-image"
}