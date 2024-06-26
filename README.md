# Инфраструктура как код

### Hexlet tests and linter status:
[![Actions Status](https://github.com/Cabyca/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Cabyca/devops-for-programmers-project-77/actions)

## Требования

* terraform
* ansible
* ansible-galaxy
* make
* python

### Деплой приложения WIKI в облако и его мониторинг одной командой

```bash
make deploy-app
```

## или

### Создание инфраструктуры в облаке - TERRAFORM

```bash
make init-terraform
```

```bash
make apply-terraform
```

#### форматирование файлов конфигурации:

```bash
make format-terraform
```
#### удаление инфраструктуры:

```bash
make destroy-terraform
```

### Деплой приложения WIKI на созданную инфраструктуру - ANSIBLE

```bash
make deploy-wiki
```

### Мониторинг приложения на Datadog

```bash
make monitoring-wiki
```
### Для работы приложения потребуется:

* зарегистрироваться на сайте (https://www.datadoghq.com/)
>       получить два ключа: datadog_api, datadog_app

* в папке ansible создать файл vault-password :
>        записать в файл пароль к доступу файла vault.yml

* в папке ansible/group_vars/webservers создать файл vault.yml :
>        зашифровать в нем:
>        datadog_api_key_vault: "..."
>        datadog_app_key_vault: "..."

* редактирование зашифрованного файла vault.yml :
```bash
ansible-vault edit group_vars/webservers/vault.yml
```

* в папке terraform создайте файл secret.auto.tfvars :
>        yc_token              = "..."
>        yc_postgresql_version = "..."
>        db_database           = "..."
>        db_user               = "..."
>        db_password           = "..."
>        yc_folder_id          = "..."
>        datadog_api_key       = "..."
>        datadog_app_key       = "..."
>        domen                 = "..."
>        network_name          = "..."
>        subnet_name           = "..."
>        path_to_file          = "~/.ssh/*.pub"



[Ссылка на приложение cabyca.ru](https://cabyca.ru)
