# Makefile

# makefile to shorten commands

# --------------------------------------------------------------------------- #

# build the kubernetes cluser in KinD
cluster:
	$(clean_command)
	kind create cluster --name kind
	kubectx kind-kind
	kubens default


cluster-down:
	$(clean_command)
	kind delete cluster

# deploy kubernetes resources
deploy:
	$(clean_command)
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="(openssl rand -base64 128)" 
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml
	kubectl apply -f kubernetes/namespace.yaml
	kubectl apply -f kubernetes/externalNames-svc.yaml
	kubectl apply -f kubernetes/nginx-svc.yaml
	kubectl apply -f kubernetes/nginx-cm.yaml
	kubectl apply -f kubernetes/nginx-deployment.yaml
	kubens devhouse

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