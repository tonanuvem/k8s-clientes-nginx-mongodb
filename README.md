# k8s-nginx-clientes-mongodb

Para rodar a aplicação:

> kubectl create -f https://tonanuvem.github.io/k8s-clientes-nginx-mongodb/cliente-svc-deploy.yaml

Os seguintes serviços serão criados:

```
> ~/k8s-nginx-clientes-mongodb$ kubectl get svc
```

|NAME          |TYPE       |CLUSTER-IP     |EXTERNAL-IP  |PORT(S)         |AGE|
| --- | --- | --- | ---| --- | ---|
|backend        |ClusterIP    |10.106.72.158   |<none>        |5000/TCP   |2m40s
|frontend       |NodePort    |10.99.142.117   |<none>        |80:32000/TCP     |2m40s
|mongo          |ClusterIP   |10.102.58.27    |<none>        |27017/TCP        |2m40s
|mongoexpress   |NodePort    |10.100.3.61     |<none>        |8081:32081/TCP   |2m40s
 
Código fonte da aplicação: https://github.com/tonanuvem/nginx-clientes-microservice-mongodb

<hr>

* Portworks

Instalar:

> lsblk

> VER=$(kubectl version --short | awk -Fv '/Server Version: /{print $3}')

> curl -L -s -o px-spec.yaml "https://install.portworx.com/2.6?mc=false&kbver=${VER}&b=true&s=%2Fdev%2Fxvdb&c=px-fiap&stork=true&st=k8s"

> kubectl apply -f px-spec.yaml

- c=px-fiap specifies the cluster name
- b=true specifies to use internal etcd
- kbVer=${VER} specifies the Kubernetes version
- s=/dev/xvdb specifies the block device to use

> watch kubectl get pods -o wide -n kube-system -l name=portworx

Aguadar até: Ready 1/1 (Demora uns 4 min) --> Para sair, CTRL + C

> PX_POD=$(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}')

> kubectl exec -it $PX_POD -n kube-system -- /opt/pwx/bin/pxctl status

> kubectl exec -it $PX_POD -n kube-system -- /opt/pwx/bin/pxctl volume list

- Agora temos um cluster Portworx de 3 nós ativado!
- Todos os 3 nós estão online e usam nomes de nós Kubernetes como os IDs de nós Portworx.
- Observe que Portworx agrupou o dispositivo de bloco de cada nó em um cluster de armazenamento de 3X o tamanho.
- O Portworx detectou o tipo de mídia do dispositivo de bloco como SSD e criou um pool de armazenamento para isso.

> kubectl -n kube-system describe pods $PX_POD
 
Events:
   |Type     |Reason                             |Age                     |From                  |Message
   |----     |------                             |----                    |----                  |-------
   |Normal   |Scheduled                          |7m57s                   |default-scheduler     |Successfully assigned kube-system/portworx-qxtw4 to k8s-node-2
   |...
   |Warning  |Unhealthy                          |5m15s (x15 over 7m35s)  |kubelet, k8s-node-2   |Readiness probe failed: HTTP probe failed with statuscode: 503
   |Normal   |NodeStartSuccess                   |5m7s                    |portworx, k8s-node-2  |PX is ready on this node

<hr>

* Persistent Volume Claim (PVC) e Storage Class (SC)

Exemplo de uso: https://docs.portworx.com/portworx-install-with-kubernetes/storage-operations/create-pvcs/dynamic-provisioning/

> kubectl create -f https://tonanuvem.github.io/k8s-clientes-nginx-mongodb/vol_pvc-storageclass.yaml

> kubectl describe pvc mongo-pvc

Successfully provisioned volume pvc-0ebc5d99-0d7a-41d9-a218-6d02e9056e38 using kubernetes.io/portworx-volume

> kubectl get pv

Verificar o volume criado dinamicamente.

<hr>

Executar CLIENTE_MONGO:

> kubectl create -f https://tonanuvem.github.io/k8s-clientes-nginx-mongodb/vol_mongo-deploy.yaml

> kubectl get svc

> ./ip

Acessar : http://IP:32000

<hr>

* MongoDB

Criar o Deploy e SVC

> POD=$(kubectl get pods | grep 'mongo-' | awk '{print $1}')

> echo $POD

> kubectl exec -it $POD -- mongo --host localhost

db.ships.insert({name:'USS Enterprise-D',operator:'Starfleet',type:'Explorer',class:'Galaxy',crew:750,codes:[10,11,12]})

db.ships.insert({name:'Narada',operator:'Romulan Star Empire',type:'Warbird',class:'Warbird',crew:65,codes:[251,251,220]})

db.ships.find().pretty()

db.ships.find({}, {name:true, _id:false})

db.ships.findOne({'name':'USS Enterprise-D'})

exit

> NODE=$(kubectl get pods -l app=mongo -o wide | grep -v NAME | awk '{print $7}')

> echo $NODE

> kubectl cordon ${NODE}

> POD=$(kubectl get pods -l app=mongo -o wide | grep -v NAME | awk '{print $1}')

