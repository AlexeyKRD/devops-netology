resource "yandex_compute_instance" "manager" {
  count = 3

  name          = format("manager-%02d", count.index +1)
  hostname      = format("manager-%02d", count.index +1)
  description   = format("manager-%02d", count.index +1)
  folder_id     = var.folder_id
  zone          = var.zone
  platform_id   = "standart-v2"

  allow_stoping_for_update = true

  resources {
    cores           = 2
    core_fraction   = 100
    memory          = 4
  }

  boot_disk {
    initialize_params {
        image_id    = data.yandex_compute_instance.ubuntu_2004.id
        size        = 30
        type        = "network-ssd"
    }
  }

  network_interface {
    subnet_id   = var.subnet
    nat         = true
  }

  metadata = {
    user-data = data.template_file.instance_userdata.rendered
  }
}

resource "yandex_compute_instance" "manager" {
  count = 3

  name          = format("worker-%02d", count.index +1)
  hostname      = format("worker-%02d", count.index +1)
  description   = format("worker-%02d", count.index +1)
  folder_id     = var.folder_id
  zone          = var.zone
  platform_id   = "standart-v2"

  allow_stoping_for_update = true

  resources {
    cores           = 2
    core_fraction   = 100
    memory          = 4
  }

  boot_disk {
    initialize_params {
        image_id    = data.yandex_compute_instance.ubuntu_2004.id
        size        = 30
        type        = "network-ssd"
    }
  }

  network_interface {
    subnet_id   = var.subnet
    nat         = true
  }

  metadata = {
    user-data = data.template_file.instance_userdata.rendered
  }
}

