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
  name = "reddit-app-${count.index}"
  metadata = {
    # ssh-keys = "ubuntu:${file("~/.ssh/appuser.pub")}"
    ssh-keys = "ycuser:${file(var.public_key_path)}"
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
    # subnet_id = "e9bkvpg4erv0vcrhetcm"
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat       = true
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
}
