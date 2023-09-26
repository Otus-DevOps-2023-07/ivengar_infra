# ДЗ Знакомство с облачной инфраструктурой и облачными сервисами

bastion_IP = 158.160.119.216
someinternalhost_IP = 10.128.0.20

Подключение к someinternalhost одной коммандой:

ssh -J appuser@158.160.119.216 appuser@10.128.0.20

Для подключения через алиас необходим конфигурационный файл в папке ~/.ssh/config


Host bastion
HostName 158.160.119.216
User appuser

Host someinternalhost
HostName 10.128.0.20
User appuser
ProxyJump bastion

Host *
IdentityFile ~/.ssh/appuser


Полезные ссылки :

https://habr.com/ru/companies/cloud4y/articles/530516/
https://wiki.gentoo.org/wiki/SSH_jump_host
https://docs.pritunl.com/docs/connecting
https://linuxize.com/post/using-the-ssh-config-file/

# ДЗ Основные сервисы Yandex Cloud

testapp_IP = 51.250.76.218
testapp_port = 9292 
user yc_user

# ДЗ Подготовка образов с помощью Packer

Создал набор параметризуемых параметров:

service_account_key_file 
folder_id 
source_image_family 
ssh_username 
platform_id 
image_family 
image_min_disk_size_gb
disk_size_gb
zone 
use_ipv4_nat

https://developer.hashicorp.com/packer/guides/hcl/variables
https://developer.hashicorp.com/packer/integrations/hashicorp/yandex/latest/components/builder/yandex

