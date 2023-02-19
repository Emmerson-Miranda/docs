
# Alias

For each exercise verify and set namespace will save time.
```
alias kns="kubectl config set-context --current --namespace"
#e.g: kns kube-system
#e.g: kns default

alias kcc="kubectl config view --minify | grep namespace | cut -d\" \" -f6;"
#e.g: kcc 
```

Common task to get info or create pods can be optimized to not wait.
```
alias kget="kubectl --show-labels -o=wide get" 
#e.g: kget po
#e.g: kget po,svc

alias krun="kubectl run --dry-run=client -oyaml"
#e.g: krun nginx --image=nginx
#e.g: krun nginx --image=nginx | kubectl create -f -
```

Commands like apply, replace can be also optimized to not wait.
```
alias kdelete="kubectl delete --force --grace-period=0"

alias kreplace="kubectl replace --force --grace-period=0"

alias kaply="kubectl apply --force --grace-period=0"
```

Other sources: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
