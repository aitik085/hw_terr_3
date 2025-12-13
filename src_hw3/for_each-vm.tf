resource "yandex_compute_instance" "db_vm" {
for_each = var.vms_config
name        = each.key
platform_id = var.vm_platform_id
zone        = var.default_zone
resources {
    cores  = each.value.cpu    
    memory = each.value.ram / 1024
    core_fraction = each.value.core_fraction
 } 
 boot_disk {
    initialize_params {
      size        = each.value.disk_volume # ГБ
      image_id = data.yandex_compute_image.ubuntu.image_id      
      }
 }
scheduling_policy {
    preemptible = var.vm_preemptible
 }
network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    #security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
}
metadata = local.vm_metadata
# Вывод для проверки созданных ресурсов
# Output: db_vm["main"].name = "main"
}