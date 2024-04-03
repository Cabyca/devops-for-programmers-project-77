prepare:
	ansible-galaxy install -r requirements.yml

python:
	ansible-playbook playbook.yml -i inventory.ini -t python --vault-password-file vault-password

deploy-wiki:
	ansible-playbook playbook.yml -i inventory.ini -t wiki --vault-password-file vault-password

monitoring-wiki:
	ansible-playbook playbook.yml -i inventory.ini -t monitoring --vault-password-file vault-password

