terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.95.0"
    }
  }
}


#	provider "yandex" {
#	  token     = "y0_AgAAAABwLnjJAATuwQAAAADrjluJEiBKWNgKS-C9giD7RsEd-LNi9EM"
#	  cloud_id  = "b1gvjcicqad03arhrpc1"
#	  folder_id = "b1gj8nmkmt869i0qcrn3"
#	  zone      = "ru-central1-a"
#	}

provider "yandex" {
  token     = "y0_AgAAAABwLnjJAATuwQAAAADrjluJEiBKWNgKS-C9giD7RsEd-LNi9EM"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "app" {
  name = "reddit-base"
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
      image_id = "fd83eipmnqnjtiiu22j2"
    }
  }
  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = "e9bkvpg4erv0vcrhetcm"
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
    host  = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
}
