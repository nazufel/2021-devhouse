# 2021-devhouse


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