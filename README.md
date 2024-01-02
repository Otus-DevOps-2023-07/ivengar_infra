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

# ДЗ Ansible-3

1. $ ansible-galaxy -h
2. cd /ansible  mkdir roles
3. 	$ ansible-galaxy init app
	$ ansible-galaxy init db
4. tree db
5. В директорию шаблоннов роли ansble/roles/db/templates
скопируем шаблонизированный конфиг для MongoDB из
директории ansible/templates
6. Файл ansible/roles/db/tasks/main.yml
7. файл ansible/roles/db/defaults/main.yml
8. Создадим в папке roles папку app
9. Выполним команду ansible-galaxy init в папке roles/app
10. Скопируем секцию tasks в сценарии плейбука ansible/app.yml
11.  заменить src в модулях copy и template для указания только имени файлов
12. Скопируйте файл db_config.j2 из директории ansible/templates в директорию ansible/roles/app/templates/
	Файл ansible/files/puma.service скопируем в ansible/roles/app/files/.
13.  ansible/roles/app/handlers/main.yml
	ansible/roles/app/defaults/main.yml
14. ansible/app.yml ansible/db.yml
15. пересоздадим инфраструктуру terraform destroy $ terraform apply -auto-approve=false
16. не забудьте изменить внешние IP адреса
17. ansible-playbook site.yml --check $ ansible-playbook site.yml
18. Управление окружениями
19. В директории ansible/environments создадим две директории для наших окружений stage и prod
20. инвентори файл ansible/inventory в каждую из директорий окружения environtents/prod и environments/stage
21. Деплой ansible-playbook -i environments/prod/inventory deploy.yml
22. Создадим директорию group_vars
23. ansible/environments/stage/group_vars/all
24. Конфигурация окружения prod будет идентичной, за исключением переменной env, определенной для группы all
25. ansible/roles/app/defaults/main.yml:
	ansible/roles/db/defaults/main.yml
26. Будем выводить информацию о том, в каком окружении находится конфигурируемый хост
27.  ansible/roles/app/tasks/main.yml ansible/roles/db/tasks/main.yml
28. Организуем плейбуки
29. Улучшим файл ansible.cfg
30. ansible-playbook playbooks/site.yml
31. то же для prod
32. Работа с Community-ролями
33. с помощью утилиты ansible-galaxy и файла requirements.yml
34. Используем роль jdauphant.nginx и настроим обратное
проксирование для нашего приложения с помощью nginx.
35. Создадим файлы environments/stage/requirements.yml и
	environments/prod/requirements.yml
	Добавим в них запись вида:
	Установим роль:
	Комьюнити-роли не стоит коммитить в свой репозиторий, для этого добавим в .gitignore запись: jdauphant.nginx
	- src: jdauphant.nginx
	version: v2.21.1
	ansible-galaxy install -r environments/stage/requirements.yml
36. 	nginx_sites:
	default:
	- listen 80
	- server_name "reddit"
	- location / {
	    proxy_pass http://127.0.0.1:порт_приложения;
	  }
Добавим эти переменные в stage/group_vars/app и
prod/group_vars/app
37. Добавьте вызов роли jdauphant.nginx в плейбук app.yml. Применил плейбук site.yml
38. Создайте файл vault.key со произвольной строкой ключа. Изменим файл ansible.cfg
39. .gitignore
40. файл ansible/playbooks/users.yml
41. Создадим файл с данными пользователей для каждого окружения credentials.yml
42. Зашифруем ansible-vault encrypt environments/prod/credentials.yml
	 ansible-vault encrypt environments/stage/credentials.yml
43. P.S.
Для редактирования переменных нужно использовать
команду ansible-vault edit <file>
А для расшифровки: ansible-vault decrypt <file>
