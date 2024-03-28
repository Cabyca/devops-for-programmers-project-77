# Объявление переменных для конфиденциальных параметров

variable "datadog_api_key" {
  description = "Datadog token"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog app key"
  type        = string
  sensitive   = true
}

variable "yc_token" {
  description = "Yandex cloud token - OAuth"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex folder id"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "DB user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "DB password"
  type        = string
  sensitive   = true
}

variable "db_database" {
  description = "DB database"
  type        = string
  sensitive   = true
}

variable "yc_postgresql_version" {
  description = "DB yc postgresql version"
  type        = string
  sensitive   = true
}

# локальные переменные

locals {
  network_name = "network"
  subnet_name = "subnet"
}