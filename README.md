# k8s-nginx-clientes-mongodb

Para rodar a aplicação:

> kubectl create -f https://tonanuvem.github.io/k8s-clientes-nginx-mongodb/cliente-svc-deploy.yaml

Os seguintes serviços serão criados:

```
> ~/k8s-nginx-clientes-mongodb$ kubectl get svc
```

|NAME          |TYPE       |CLUSTER-IP     |EXTERNAL-IP  |PORT(S)         |AGE|
| --- | --- | --- | ---| --- | ---|
|backend        |NodePort    |10.106.72.158   |<none>        |5000:32500/TCP   |2m40s
|frontend       |NodePort    |10.99.142.117   |<none>        |80:32000/TCP     |2m40s
|mongo          |ClusterIP   |10.102.58.27    |<none>        |27017/TCP        |2m40s
|mongoexpress   |NodePort    |10.100.3.61     |<none>        |8081:32081/TCP   |2m40s
 
Código fonte da aplicação: https://github.com/tonanuvem/nginx-clientes-microservice-mongodb
