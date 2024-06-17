# openssl

In this document you will find simple examples how to use openssl, there is another repo with more comples example [here](https://github.com/Emmerson-Miranda/openssl).

## Create Local CA

### Generate a Key

```
openssl genrsa -out ca.key 2048
```

### Certificate Signing Request

```
openssl req -new -key ca.key -subj "/CN=LOCAL-CA/O=org" -out ca.csr
```

### Sign Certificate

```
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
```

## Create User Certificate

### Create a Key

```
openssl genrsa -out administrator.key 2048
```

### Certificate Signing Request

```
openssl req -new -key administrator.key -subj "/CN=Administrator/O=org" -out administrator.csr
```

### Sign Certificate with Local CA

```
openssl x509 -days 365 -req -in administrator.csr -CA ca.crt -CAkey ca.key -out administrator.crt
```

The above command fails in MacOS (ca.srl: No such file or directory), to fix that use [CAcreateserial](https://www.openssl.org/docs/man3.0/man1/openssl-x509.html) parameter.

```
openssl x509 -days 365 -req -in administrator.csr -CAcreateserial -CA ca.crt -CAkey ca.key -out administrator.crt
```
```
Signature ok
subject=/CN=Administrator
Getting CA Private Key
```

## Check a certificate

```
openssl x509 -in administrator.crt -text -noout
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

## File extensions explained
Source: https://stackoverflow.com/questions/63195304/difference-between-pem-crt-key-files

PKI - Keys are composed by public key and a private key.

.key files are generally the private key, used by the server to encrypt and package data for verification by clients.

.pem files are generally the public key, used by the client to verify and decrypt data sent by servers. PEM files could also be encoded private keys, so check the content if you're not sure.

.p12 files have both halves of the key embedded, so that administrators can easily manage halves of keys.

.cert or .crt files are the signed certificates -- basically the "magic" that allows certain sites to be marked as trustworthy by a third party.

.csr is a certificate signing request, a challenge used by a trusted third party to verify the ownership of a keypair without having direct access to the private key (this is what allows end users, who have no direct knowledge of your website, confident that the certificate is valid). In the self-signed scenario you will use the certificate signing request with your own private key to verify your private key (thus self-signed). 

A JKS keystore is a native file format for Java to store and manage some or all of the components above, and keep a database of related capabilities that are allowed or rejected for each key.


## Verify what type of certificates accept a host (useful to check mTLS issues)

```
$ hostname=w.x.y.z
$ openssl s_client -connect $hostname:443 -servername $hostname
...
Acceptable client certificate CA names
...
...
```


Links:
- https://www.thesslstore.com/blog/openssl-commands-cheat-sheet/
- https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/