> kubectl delete pod ${POD}

> watch kubectl get pods -l app=mongo -o wide

Verificar os dados:

> POD=$(kubectl get pods | grep mongo- | awk '{print $1}')
 
> kubectl exec -it $POD -- mongo --host localhost

db.ships.find().pretty()

db.ships.find({}, {name:true, _id:false})

db.ships.findOne({'name':'USS Enterprise-D'})

exit

- Verificar o volume

You can run pxctl commands to inspect your volume:

> VOL=$(kubectl get pvc | grep mongo-pvc | awk '{print $3}')

> echo $VOL

> PX_POD=$(kubectl get pods -l name=portworx -n kube-system -o jsonpath='{.items[0].metadata.name}')

> kubectl exec -it $PX_POD -n kube-system -- /opt/pwx/bin/pxctl volume inspect ${VOL}

Retornar o node do Cluster:

> kubectl uncordon ${NODE}

<hr>

* Expandindo volumes:

> kubectl get pvc mongo-pvc

Expanda o volume: como adicionamos o atributo allowVolumeExpansion: true à nossa classe de armazenamento, você pode expandir o PVC editando o arquivo px-mongo-pvc.yaml e, em seguida, reaplicando esse arquivo usando kubectl.

> sed -i 's/10Gi/20Gi/g' px-mongo-pvc.yaml

> kubectl apply -f px-mongo-pvc.yaml

Inspecione o volume e verifique se ele agora tem capacidade de 20Gi:

> kubectl get pvc px-mongo-pvc

Volume agora está expandido e nosso banco de dados MongoDB não precisou ser reiniciado.

> kubectl get pods

<hr>

* Snapshot de um Volume:

> kubectl create -f https://tonanuvem.github.io/k8s-clientes-nginx-mongodb/vol_snapshot.yaml

Snapshots comandos:

> kubectl get volumesnapshot,volumesnapshotdatas

Do something stupid:

> POD=`kubectl get pods | grep 'px-mongo-' | awk '{print $1}'`

> kubectl exec -it $POD -- mongo --host px-mongo-mongodb

db.ships.remove({})

db.ships.find({}, {name:true, _id:false})

exit

- Restore the snapshot and see your data is still there

Snapshots são como volumes, portanto, podemos prosseguir e usá-los para iniciar uma nova instância do MongoDB. Observe aqui que estamos deixando a instância antiga para continuar com sua versão do volume e estamos criando uma nova instância do MongoDB com os dados do instantâneo!

>  helm install --name px-mongo-snap-clone --set persistence.existingClaim=px-mongo-snap-clone stable/mongodb

- Verify data is still available. Run the client and in a shell.

> POD=`kubectl get pods | grep 'px-mongo-snap' | awk '{print $1}'`

> kubectl exec -it $POD -- mongo --host px-mongo-snap-clone-mongodb

db.ships.findOne()

<hr>

* Mongo Replicas (link: https://docs.mongodb.com/manual/replication/)

MongoDB can run in a single node configuration as we showed and in a clustered configuration using replica sets (not to be confused with the Kubernetes Stateful Sets). A replica set is a group of MongoDB instances that maintain the same data set. A replica set contains several data bearing nodes and optionally one arbiter node. Of the data bearing nodes, one and only one member is deemed the primary node, while the other nodes are deemed secondary nodes. 

- Deploying a MongoDB Replica Set with Kubernetes Stateful Set

Portworx supports Stateful Sets which allow you to deploy a MongoDB replica. With stateful sets the PVC are dynamically created based on a provided storage class. Try the following command to launch a 3 node MongoDB replicas:

> helm install --name px --set persistentVolume.storageClass=px-ha-sc stable/mongodb-replicaset

You can watch the 3 pods (px-mongodb-replicaset-0, px-mongodb-replicaset-1, px-mongodb-replicaset-2) start up and initialize one by one:

> watch kubectl get pods -o wide

Get the volume list from pxctl, you should see 3 new 10GB volumes that were created:

> kubectl exec -it $PX_POD -n kube-system -- /opt/pwx/bin/pxctl volume list

Check the health of all three cluster members using the following command:

> for i in 0 1 2; do kubectl exec px-mongodb-replicaset-$i -- sh -c 'mongo --eval="printjson(db.serverStatus())"'; done

That's a lot of JSON but if you look closely you will see that px-mongodb-replicaset-0 should be your elected primary. You can connect to it and write/read data:

> kubectl exec -it px-mongodb-replicaset-0 -- mongo --host px-mongodb-replicaset-0

You can learn more about what you can do with this helm chart here, feel free to keep using this shell to try out some of the commands listed:

Link: https://github.com/bitnami/charts/tree/master/bitnami/mongodb

<hr>

* Helm
 
> helm install --name mongodb --set auth.enabled=false,service.portName=mongo,persistence.existingClaim=px-mongo-pvc bitnami/mongodb
 
 link: https://hub.helm.sh/charts/bitnami/mongodb
