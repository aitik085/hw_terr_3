variable "web_provision" {
  type        = bool
  default     = true
  description = "ansible provision switch variable"
}

resource "local_file" "ansible_inventory" {
  filename = "hosts.ini"
  
  content = templatefile("${path.module}/1hosts.tftpl", {
    webservers = [
      for instance in yandex_compute_instance.web : {
        name        = instance.name
        external_ip = instance.network_interface[0].nat_ip_address
        fqdn        = instance.fqdn
      }
    ]
    db_main_ip    = yandex_compute_instance.db_vm["main"].network_interface[0].nat_ip_address
    db_main_fqdn  = yandex_compute_instance.db_vm["main"].fqdn
    db_replica_ip = yandex_compute_instance.db_vm["replica"].network_interface[0].nat_ip_address
    db_replica_fqdn = yandex_compute_instance.db_vm["replica"].fqdn

    storage_ip    = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    storage_fqdn  = yandex_compute_instance.storage.fqdn
  })

  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db_vm,
    yandex_compute_instance.storage
  ]
}
/*
resource "null_resource" "web_hosts_provision" {
  count = var.web_provision == true ? 1 : 0
  
  depends_on = [
    yandex_compute_instance.web, 
    yandex_compute_instance.db_vm, 
    yandex_compute_instance.storage,
    local_file.ansible_inventory 
  ]
  
  provisioner "local-exec" {
    command    = "eval $(ssh-agent) && cat ~/.ssh/id_ed25519 | ssh-add -"
    on_failure = continue 
  }

  provisioner "local-exec" {
    # Используем созданный файл инвентаря "ansible_hosts"
    command = "ansible-playbook -i ${abspath(path.module)}/ansible_hosts ${abspath(path.module)}/1test.yml --extra-vars '{\"secrets\": ${jsonencode({ for k, v in random_password.each : k => v.result })} }'"

    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" } # Переменная окружения
  }
  triggers = {
      # Перезапускаем при изменении содержимого инвентаря (т.е. при смене IP/FQDN)
      inventory_content = local_file.ansible_inventory.content
      # Перезапускаем при изменении паролей (если вы используете random_password.each)
      password_change   = jsonencode( {for k,v in random_password.each: k=>v.result})
      # Можно добавить хэш плейбука: playbook_src_hash = filesha256("${abspath(path.module)}/1test.yml")
  }  
}
*/