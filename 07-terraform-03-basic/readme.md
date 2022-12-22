# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно)

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws.

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя, а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано [здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.

## Задача 2. Инициализируем проект и создаем воркспейсы

1 Выполните `terraform init`:

* если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице dynamodb.
* иначе будет создан локальный файл со стейтами.  

2 Создайте два воркспейса `stage` и `prod`.

> terraform workspace new stage  
> terraform workspace new prod
>
> ```shell
> terraform workspace list
>   default
> * prod
>   stage
> ```

3 В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах использовались разные `instance_type`.

> так как yandex, проделал это с `platform_id = local.myspace[terraform.workspace]`  

4 Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.
5 Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
6 Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
7 При желании поэкспериментируйте с другими параметрами и рессурсами.

> по пункам 4-7 для ясности, приведу [main.tf](terraform/main.tf)  

В виде результата работы пришлите:

* Вывод команды `terraform workspace list`.

> ```shell
> terraform workspace list
>   default
> * prod
>   stage
> ```

* Вывод команды `terraform plan` для воркспейса `prod`.

> ```shell
> terraform plan
> 
> Terraform used the selected providers to generate the following
> execution plan. Resource actions are indicated with the following
> symbols:
>   + create
> 
> Terraform will perform the following actions:
> 
>   # yandex_compute_instance.vm_with_count[0] will be created
>   + resource "yandex_compute_instance" "vm_with_count" {
>       + created_at                = (known after apply)
>       + folder_id                 = (known after apply)
>       + fqdn                      = (known after apply)
>       + hostname                  = (known after apply)
>       + id                        = (known after apply)
>       + metadata                  = {
>           + "ssh-keys" = <<-EOT
>                 ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIMazfU30evpkD/sc11b7z5wT1ucV+ggIAA/ELO35Cem/OQIUElJWLPSDZcMlD0V2I5XcnT0S+bSBIp/HTTaYR3dSIwDLWuinERhG1bXDReJPIAzX06DanZxtWyE4zyvxiMRoiDRctE4G2m6RIK4HM/GaSdD3r52x11K/op+qff24rMl4Olw0/olGjBx3SUhgFxLiNew8wmKCqgWlQ985RTtnqCDuhDaDHe7Pz13IuwNzpVBD6a3sNjBh2AqgJLaUISoZFQpUVtcmAqPvqmCZLTsDEW9Ic2LSh1OU3tHZVEzi4JbsImtXxIpG4R0dlyIfHEyIlg0K5a7isFbnks/YKTK0HJcAvd6g6h/CIma3cQ9QHnbo+njAuATeARiyTdsf67dUTA7DQczkyK6c3HTQI8Ua9Phsi9nrKavzqfbDUBdCmH9AMGywA0QpXN6AyKtEZWPT8Eq0iZWKlRH9MGIgwCDq/dNXAnchOuJYzAAFn53LeOFZODBk9f8ih/cFCcOE= vagrant@serv
>             EOT
>         }
>       + name                      = "node-1"
>       + network_acceleration_type = "standard"
>       + platform_id               = "standard-v3"
>       + service_account_id        = (known after apply)
>       + status                    = (known after apply)
>       + zone                      = "ru-central1-a"
> 
>       + boot_disk {
>           + auto_delete = true
>           + device_name = (known after apply)
>           + disk_id     = (known after apply)
>           + mode        = (known after apply)
> 
>           + initialize_params {
>               + block_size  = (known after apply)
>               + description = (known after apply)
>               + image_id    = "fd864gbboths76r8gm5f"
>               + name        = (known after apply)
>               + size        = 30
>               + snapshot_id = (known after apply)
>               + type        = "network-ssd"
>             }
>         }
> 
>       + metadata_options {
>           + aws_v1_http_endpoint = (known after apply)
>           + aws_v1_http_token    = (known after apply)
>           + gce_http_endpoint    = (known after apply)
>           + gce_http_token       = (known after apply)
>         }
> 
>       + network_interface {
>           + index              = (known after apply)
>           + ip_address         = (known after apply)
>           + ipv4               = true
>           + ipv6               = (known after apply)
>           + ipv6_address       = (known after apply)
>           + mac_address        = (known after apply)
>           + nat                = true
>           + nat_ip_address     = (known after apply)
>           + nat_ip_version     = (known after apply)
>           + security_group_ids = (known after apply)
>           + subnet_id          = (known after apply)
>         }
> 
>       + placement_policy {
>           + host_affinity_rules = (known after apply)
>           + placement_group_id  = (known after apply)
>         }
> 
>       + resources {
>           + core_fraction = 100
>           + cores         = 2
>           + memory        = 4
>         }
> 
>       + scheduling_policy {
>           + preemptible = (known after apply)
>         }
>     }
> 
>   # yandex_compute_instance.vm_with_count[1] will be created
>   + resource "yandex_compute_instance" "vm_with_count" {
>       + created_at                = (known after apply)
>       + folder_id                 = (known after apply)
>       + fqdn                      = (known after apply)
>       + hostname                  = (known after apply)
>       + id                        = (known after apply)
>       + metadata                  = {
>           + "ssh-keys" = <<-EOT
>                 ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIMazfU30evpkD/sc11b7z5wT1ucV+ggIAA/ELO35Cem/OQIUElJWLPSDZcMlD0V2I5XcnT0S+bSBIp/HTTaYR3dSIwDLWuinERhG1bXDReJPIAzX06DanZxtWyE4zyvxiMRoiDRctE4G2m6RIK4HM/GaSdD3r52x11K/op+qff24rMl4Olw0/olGjBx3SUhgFxLiNew8wmKCqgWlQ985RTtnqCDuhDaDHe7Pz13IuwNzpVBD6a3sNjBh2AqgJLaUISoZFQpUVtcmAqPvqmCZLTsDEW9Ic2LSh1OU3tHZVEzi4JbsImtXxIpG4R0dlyIfHEyIlg0K5a7isFbnks/YKTK0HJcAvd6g6h/CIma3cQ9QHnbo+njAuATeARiyTdsf67dUTA7DQczkyK6c3HTQI8Ua9Phsi9nrKavzqfbDUBdCmH9AMGywA0QpXN6AyKtEZWPT8Eq0iZWKlRH9MGIgwCDq/dNXAnchOuJYzAAFn53LeOFZODBk9f8ih/cFCcOE= vagrant@serv
>             EOT
>         }
>       + name                      = "node-2"
>       + network_acceleration_type = "standard"
>       + platform_id               = "standard-v3"
>       + service_account_id        = (known after apply)
>       + status                    = (known after apply)
>       + zone                      = "ru-central1-a"
> 
>       + boot_disk {
>           + auto_delete = true
>           + device_name = (known after apply)
>           + disk_id     = (known after apply)
>           + mode        = (known after apply)
> 
>           + initialize_params {
>               + block_size  = (known after apply)
>               + description = (known after apply)
>               + image_id    = "fd864gbboths76r8gm5f"
>               + name        = (known after apply)
>               + size        = 30
>               + snapshot_id = (known after apply)
>               + type        = "network-ssd"
>             }
>         }
> 
>       + metadata_options {
>           + aws_v1_http_endpoint = (known after apply)
>           + aws_v1_http_token    = (known after apply)
>           + gce_http_endpoint    = (known after apply)
>           + gce_http_token       = (known after apply)
>         }
> 
>       + network_interface {
>           + index              = (known after apply)
>           + ip_address         = (known after apply)
>           + ipv4               = true
>           + ipv6               = (known after apply)
>           + ipv6_address       = (known after apply)
>           + mac_address        = (known after apply)
>           + nat                = true
>           + nat_ip_address     = (known after apply)
>           + nat_ip_version     = (known after apply)
>           + security_group_ids = (known after apply)
>           + subnet_id          = (known after apply)
>         }
> 
>       + placement_policy {
>           + host_affinity_rules = (known after apply)
>           + placement_group_id  = (known after apply)
>         }
> 
>       + resources {
>           + core_fraction = 100
>           + cores         = 2
>           + memory        = 4
>         }
> 
>       + scheduling_policy {
>           + preemptible = (known after apply)
>         }
>     }
> 
>   # yandex_compute_instance.vm_with_foreach["prod-1"] will be created
>   + resource "yandex_compute_instance" "vm_with_foreach" {
>       + created_at                = (known after apply)
>       + folder_id                 = (known after apply)
>       + fqdn                      = (known after apply)
>       + hostname                  = (known after apply)
>       + id                        = (known after apply)
>       + metadata                  = {
>           + "ssh-keys" = <<-EOT
>                 ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIMazfU30evpkD/sc11b7z5wT1ucV+ggIAA/ELO35Cem/OQIUElJWLPSDZcMlD0V2I5XcnT0S+bSBIp/HTTaYR3dSIwDLWuinERhG1bXDReJPIAzX06DanZxtWyE4zyvxiMRoiDRctE4G2m6RIK4HM/GaSdD3r52x11K/op+qff24rMl4Olw0/olGjBx3SUhgFxLiNew8wmKCqgWlQ985RTtnqCDuhDaDHe7Pz13IuwNzpVBD6a3sNjBh2AqgJLaUISoZFQpUVtcmAqPvqmCZLTsDEW9Ic2LSh1OU3tHZVEzi4JbsImtXxIpG4R0dlyIfHEyIlg0K5a7isFbnks/YKTK0HJcAvd6g6h/CIma3cQ9QHnbo+njAuATeARiyTdsf67dUTA7DQczkyK6c3HTQI8Ua9Phsi9nrKavzqfbDUBdCmH9AMGywA0QpXN6AyKtEZWPT8Eq0iZWKlRH9MGIgwCDq/dNXAnchOuJYzAAFn53LeOFZODBk9f8ih/cFCcOE= vagrant@serv
>             EOT
>         }
>       + name                      = "prod-1"
>       + network_acceleration_type = "standard"
>       + platform_id               = "standard-v3"
>       + service_account_id        = (known after apply)
>       + status                    = (known after apply)
>       + zone                      = "ru-central1-a"
> 
>       + boot_disk {
>           + auto_delete = true
>           + device_name = (known after apply)
>           + disk_id     = (known after apply)
>           + mode        = (known after apply)
> 
>           + initialize_params {
>               + block_size  = (known after apply)
>               + description = (known after apply)
>               + image_id    = "fd864gbboths76r8gm5f"
>               + name        = (known after apply)
>               + size        = 30
>               + snapshot_id = (known after apply)
>               + type        = "network-ssd"
>             }
>         }
> 
>       + metadata_options {
>           + aws_v1_http_endpoint = (known after apply)
>           + aws_v1_http_token    = (known after apply)
>           + gce_http_endpoint    = (known after apply)
>           + gce_http_token       = (known after apply)
>         }
> 
>       + network_interface {
>           + index              = (known after apply)
>           + ip_address         = (known after apply)
>           + ipv4               = true
>           + ipv6               = (known after apply)
>           + ipv6_address       = (known after apply)
>           + mac_address        = (known after apply)
>           + nat                = true
>           + nat_ip_address     = (known after apply)
>           + nat_ip_version     = (known after apply)
>           + security_group_ids = (known after apply)
>           + subnet_id          = (known after apply)
>         }
> 
>       + placement_policy {
>           + host_affinity_rules = (known after apply)
>           + placement_group_id  = (known after apply)
>         }
> 
>       + resources {
>           + core_fraction = 100
>           + cores         = 2
>           + memory        = 4
>         }
> 
>       + scheduling_policy {
>           + preemptible = (known after apply)
>         }
>     }
> 
>   # yandex_compute_instance.vm_with_foreach["prod-2"] will be created
>   + resource "yandex_compute_instance" "vm_with_foreach" {
>       + created_at                = (known after apply)
>       + folder_id                 = (known after apply)
>       + fqdn                      = (known after apply)
>       + hostname                  = (known after apply)
>       + id                        = (known after apply)
>       + metadata                  = {
>           + "ssh-keys" = <<-EOT
>                 ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIMazfU30evpkD/sc11b7z5wT1ucV+ggIAA/ELO35Cem/OQIUElJWLPSDZcMlD0V2I5XcnT0S+bSBIp/HTTaYR3dSIwDLWuinERhG1bXDReJPIAzX06DanZxtWyE4zyvxiMRoiDRctE4G2m6RIK4HM/GaSdD3r52x11K/op+qff24rMl4Olw0/olGjBx3SUhgFxLiNew8wmKCqgWlQ985RTtnqCDuhDaDHe7Pz13IuwNzpVBD6a3sNjBh2AqgJLaUISoZFQpUVtcmAqPvqmCZLTsDEW9Ic2LSh1OU3tHZVEzi4JbsImtXxIpG4R0dlyIfHEyIlg0K5a7isFbnks/YKTK0HJcAvd6g6h/CIma3cQ9QHnbo+njAuATeARiyTdsf67dUTA7DQczkyK6c3HTQI8Ua9Phsi9nrKavzqfbDUBdCmH9AMGywA0QpXN6AyKtEZWPT8Eq0iZWKlRH9MGIgwCDq/dNXAnchOuJYzAAFn53LeOFZODBk9f8ih/cFCcOE= vagrant@serv
>             EOT
>         }
>       + name                      = "prod-2"
>       + network_acceleration_type = "standard"
>       + platform_id               = "standard-v3"
>       + service_account_id        = (known after apply)
>       + status                    = (known after apply)
>       + zone                      = "ru-central1-a"
> 
>       + boot_disk {
>           + auto_delete = true
>           + device_name = (known after apply)
>           + disk_id     = (known after apply)
>           + mode        = (known after apply)
> 
>           + initialize_params {
>               + block_size  = (known after apply)
>               + description = (known after apply)
>               + image_id    = "fd864gbboths76r8gm5f"
>               + name        = (known after apply)
>               + size        = 30
>               + snapshot_id = (known after apply)
>               + type        = "network-ssd"
>             }
>         }
> 
>       + metadata_options {
>           + aws_v1_http_endpoint = (known after apply)
>           + aws_v1_http_token    = (known after apply)
>           + gce_http_endpoint    = (known after apply)
>           + gce_http_token       = (known after apply)
>         }
> 
>       + network_interface {
>           + index              = (known after apply)
>           + ip_address         = (known after apply)
>           + ipv4               = true
>           + ipv6               = (known after apply)
>           + ipv6_address       = (known after apply)
>           + mac_address        = (known after apply)
>           + nat                = true
>           + nat_ip_address     = (known after apply)
>           + nat_ip_version     = (known after apply)
>           + security_group_ids = (known after apply)
>           + subnet_id          = (known after apply)
>         }
> 
>       + placement_policy {
>           + host_affinity_rules = (known after apply)
>           + placement_group_id  = (known after apply)
>         }
> 
>       + resources {
>           + core_fraction = 100
>           + cores         = 2
>           + memory        = 4
>         }
> 
>       + scheduling_policy {
>           + preemptible = (known after apply)
>         }
>     }
>
>   # yandex_vpc_network.network-1 will be created
>   + resource "yandex_vpc_network" "network-1" {
>       + created_at                = (known after apply)
>       + default_security_group_id = (known after apply)
>       + folder_id                 = (known after apply)
>       + id                        = (known after apply)
>       + labels                    = (known after apply)
>       + name                      = "network1"
>       + subnet_ids                = (known after apply)
>     }
> 
>   # yandex_vpc_subnet.subnet-1 will be created
>   + resource "yandex_vpc_subnet" "subnet-1" {
>       + created_at     = (known after apply)
>       + folder_id      = (known after apply)
>       + id             = (known after apply)
>       + labels         = (known after apply)
>       + name           = "subnet1"
>       + network_id     = (known after apply)
>       + v4_cidr_blocks = [
>           + "192.168.10.0/24",
>         ]
>       + v6_cidr_blocks = (known after apply)
>       + zone           = "ru-central1-a"
>     }
>
> Plan: 6 to add, 0 to change, 0 to destroy.
>
> Changes to Outputs:
>   + external_ip_address_vm_with_count = [
>       + (known after apply),
>       + (known after apply),
>     ]
>   + internal_ip_address_vm_with_count = [
>       + (known after apply),
>       + (known after apply),
>     ]
>   + name_vm_with_count                = [
>       + "node-1",
>       + "node-2",
>     ]
>   + subnet_id                         = (known after apply)
>   + workspace                         = "prod"
> 
> ───────────────────────────────────────────────────────────────────────
> 
> Note: You didn't use the -out option to save this plan, so Terraform
> can't guarantee to take exactly these actions if you run "terraform
> apply" now.
> ```