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

## Download a certificate from HTTPS endpoint

```
openssl s_client -showcerts -connect github.com:443 </dev/null | sed -n -e '/-.BEGIN/,/-.END/ p' > certs.pem
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


## Verify what type of certificates accept a host (useful to check mTLS issues)

```
$ hostname=w.x.y.z
$ openssl s_client -connect $hostname:443 -servername $hostname
...
Acceptable client certificate CA names
...
...
```

## File extensions explained
Source: https://stackoverflow.com/questions/63195304/difference-between-pem-crt-key-files

PKI - Keys are composed by public key and a private key.

.key files are generally the private key, used by the server to encrypt and package data for verification by clients. This is accessible the key owner and no one else.

.pem files are generally the public key, used by the client to verify and decrypt data sent by servers. PEM files could also be encoded private keys, so check the content if you're not sure. Is a text-based base-64 encoded. It can have multiple(chained) certificates in the below format:

```text
-----BEGIN ...-----
...
-----END ...-----
```

.pem file can hold multiple certificates in the following order (Note: some servers may require in reverse order):
1) Your server certificate
2) Intermediate certificate
3) Root certificate


[See: How to create a .pem file for SSL Certificate Installations]([https://link-url-here.org](https://www.suse.com/es-es/support/kb/doc/?id=000018152))


.p12 is a PKCS12 file, which is a container format usually used to combine the private key and certificate.

.cert or .crt files are the signed certificates -- basically the "magic" that allows certain sites to be marked as trustworthy by a third party.

.csr is the certificate request. This is a request for a certificate authority to sign the key. (The key itself is not included.)

### JKS 
A JKS keystore is a native file format for Java to store and manage some or all of the components above, and keep a database of related capabilities that are allowed or rejected for each key.

Use keytool utility to add certificates to keystore (see https://docs.oracle.com/en/java/javase/17/docs/specs/man/keytool.html)

```text
keytool -trustcacerts -keystore "$JAVA_HOME/lib/security/cacerts" -storepass changeit --importcert -alias mycert -file ~/Downloads/mycert.pem
```


# Links:
- https://www.thesslstore.com/blog/openssl-commands-cheat-sheet/
- https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/
