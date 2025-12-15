output "vm_connection_info" {
  description = "Информация для подключения и идентификации виртуальных машин"
  value = {    
    "${yandex_compute_instance.web[0].name}" = {
      instance_name = yandex_compute_instance.web[0].name
      external_ip   = yandex_compute_instance.web[0].network_interface[0].nat_ip_address
      internal_ip   = yandex_compute_instance.web[0].network_interface[0].ip_address
      fqdn          = yandex_compute_instance.web[0].fqdn
      ssh_command   = "ssh ubuntu@${yandex_compute_instance.web[0].network_interface[0].nat_ip_address}"
    }    
  }
}

output "disk_names" {
  description = "Список имен созданных дисков"
  value = [for disk in yandex_compute_disk.disk : disk.name]
}

output "disk_ids" {
  description = "Список ID созданных дисков"
  value = yandex_compute_disk.disk[*].id
}

