
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
alias kget='_kget(){ kubectl get "$@" --show-labels;  unset -f _kget; }; _kget'
#e.g: kget po
#e.g: kget po,svc

alias krun="kubectl run --dry-run=client -oyaml"
#e.g: krun nginx --image=nginx
#e.g: krun nginx --image=nginx | kubectl create -f -

alias kcreate="kubectl create --dry-run=client -oyaml"
#e.g: kcreate cm myconfigmap --from-file=config.txt
#e.g: kcreate cm myconfigmap --from-file=config.txt | kubectl apply -f -
```

Commands like delete, replace, apply can be also optimized (for instance to not wait).
```
alias kdelete="kubectl delete --force --grace-period=0"

alias kreplace="kubectl replace --force --grace-period=0"

alias kaply="kubectl apply --force --grace-period=0"
```

Other sources: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
