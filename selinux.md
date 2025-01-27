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

## Create and install custom SELinux policies

First write the te file, for instance:

`fix_container.te` manually created.
```
module fix_container 1.0;

require {
    type container_t;
    type container_file_t;
    class chr_file { write setattr };
}

allow container_t container_file_t:chr_file { write setattr };
```

Check syntax, to verify if you have to add a *type* or *class* inside the `require` block.
```bash
checkmodule -M -m fix_container.te
```

After, compile and install the policy:

```bash
checkmodule -M -m -o fix_container.mod fix_container.te
semodule_package -o fix_container.pp -m fix_container.mod
semodule -i fix_container.pp
```

<hr/>

## Inspect the logs

SELinux record all denials to the `/var/log/audit/audit.log` file.

Get AVC errors from last 10 minutes.

```bash
ausearch -m avc -ts recent
```

### Understanding log entry
Given below error message in audit.log:
```text
local type=AVC msg=audit(1737988480.652:41418): avc:  denied  { search } for  pid=10443 comm="OAperiodicevent" name="7467" dev="proc" ino=59310 scontext=system_u:system_r:container_t:s0:c358,c918 tcontext=system_u:system_r:container_t:s0:c188,c782 tclass=dir permissive=0
```
Understanding the error message:
- `Action Denied`: { search } – Process attempted to search in a directory.
- `Process`: OAperiodicevent (PID 10443).
- `Target Directory`: /proc/7467.
- `Source Context`: system_u:system_r:container_t:s0:c358,c918.
- `Target Context`: system_u:system_r:container_t:s0:c188,c782.
- `Class`: dir (directory).
- `Permissive`: 0 (enforcing mode).

Check if labels match:
```bash
ps -eZ | grep 10443
ls -ldZ /proc/7467
```

For more info read [7.7. Searching the Audit Log Files](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/security_guide/sec-searching_the_audit_log_files#sec-Searching_the_Audit_Log_Files)

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
