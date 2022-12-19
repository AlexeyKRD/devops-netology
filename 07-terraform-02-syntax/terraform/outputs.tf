output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "zone" {
  value =  yandex_compute_instance.vm-1.zone
}

output "name" {
  value =  yandex_compute_instance.vm-1.name
}

output "subnet_id" {
  value =  yandex_compute_instance.vm-1.network_interface.0.subnet_id
}
