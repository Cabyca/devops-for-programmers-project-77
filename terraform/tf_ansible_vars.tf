resource "local_file" "inventory" {
        filename        = "../ansible/inventory.ini"
        content         = templatefile("templates/inventory.tftpl",
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
  db_password: ${yandex_mdb_postgresql_user.dbuser.password}
  DOC

  filename = "../ansible//group_vars/webservers/tf_ansible_vars_file.yml"
}