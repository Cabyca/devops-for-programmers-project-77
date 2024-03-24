output "db_username" {
  description = "Database administrator username"
  value       = yandex_mdb_postgresql_user.dbuser.name
  #sensitive   = true
}

output "db_name" {
  description = "Database administrator username"
  value       = yandex_mdb_postgresql_database.db.name
  #sensitive   = true
}

output "db_password" {
  description = "Database administrator username"
  value       = yandex_mdb_postgresql_user.dbuser.password
  sensitive   = true
}

output "db_cluster_id" {
  description = "Database administrator username"
  value       = yandex_mdb_postgresql_cluster.dbcluster.id
  #sensitive   = true
}

output "db_host" {
  description = "Database administrator username"
  value       = yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn
  #sensitive   = true
}

output "ip_vm1" {
  description = "Database administrator username"
  value       = yandex_compute_instance.vm1.network_interface[0].nat_ip_address
  #sensitive   = true
}

output "ip_vm2" {
  description = "Database administrator username"
  value       = yandex_compute_instance.vm2.network_interface[0].nat_ip_address
  #sensitive   = true
}

