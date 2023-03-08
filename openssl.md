# openssl

## Create a Key

```
$ openssl genrsa -out ca.key 2048
Generating RSA private key, 2048 bit long modulus
.......................+++++
................+++++
e is 65537 (0x10001)
```

## Certificate Signing Request

```
$ openssl req -new -key ca.key -subj "/CN=TEST-CA" -out ca.csr
```

## Sign Certificate

```
$ openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
Signature ok
subject=/CN=TEST-CA
Getting Private key
```


## Verify what type of certificates accept a host (useful to check mTLS issues)

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
