
output "workspace" {
  value =  terraform.workspace
}
output "subnet_id" {
  value =  yandex_vpc_subnet.subnet-1.id
}

output "name_vm_with_count" {
  value =  yandex_compute_instance.vm_with_count[*].name
}

output "internal_ip_address_vm_with_count" {
  value = yandex_compute_instance.vm_with_count[*].network_interface.0.ip_address
}

output "external_ip_address_vm_with_count" {
  value = yandex_compute_instance.vm_with_count[*].network_interface.0.nat_ip_address
}
