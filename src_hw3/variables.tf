variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа для ВМ."
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Платформа для ВМ."
}

variable "vm_preemptible" {
  type        = bool
  default     = true
  description = "Признак прерываемой ВМ."
}

variable "vm_metadata_base" {
  description = "Базовые статические метаданные для ВМ."
  type        = map(string)
  default = {
    "serial-port-enable" = "1"
  }
}

variable "vms_resources" {
  description = "Конфигурация ВМ count loop"
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
}))
  default = {
    web = { # Используем 'web' как ключ для ВМ 'web'
      cores         = 2
      memory        = 1
      core_fraction = 20
    }    
  }
}
variable "vms_config" {
  description = "Конфигурация ВМ. Ключ - имя ВМ, значение - объект с параметрами."
  type = map(object({
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
  }))
  default = {
    "main" = {
      cpu         = 2
      ram         = 1024  # МБ
      disk_volume = 5   # ГБ
      core_fraction = 20
    }
    "replica" = {
      cpu         = 2
      ram         = 2048  # МБ
      disk_volume = 6    # ГБ
      core_fraction = 20
    }
  } 
}

variable "disk_name" {
  type        = string
  default     = "disk"
  description = "VPC network&subnet name"
}

variable "hdd" {
  type        = string
  default     = "network-hdd"
  description = "Тип диска (network-hdd, network-ssd)"
}
