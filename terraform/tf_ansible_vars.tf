resource "local_file" "inventory" {
        filename        = "../ansible/inventory.ini"
        content         = templatefile("../ansible/inventory.tftpl",
                                {
                                ip_addrs = [
                                  yandex_compute_instance.vm1.network_interface[0].nat_ip_address,
                                  yandex_compute_instance.vm2.network_interface[0].nat_ip_address
                                ],
                                })
}

resource "local_file" "tf_ansible_vars_file" {
 
  content = <<-DOC
  db_database: ${yandex_mdb_postgresql_database.db.name}
  db_port: 6432
  db_host: ${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn}
  db_user: ${yandex_mdb_postgresql_user.dbuser.name}
  DOC

  filename = "../ansible//group_vars/webservers/tf_ansible_vars_file.yml"
}

# resource "ansible_vault" "secrets" {
#   #Путь к зашифрованному файлу хранилища.
#   vault_file          = "../ansible/group_vars/webservers/vault.yml"
#   #Путь к файлу паролей хранилища
#   vault_password_file = "../ansible/vault-password"
# }

# resource "local_file" "vault" {
 
#   content = <<-DOC
#   yc_postgresql_version: "13"
#   db_database: ${yandex_mdb_postgresql_database.db.name}
#   db_port: 6432
#   db_host: ${yandex_mdb_postgresql_cluster.dbcluster.host.0.fqdn}
#   db_user: ${yandex_mdb_postgresql_user.dbuser.name}
#   db_password: ${yandex_mdb_postgresql_user.dbuser.password}
#   DOC

#   filename = "../ansible/group_vars/webservers/vault.yml"
# }

# tf_ansible_vars_file.yml

# db_database: hexlet
# db_port: 6432
# db_host: rc1a-b4yg1xdqez5o94yj.mdb.yandexcloud.net
# db_user: me
# db_password: bvcdV6sdBS7AXZs

# secret.auto.tfvars

# yc_token = "y0_AgAAAAAEZgumAATuwQAAAAD7yVF7AABrSgLSfSBJtZ33hw8CF02AFpc2RA"
# yc_folder_id = "b1gl35ub8bqd5kk434im"

# yc_postgresql_version = "13"
#db_name = "hexlet"
#db_user = "me"
#db_password = "bvcdV6sdBS7AXZs"


# ansible_user1 = ${yandex_compute_instance.vm1.connection}
# ansible_user2 = ${yandex_compute_instance.vm2.connection}

