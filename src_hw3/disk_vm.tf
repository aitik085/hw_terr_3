resource "yandex_compute_disk" "disk" {  
  count       = 3
  name        = "${var.disk_name}-${count.index}"
  size        = 1
  type        = var.hdd
  folder_id   = var.folder_id
  zone        = var.default_zone
  description = "Диск № ${count.index}"
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname    = "storage"
  zone        = var.default_zone
  platform_id = var.vm_platform_id

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = true
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disk    
    content {     
      disk_id = secondary_disk.value.id     
    }
  }
  metadata = local.vm_metadata
  depends_on = [
    yandex_compute_disk.disk
  ]
}