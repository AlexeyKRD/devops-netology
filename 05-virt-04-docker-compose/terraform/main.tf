terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
    cloud_id = "b1gvl7fsreo034jbp8u4"
    folder_id = var.folder_id
    zone = var.zone
}

terraform {
  backend "local" {
      path = "terraform.tfstate"
  }
}

resource "yandex_compute_instance" "node1" {

  name        = "node01"
  hostname    = "node01"
  description = "node01"
  folder_id   = var.folder_id
  zone        = var.zone
  platform_id = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores         = 2
    core_fraction = 100
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd87ur7904r032mnb8pd"
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = var.subnet
    nat                = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_ed25519.pub")}"
  }
}

variable "folder_id" {
  type = string
  default = "b1gjvlaobsr9g1d8i03v"
}

variable "zone" {
  type = string
  default = "ru-central1-a"
}

variable "subnet" {
  type = string
  default = "e9b3k5fn9gfdfcesiu79"
}