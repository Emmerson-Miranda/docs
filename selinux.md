# SELinux notes

## Configuration

The `/etc/selinux/config` file typically contains the following properties:

Use the `getenforce` or `sestatus` commands to check in which mode SELinux is running. The `getenforce` command returns *Enforcing*, *Permissive*, or *Disabled*. 

### `SELINUX`
Defines the SELinux operational mode:
- `enforcing`: SELinux enforces its policies (denials are active).
- `permissive`: SELinux logs policy violations but does not enforce them.
- `disabled`: SELinux is completely disabled.

**Example:**
```bash
SELINUX=enforcing
```

### `SELINUXTYPE`
Specifies the SELinux policy type to use:
- `targeted`: Default policy; enforces SELinux only on targeted processes.
- `mls`: Enables Multi-Level Security (MLS) enforcement.

**Example:**
```bash
SELINUXTYPE=targeted
```

After change `/etc/selinux/config` rebbot the server.
```bash
reboot
```


[Chapter 2. Changing SELinux states and modes](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-selinux-modes_changing-selinux-states-and-modes)

<hr/>

## Troubleshooting

When certaing pods needs special access that are not allowed in SELinux, so the pod's state is never running (e.g. CrashLoopBackOff). 

[Chapter 5. Troubleshooting problems related to SELinux](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux#troubleshooting-problems-related-to-selinux_using-selinux)

Choose a worker node to work on, then SSH into it.

- When applies - Baseline the current denials
  - Capture and/or fix the current issues before install the software
- Change to permissive mode
  - getenforce
  - setenforce 0
- Delete the pod with the issue
  - Kubernetes will create a new one
  - Because SELinux is in permissive mode, the pod will start without issues and the node will log all denials without blocking.
- SSH into the worker node, capture the new allow rules in a *te* file and generate *pp* file.
  - audit2allow -a -M mycustommodule
  - [8.3.8. Allowing Access: audit2allow](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-fixing_problems-allowing_access_audit2allow)
  - [Chapter 8. Writing a custom SELinux policy](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/writing-a-custom-selinux-policy_using-selinux#creating-and-enforcing-an-selinux-policy-for-a-custom-application_writing-a-custom-selinux-policy)
  - [Chapter 9. Creating SELinux policies for containers](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/creating-selinux-policies-for-containers_using-selinux#introduction-to-udica_creating-selinux-policies-for-containers)
- Install the *pp* file and put selinux back to enforce mode
  - semodule -i mycustommodule.pp
  - setenforce 1
- Kill the pod again and wait for kubernetes to create a new one.
  - The pod should start properly.
- Store the *te* file in your source code repo and add it to your deploy process.
