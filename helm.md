# Helm notes

*Namespaces*

Like kubectl, it accept "-n" to specify in which namespace apply the command.

## Repositories

Add a repo
```
$ helm repo add bitnami2 https://charts.bitnami.com/bitnami
```

List repos
```
$  helm repo list
NAME                    URL                                               
prometheus-community    https://prometheus-community.github.io/helm-charts
kedacore                https://kedacore.github.io/charts                                      
jenkinsci               https://charts.jenkins.io                         
bitnami                 https://charts.bitnami.com/bitnami                
bitname2                https://charts.bitnami.com/bitnami  
```


Remove repo
```
$ helm repo remove bitname2
"bitname2" has been removed from your repositories
```

Search a chart
```
$ helm search repo nginx
NAME                                            CHART VERSION   APP VERSION                             DESCRIPTION                                       
bitnami/nginx                                   15.12.2         1.25.4                                  NGINX Open Source is a web server that can be a...
bitnami/nginx-ingress-controller                10.5.2          1.9.6                                   NGINX Ingress Controller is an Ingress controll...
bitnami/nginx-intel                             2.1.15          0.4.9                                   DEPRECATED NGINX Open Source for Intel is a lig...
nginx-stable/nginx-appprotect-dos-arbitrator    0.1.0           1.1.0                                   NGINX App Protect Dos arbitrator                  
nginx-stable/nginx-devportal                    1.7.1           1.7.1                                   A Helm chart for deploying ACM Developer Portal   
nginx-stable/nginx-ingress                      1.1.3           3.4.3                                   NGINX Ingress Controller                          
nginx-stable/nginx-service-mesh                 2.0.0                                                   NGINX Service Mesh         
```

List all chart versions
```
$ helm search repo bitnami/nginx --versions
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/nginx                           15.14.0         1.25.4          NGINX Open Source is a web server that can be a...
bitnami/nginx                           15.13.0         1.25.4          NGINX Open Source is a web server that can be a...
bitnami/nginx                           15.12.2         1.25.4          NGINX Open Source is a web server that can be a...
bitnami/nginx                           15.12.1         1.25.4          NGINX Open Source is a web server that can be a...
bitnami/nginx                           15.11.0         1.25.4          NGINX Open Source is a web server that can be a...
```

## Applications

Inspect default values inside the chart
```
$ helm show values bitnami/nginx 
```

Install and override helm values
```
$ helm install mynginx bitnami/nginx --set replicaCount=2 --set fullnameOverride="myngix1" -n nginxns --create-namespace

$ helm install mynginx bitnami/nginx --set nameOverride="mynginx2" --set replicaCount=1 -n nginxns2 --create-namespace

$ helm upgrade mynginx bitnami/nginx --install --set nameOverride="mynginx3" --set replicaCount=1 -n nginxns3 --create-namespace
```

List applications installed
```
$ helm list -a -A --pending --uninstalling
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
mynginx nginxns         1               2024-03-20 23:43:44.142762 +0000 UTC    deployed        nginx-15.12.2   1.25.4     
mynginx nginxns2        1               2024-03-20 23:44:30.949043 +0000 UTC    deployed        nginx-15.12.2   1.25.4     
mynginx nginxns3        1               2024-03-20 23:49:48.745501 +0000 UTC    deployed        nginx-15.12.2   1.25.4   
```

Update a release
```
$ helm upgrade mynginx bitnami/nginx --set nameOverride="mynginxmod" --set replicaCount=2 -n nginxns --create-namespace
```

Get the current Helm release values 
```
$ helm get values mynginx -n nginxns -o yaml 
nameOverride: mynginxmod
replicaCount: 2
```

```
$ helm get values mynginx -n nginxns -o yaml -a | grep tag
    tag: 2.43.2-debian-12-r2
  tag: 1.25.4-debian-12-r2
    tag: 1.1.0-debian-12-r7
```

View revision numbers
```
$ helm history mynginx -n nginxns
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Wed Mar 20 23:43:44 2024        superseded      nginx-15.12.2   1.25.4          Install complete
2               Wed Mar 20 23:57:18 2024        deployed        nginx-15.12.2   1.25.4          Upgrade complete
```

Rollback to a specific revision
```
$ helm rollback mynginx 1 -n nginxns
Rollback was a success! Happy Helming!

$ helm history mynginx -n nginxns   
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Wed Mar 20 23:43:44 2024        superseded      nginx-15.12.2   1.25.4          Install complete
2               Wed Mar 20 23:57:18 2024        superseded      nginx-15.12.2   1.25.4          Upgrade complete
3               Thu Mar 21 00:27:56 2024        deployed        nginx-15.12.2   1.25.4          Rollback to 1  
```


Download the chart locally
```
$ helm pull --untar bitnami/apache
```

Uninstall a release
```
$ helm uninstall myapache
```

## Local development

Render local chart, run in the chart root folder (https://helm.sh/docs/helm/helm_template/).

```
$ helm template .
```

To pass multiple file with values use multiple times `-f`, if file does not exist it will fail.

If you use [buildin objects](https://helm.sh/docs/chart_template_guide/builtin_objects/) within your templates like `Capabilities.APIVersions.Has` use `--api-versions` command line argument.

If you want to validate against the target server use `--validate` and `--kubeconfig` command line arguments.

