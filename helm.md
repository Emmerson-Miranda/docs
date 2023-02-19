*Namespaces*

Like kubectl, it accept "-n" to specify in which namespace apply the command.

Add a repo
```
$ helm repo add bitnami2 https://charts.bitnami.com/bitnami
```

Inspect default chart default values 
```
$ helm show values bitnami/apache | grep -i "replica"
```

List applications installed
```
$ helm list -a
```

Install and override helm values
```
$ helm install myapache bitnami/apache --set maxReplicas=3 --set minReplicas=2 --set replicaCount=2
```

An alternative can be download the chart locally and make changes in values.yaml before install
```
$ helm pull --untar bitnami/apache
```

helm uninstall myapache
```
$ helm uninstall myapache
```
