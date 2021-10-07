# Makefile

# makefile to shorten commands

# --------------------------------------------------------------------------- #

# build the kubernetes cluser in KinD
cluster:
	$(clean_command)
	kind create cluster

# deploy kubernetes resources
deploy:
	$(clean_command)
	kubectl apply -f kubernetes/namespace.yaml
	kubectl apply -f kubernetes/externalNames-svc.yaml
	kubectl apply -f kubernetes/nginx-svc.yaml
	kubectl apply -f kubernetes/nginx-cm.yaml
	kubectl apply -f kubernetes/nginx-deployment.yaml

down:
	$(clean_command)
	kind delete cluster
	vagrant destroy -f

# build the servers defined in the vagrant file 
servers:
	$(clean_command)
	vagrant up

# run vagrant ssh-config and save the results to the ssh config file
ssh-config:
	$(clean_command)
	vagrant ssh-config >> ~/.ssh/config

up:
	$(clean_command)
	servers
	ssh-config
	cluster
	deploy
# --------------------------------------------------------------------------- #
#EOF