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

# ДЗ Знакомство с Terraform

1. Выполнил настройку по слайдам дз с 1 по 46
2. Создал input переменную для приватного ключа
3. Определил input переменную для задания зоны
4. Отформатировал файлы используя команду **terraform fmt**
5. Создал файл `terraform.example.tfvars`,
6. Создал файл lb.tf
7. Добавил планировщик и reddit-app-2
8. Сделал через count

#  ДЗ Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform

1. Выполнил настройку по слайдам дз с 1 по 46
2. Выполнил первое задание

# ДЗ Ansible-1

1. Установил ансибл:
	sudo apt-add-repository ppa:ansible/ansible
	sudo apt update
	sudo apt install ansible

2. Настрол файл inventory.
	reddit-db ansible_host=<ext_ip> ansible_user=ubuntu ansible_private_key_file="/home/appuser/.ssh/ubuntu"
 Проверка:
ansible reddit-db -i ./inventory -m ping
Enter passphrase for key '/home/appuser/.ssh/ubuntu':
reddit-db | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
3. проверил выполнение произвольных комманд:
	ansible dbserver -m command -a uptime
4. проверил работу с группами хостов:
	ansible app -m ping
5. выполнил создание inventory.yml
	ansible all -m ping -i inventory.yml
6. проверка компонентов на серверах:
	ansible app -m command -a 'ruby -v'
	ansible app -m command -a 'bundler -v'
	или обе
	ansible app -m command -a 'ruby -v; bundler -v' - но это не работает )
	ansible app -m shell -a 'ruby -v; bundler -v' - вот так работает
7. Проверка сервера бд
	ansible db -m command -a 'systemctl status mongod'
	ansible db -m shell -a 'systemctl status mongod'
	ansible db -m systemd -a name=mongod
	или
	ansible db -m service -a name=mongod
8. Установка git
	ansible app -u ubuntu -b -K -m shell -a "sudo apt install -y git"
	Проверка:
	ansible app -m apt -a name=git
9. Клонирование репозитория в новую директорию:
	ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
10. Создал и выполнил ansible-playbook clone.yml
	- name: Clone
		hosts: app
		tasks:
	- name: Clone repo
		git:
		repo: https://github.com/express42/reddit.git
		dest: /home/appuser/reddit
11.  Удалил и заново залил репозиторий:
	ansible app -m command -a 'rm -rf ~/reddit'
	ansible-playbook clone.yml
 	Изменился параметр change потому что заново залился repo


# ДЗ Ansible-2

1. Выполнил задания из PDF
	создал файлы: 	app.yml
			db.yml
			site.yml
			eddit_app_multiple_plays.yml
			reddit_app_one_play.yml

2. Создал 	packer/db.json
		packer/app.json
