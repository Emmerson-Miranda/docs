# OpenLDAP

Used in this  example https://github.com/Emmerson-Miranda/argocd/tree/main/example-12

## Verify all entries below your base DN (See groups, users, OUs, etc.)
```bash
ldapsearch -x -H ldap://127.0.0.1:389 -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" -s sub "(objectclass=*)"
```


## View users

```bash
ldapsearch -x -H ldap://127.0.0.1:389 -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" -s sub "(objectclass=inetOrgPerson)"
```

## Hashing your password to place in password field of your ldif file:

```bash
slappasswd -s yourpassword
```

## LDIF Add objects

```bash
ldapadd -x -H ldap://127.0.0.1:389  -D "cn=admin,dc=example,dc=org" -W -f /ldif/users.ldif
```
Output:
```
Enter LDAP Password: 
adding new entry "ou=groups,dc=example,dc=org"
adding new entry "cn=devops,ou=groups,dc=example,dc=org"
adding new entry "cn=devs,ou=groups,dc=example,dc=org"
adding new entry "ou=people,dc=example,dc=org"
adding new entry "cn=dmiranda,ou=people,dc=example,dc=org"
adding new entry "cn=emiranda,ou=people,dc=example,dc=org"
```

## View specif user

```bash
ldapsearch -x -H ldap://127.0.0.1:389  -D "cn=admin,dc=example,dc=org" -W -b "dc=example,dc=org" "(uid=emiranda)"
```

Output:
```
Enter LDAP Password: 
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (uid=emiranda)
# requesting: ALL
#

# emiranda, people, example.org
dn: cn=emiranda,ou=people,dc=example,dc=org
cn: emiranda
gidNumber: 503
givenName: Emmerson
homeDirectory: /home/users/emiranda
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
sn: Miranda
uid: emiranda
uidNumber: 1000
userPassword:: e01ENX1mUkJlMVlsVHRKdWwwV3RERjR4V1VBPT0=

# search result
search: 2
result: 0 Success

# numResponses: 2
# numEntries: 1
```

## Changing a user's password:

```
ldappasswd -x -H ldap://127.0.0.1:389  -D "cn=ldap_admin,dc=example,dc=org" -W -S "cn=emiranda,ou=people,dc=example,dc=org"
```

## Modifying existing LDAP Configuration:

```bash
ldapmodify -x -H ldap://127.0.0.1:389  -D "cn=ldap_admin,dc=example,dc=org" -W -f groupmod.ldif
```