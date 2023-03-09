# openssl

## Create Local CA

### Generate a Key

```
$ openssl genrsa -out ca.key 2048
```

### Certificate Signing Request

```
$ openssl req -new -key ca.key -subj "/CN=LOCAL-CA/O=org" -out ca.csr
```

### Sign Certificate

```
$ openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
Signature ok
subject=/CN=TEST-CA
Getting Private key
```

## Create User Certificate

### Create a Key

```
$ openssl genrsa -out administrator.key 2048
```

### Certificate Signing Request

```
$ openssl req -new -key administrator.key -subj "/CN=Administrator/O=org" -out administrator.csr
```

### Sign Certificate with Local CA

```
$ openssl x509 -days 365 -req -in administrator.csr -CA ca.crt -CAkey ca.key -out administrator.crt
```

The above command fails in MacOS (ca.srl: No such file or directory), to fix that use [CAcreateserial](https://www.openssl.org/docs/man3.0/man1/openssl-x509.html) parameter.

```
$ openssl x509 -days 365 -req -in administrator.csr -CAcreateserial -CA ca.crt -CAkey ca.key -out administrator.crt
Signature ok
subject=/CN=Administrator
Getting CA Private Key
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
```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number:
            ba:be:05:ca:96:4a:eb:c0
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=LOCAL-CA, O=org
        Validity
            Not Before: Mar  9 00:27:38 2023 GMT
            Not After : Mar  8 00:27:38 2024 GMT
        Subject: CN=Administrator, O=org
        ...
```

Links:
- https://www.thesslstore.com/blog/openssl-commands-cheat-sheet/
- https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/
