
# Environment variables
```
export dry="--dry=run=client -oyaml"
```


# Alias


```
alias kdf="kubectl delete --force --grace-period=0"

alias krf="kubectl replace --force --grace-period=0"

alias kaf="kubectl apply --force --grace-period=0"

# Source: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'

alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

```
