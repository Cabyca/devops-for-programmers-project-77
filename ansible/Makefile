prepare:
	ansible-galaxy install -r requirements.yml

deploy:
	ansible-playbook playbook.yml -i inventory.ini --vault-password-file vault-password

python:
	ansible-playbook playbook.yml -i inventory.ini -t python --vault-password-file vault-password

wiki:
	ansible-playbook playbook.yml -i inventory.ini -t wiki --vault-password-file vault-password

monitoring:
	ansible-playbook playbook.yml -i inventory.ini -t monitoring --vault-password-file vault-password

