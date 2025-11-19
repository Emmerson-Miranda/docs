# EKS tips

## AWS-VAULT installation

```
sudo curl -L -o /usr/local/bin/aws-vault https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64
sudo chmod 755 /usr/local/bin/aws-vault
```

## Profile configuration

Edit *~/.aws/config* file
```
[default]
region=eu-west-2
output=json
mfa_serial=arn:aws:iam:: ... aws user ...

[profile myprofile]
source_profile=default
role_arn=arn:aws:iam::your_account:role/your_role
```

Storing user credentials
```bash
aws-vault add default
```

## Listing EKS clusters

Below command is one single line.

```bash
aws-vault exec myprofile -- aws eks list-clusters
```

## Generating kubeconfig file

Using multiple lines.

```bash
# load aws-vault credentials
aws-vault exec myprofile
aws eks list-clusters     # listing EKS clusters
 
# generate KUBECONFIG file (e.g: your-eks-cluster)
KUBECONFIG=~/.kube/your-eks-cluster.yml aws eks update-kubeconfig --name your-eks-cluster --alias your-eks-cluster

# activate cluster configuration
export KUBECONFIG=~/.kube/your-eks-cluster.yml
```


## Running terraform
```bash
aws-vault exec myprofile -- terraform plan
```
