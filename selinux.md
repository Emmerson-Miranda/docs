# SELinux notes


## Troubleshooting

When certaing pods needs special access that are not allowed in SELinux, so the pod's state is never running (e.g. CrashLoopBackOff). 

Choose a worker node to work on, then SSH into it.

- Baseline the current denials
  - Unistall the sofware that is failing
  - Capture and/or fix the current issues before the install the software
- Change to permissive mode
  - getenforce
  - setenforce 0
- Delete the pod with the issue
  - Kubernetes will create a new one
  - Because SELinux is in permissive mode, the pod will start without issues.
- SSH into the worker node, capture the new allow rules in a *te* file and generate *pp* filet.
  - audit2allow -a -M mycustommodule
- Install the *pp* file and put selinux in enforce mode
  - semodule -i mycustommodule.pp
  - setenforce 1
- Kill the pod again and wait for kubernetes to recreate again.
  - The pod should start properly.
- Store the *te* file in your source code repo and add it to your deploy process.
