locals { 
  vm_metadata = merge(
    var.vm_metadata_base, 
    {
      "ssh-keys" = "ubuntu:${var.vms_ssh_public_root_key}" 
    }
  )
}