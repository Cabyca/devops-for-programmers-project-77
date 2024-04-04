deploy-app:
	make -C terraform init-terraform
	make -C terraform apply-terraform
	make -C ansible prepare
	make -C ansible python
	make -C ansible deploy-wiki
	make -C ansible monitoring-wiki