resource "yandex_compute_disk" "disk" {  
  count       = 3
  name        = "${var.disk_name}-${count.index}"
  size        = 1
  type        = var.hdd
  folder_id   = var.folder_id
  zone        = var.default_zone
  description = "Диск № ${count.index}"
}

