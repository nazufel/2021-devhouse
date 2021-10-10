# 2021-devhouse

## Set Up

run the `make up`

That's not all though. There are some final configurations needed to be done to get metallb working:

1. make sure all of the metallb pods are in a *running* state: `kubectl get pods -n metallb-system`
2. inspect the docker network it set up `docker network inspect -f '{{.IPAM.Config}}' kind`
3. add that IP address range to the to the [metallb-cm.yaml](./kubernetes/metallb-cm.yaml)
4. save the lb ip to the shell `set -x lb (kubectl get svc/nginx -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')`
5. now curl to access nginx `curl $LB_IP:8888`


```yaml

apiVersion: v1
clusters:
	- cluster:
	    certificate-authority-data: xxxx
	    extensions:
	    - extension:
	        also-proxy:
	        - xxx.xxx.xxx.xxx/xx
	        manager:
	          namespace: ambassador
	      name: telepresence.io
	    server: https://xxx.xxx.xxx.xxx
	  name: cluster_name

```