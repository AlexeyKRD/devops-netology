provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

locals {
  myspace = {
    default = "standard-v1"
    stage   = "standard-v2"
    prod    = "standard-v3"
  }
}

locals {
  vm_count = {
    default = 1
    stage   = 1
    prod    = 2
  }
}

resource "yandex_compute_instance" "vm_with_count" {
  count       = local.vm_count[terraform.workspace]
  name        = "node-${count.index + 1}"
  zone        = var.yc_zone
  platform_id = local.myspace[terraform.workspace]

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd864gbboths76r8gm5f"
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

locals {
  vmlist = {
    default = ["node-default"],
    stage   = ["stage-1"],
    prod    = ["prod-1", "prod-2"]
  }
}

resource "yandex_compute_instance" "vm_with_foreach" {
  for_each = toset(local.vmlist[terraform.workspace])
  name        = each.value
  zone        = var.yc_zone
  platform_id = local.myspace[terraform.workspace]

  lifecycle  {
    create_before_destroy = true
  }
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd864gbboths76r8gm5f"
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
