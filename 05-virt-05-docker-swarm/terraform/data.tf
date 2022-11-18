data "yandex_compute_image" "ubuntu_2004" {
  family = "ubuntu-2004-lts"
}

data "template_file" "instance_userdata" {
  template = file("linux.tpl")
  vars = {
    env        = "perf"
    username   = "ubuntu"
    ssh_public = file("~/.ssh/id_rsa.pub")
  }
}