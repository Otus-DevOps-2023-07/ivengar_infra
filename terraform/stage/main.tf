terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.95.0"
    }
  }
}


#       provider "yandex" {
#         token     = "y0_..9EM"
#         cloud_id  = "b..pc1"
#         folder_id = "b..rn3"
#         zone      = "ru-central1-a"
#       }

provider "yandex" {
  token     = var.ya_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}
module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image   = var.app_disk_image
  subnet_id        = var.subnet_id
  image_id         = var.image_id
}
module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  image_id        = var.image_id
  subnet_id       = var.subnet_id
}
