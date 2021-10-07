# Makefile

# makefile to shorten commands

# --------------------------------------------------------------------------- #

# build the kubernetes cluser in KinD
cluster:
	$(clean_command)
	kind create cluster

cluster-down:
	$(clean_command)
	kind delete clsuter

# deploy kubernetes resources
deploy:
	$(clean_command)
	kubectl apply -f kubernetes/namespace.yaml
	kubectl apply -f kubernetes/externalNames-svc.yaml
	kubectl apply -f kubernetes/nginx-svc.yaml
	kubectl apply -f kubernetes/nginx-cm.yaml
	kubectl apply -f kubernetes/nginx-deployment.yaml

down: vagrant-down cluster-down

# build the servers defined in the vagrant file 
servers:
	$(clean_command)
	vagrant up

# run vagrant ssh-config and save the results to the ssh config file
ssh-config:
	$(clean_command)
	vagrant ssh-config >> ~/.ssh/config

up: servers ssh-config cluster deploy

vagrant-down:
	$(clean_command)
	vagrant destroy -f
# --------------------------------------------------------------------------- #
#EOF