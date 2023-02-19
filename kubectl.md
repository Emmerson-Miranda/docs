
# Environment variables
```
export dry="--dry=run=client -oyaml"
```


# Alias


```
alias kget="kubectl --show-labels -o=wide get" 

alias krun="kubectl run --dry-run=client -oyaml"

alias kdelete="kubectl delete --force --grace-period=0"

alias kreplace="kubectl replace --force --grace-period=0"

alias kaply="kubectl apply --force --grace-period=0"

alias kcc="kubectl config view --minify | grep namespace | cut -d\" \" -f6;"


# Source: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'

alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

```
