terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.10.0"
    }
  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  folder_id = var.yc_folder_id
  token     = var.yc_token
}

provider "datadog" {
  api_url = "https://api.datadoghq.eu/"
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}