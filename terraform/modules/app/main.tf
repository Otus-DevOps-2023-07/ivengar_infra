terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.95.0"
    }
  }
}



resource "yandex_compute_instance" "app" {
  count = 1
  name  = "reddit-app-${count.index}"
  labels = {
    tags = "reddit-app"
  }
  metadata = {
    # ssh-keys = "ubuntu:${file("~/.ssh/appuser.pub")}"
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашнем задании
      image_id = var.image_id
    }
  }
  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = "e9bkvpg4erv0vcrhetcm"
    # subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  connection {
    type = "ssh"
    #host  = self.network_interface.0.nat_ip_address
    host  = yandex_compute_instance.app[0].network_interface[0].nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
#  provisioner "file" {
#    source      = "/home/appuser/gith/ivengar_infra/terraform/modules/app/files/puma.sevice"
#    destination = "/tmp/puma.service"
#  }
#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
}
