# openssl

Verify what type of certificates accept a host (useful to check mTLS issues)

```
$ hostname=w.x.y.z
$ openssl s_client -connect $hostname:443 -servername $hostname
...
Acceptable client certificate CA names
...
...
```

Check a certificate

```
openssl x509 -in certificate.crt -text -noout
```

Links:
- https://www.thesslstore.com/blog/openssl-commands-cheat-sheet/
- https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/
