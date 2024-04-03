# Инфраструктура как код

### Hexlet tests and linter status:
[![Actions Status](https://github.com/Cabyca/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Cabyca/devops-for-programmers-project-77/actions)

## Требования

* terraform
* ansible
* ansible-galaxy
* make
* python

### Создание инфраструктуры в облаке - TERRAFORM

```bash
make terraform-init
```

```bash
make terraform-apply
```

#### удаление инфраструктуры:

```bash
make terraform-destroy
```

### Деплой приложения WIKI на созданную инфраструктуру - ANSIBLE

```bash
make deploy-wiki
```

### Мониторинг приложения

```bash
make monitoring-wiki
```

### Работа с зашифрованными данными (в данном случае пароль к БД приложения):

#### изменение зашифрованного файла

```bash
ansible-vault edit group_vars/webservers/vault.yml
```

[Ссылка на приложение cabyca.ru](https://cabyca.ru)
