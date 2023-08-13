# SWAT Checklist
Securing Web Application Technologies - Security best practices that Developers and DevOps should be aware while build applications.

Information in this document can be considered part of **NFR** to be used during design and implementation phases to avoid creating unnecessary technical debt and prevent critical vulnerabilities in your application.

Source: [SWAT Checklist](https://www.sans.org/cloud-security/securing-web-application-technologies/)

Acronyms
- CWE - Common Weakness Enumeration, is a community-developed list of software and hardware weakness types. 
- DoD - Definition of Done.
- EDA - Event Driven Architectures
- NFR - Non Functional Requirements.
- OOM - Out Of Memory
- PO  - Product Owner
- SSO - Single Sign On


*OWASP Cheat Sheet Series*
Collection of high value information on specific application security topics: https://cheatsheetseries.owasp.org/

## Error Handling and Logging

| Best Practice | CWE | Description | Notes 
|---------------|-----|-------------|------|
| Display generic error messages | [CWE-209](http://cwe.mitre.org/data/definitions/209.html) | Error messages should not reveal sensitive information about its environment, users, or associated data.<br/><br/>An attacker may use the contents of error messages to help launch another, more focused attack.<br/><br/>e.g. Usernames, Passwords, Tokens, Filesystems, Language | Test cases should verify error responses. Furthermore also check successful responses.<br/><br/>Should be part of DoD and code review. Worst case scenario gateways can filter this information. |
|Handle unhandled exceptions| [CWE-391](http://cwe.mitre.org/data/definitions/391.html)| Error handlers should be configured to handle unexpected errors and gracefully return controlled output to the user. <br/><br/>Ignoring exceptions and other error conditions may allow an attacker to induce unexpected behavior unnoticed. | Test cases should try to recreate these scenarios ([Chaos Engineering](https://en.wikipedia.org/wiki/Chaos_engineering) may help)|
|Avoid empty exception blocks| [CWE-1069](https://cwe.mitre.org/data/definitions/1069.html) | When an exception handling block (such as a Catch and Finally block) is used, but that block is empty, this can prevent the product from running reliably. | Should be part of DoD. <br/><br/> Static Code Analysis tools can help to check the code (SonarQube, ReSharper...)|
| Manage uncaught exceptions | [CWE-248](https://cwe.mitre.org/data/definitions/248.html) | When an exception is not caught, it may cause the program to crash or expose sensitive information. | Applications use to be build on top of frameworks, those are not except of errors and can fail without allow developers handle exceptions (e.g. OOM). <br/><br/>Worst case scenario gateways can filter this information.<br/><br/>That can be an edge case, in some scenarios performance test can detect this malfunctioning sending large payloads to the target application constantly and in parallel during some period of time.|
|Logging security activities| [CWE-778](https://cwe.mitre.org/data/definitions/778.html) | Any activities or occasions where the user's privilege level changes should be logged. <br/><br/>Any authentication activities, whether successful or not, should be logged. <br/><br/>Any access to sensitive data should be logged. This is particularly important for corporations that have to meet regulatory requirements like HIPAA, PCI, or SOX.| Logging should be part of DoD. <br/><br/>Testing should validate logs are writting for any activity with external systems specially specially in distributed applications (e.g. Microservices, EDA, ...) |
| Do not log sensitive data | [CWE-532](https://cwe.mitre.org/data/definitions/532.html) | Do not expose sensitive data or sensitive user information in log files, it can break laws such as GDPR/LOPD. <br/><br/>Under HIPAA and PCI, it would be a violation to log sensitive data into the log itself unless the log is encrypted on the disk. | It can be allowed in non-production environments with the purpose of help developers but not in production, as long as sensitive data that identify real users is not used. <br/><br/> Should be part of DoD and verify during PO demo. <br/><br/>Impersonalization data techniques can be used to avoid write sensitive data on the logs.|
| Store logs securely | [CWE-533](https://cwe.mitre.org/data/definitions/533.html) | Logs should be stored and maintained appropriately to avoid information loss or tampering by intruder. <br/><br/> Log retention should also follow the retention policy set forth by the organization to meet regulatory requirements and provide enough information for forensic and incident response activities. | Even this was deprecated because is too low level all data at rest should be encrypted (see Data Protection). <br/><br/>Should be a feature provided by default by the platform. <br/><br/>Access to this info should be controlled and allowed only to authorized personnel. |


## Data Protection
| Best Practice | CWE | Description | Notes 
|---------------|-----|-------------|------|
| Encryption data in transit. | [CWE-311](https://cwe.mitre.org/data/definitions/311.html) <br/> [CWE-319](https://cwe.mitre.org/data/definitions/319.html) <br/> [CWE-523](https://cwe.mitre.org/data/definitions/523.html) | All data sensitive or critial information should be encrypted before transmition. <br/><br/>Some examples are: users, passwords, tokens, encryption keys or any information that can help to identify individuals or organizations. | Guarantees data integrity and confidentiality.<br/><br/>  [Zero Trust Security](https://www.cloudflare.com/en-gb/learning/security/glossary/what-is-zero-trust/) and [Service mesh](https://en.wikipedia.org/wiki/Service_mesh) helps to protect access to sensitive information.<br/><br/>  PCI DSS, HIPAA requires all data transfers must be encrypted.  <br/><br/>Technically it makes reference to TLS (HTTPS, SFTP, AMQP/JMS over TLS). <br/><br/> Disable HTTP or redirect to HTTPS. Use the Strict-Transport-Security Header. |
| Encryption data at rest. | [CWE-311](https://cwe.mitre.org/data/definitions/311.html) <br/> [CWE-319](https://cwe.mitre.org/data/definitions/319.html) <br/> [CWE-523](https://cwe.mitre.org/data/definitions/523.html) | All data sensitive or critial information should be encrypted before storage. | Guarantees data integrity and confidentiality. <br/><br/>Technically it makes reference to enable encryption on AWS S3 and Azure Blob.|
| Store passwords securely | [CWE-257](https://cwe.mitre.org/data/definitions/257.html) | User passwords must be stored using secure hashing techniques with strong algorithms. | Hashicorp Vault can store sensitive information securely. <br/><br/> No password should be stored in the code (application, testing, infrastructure). <br/><br/> Mechanisms to scan the code in regularly should be placed or even before push the code to the repositories. <br/><br/> Automatic scans should happen in source code repositories to identify secrets patterns (passwords, tokens, private keys ...) and also can be applied as pre-commit hooks to avoid commit/push sensitive information to the repositories. |
| Use strong TLS ciphers |  | Weak ciphers must be disabled on all servers. <br/><br/>For example, SSL v2, SSL v3, and TLS protocols prior to 1.2 have known weaknesses and are not considered secure. <br/><br/>Additionally, disable the NULL, RC4, DES, and MD5 cipher suites. Ensure all key lengths are greater than 128 bits, use secure renegotiation, and disable compression. | Is possible to check source code to enforce the use of TLS ciphers (includes proxies if you use IaC and configuration management)  | 
| Rotate certificates regulary | - | - | It makes more complicated tamper information in case an attacker have a copy of the certificate. <br/><br/>Authomation can be used to rotate them regulary. There are tools and frameworks that offer this capability (e.g. cert-manager). |
| Encrypt cache with sensitive information | [CWE-524](https://cwe.mitre.org/data/definitions/524.html) | The code uses a cache that contains sensitive information, but the cache can be read by an actor outside of the intended control sphere. | Encrypt ETCD storage for kubernetes (specially when use secrets with passwords). <br/><br/>Similar approach happen when applications store information in cache (REDIS, EhCache, Coherence,...) | 

## Configuring and Applications
| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| Automate application deployment | | Automating the deployment of your application, using Continuous Integration and Continuous Deployment, helps to ensure that changes are made in a consistent, repeatable manner in all environments.| No manual changes should be accepted|
| Establish a Rigorous Change Management Process | [CWE-439](https://cwe.mitre.org/data/definitions/439.html) | A rigorous change management process must be maintained during change management operations. For example, new releases should only be deployed after process  | |
| Define security requirements | | Engage the business owner to define security requirements for the application. | |
| Conduct design reviews | [CWE-701](https://cwe.mitre.org/data/definitions/701.html) | Integrating security into the design phase saves money and time. <br/><br/>Conduct a risk review with security professionals and threat model the application to identify key risks. <br/><br/>The helps you integrate appropriate countermeasures into the design and architecture of the application. | |
| Avoid security by obscurity | [CWE-656](https://cwe.mitre.org/data/definitions/656.html) | The application should not be protected if the attacker can make reverse engineering. | Security by obscurity can only slow down an attacker and can introduce an undesirable weakness. |
| Perform code reviews | [CWE-702](https://cwe.mitre.org/data/definitions/702.html) | Security focused code reviews can be one of the most effective ways to find security bugs. Regularly review your code looking for common issues like SQL Injection and Cross-Site Scripting. | Merge request or PRs to a different team member helps to mitigate this.<br/><br/> Static Code Analysis tools verification can help. |
| Perform security testing | | Conduct security testing both during and after development to ensure the application meets security standards. Testing should also be conducted after major releases to ensure vulnerabilities did not get introduced during the update process. | Avoid manual testing process, tests should be repeteable and if possible integrate as part of delivery pipeline. | 
| Store configuration securely | [CWE-15](https://cwe.mitre.org/data/definitions/15.html) | Setting manipulation vulnerabilities occur when an attacker can control values that govern the behavior of the system, manage specific resources, or in some way affect the functionality of the application. | Only authorized users can access and update system configuration. Any update should be audited. |
| Educate the team on security | | Training helps define a common language that the team can use to improve the security of the application. <br/><br/>Education should not be confined solely to software developers, testers, and architects. Anyone associated with the development process, such as business analysts and project managers, should all have periodic software security awareness training. | |
| Verify configuration and security configuration| | | In Cloud environments, cloud providers have tools to analyze cloud resources configuration and security. Tools: [Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/) from AWS and [Advisor](https://azure.microsoft.com/en-gb/products/advisor/) from Azure.<br/><br/>There are also tools to detect changes and react such as: AWS [Config](https://aws.amazon.com/config) and Azure [Application Change Analysis](https://learn.microsoft.com/en-us/azure/azure-monitor/app/change-analysis) |



## Authentication

| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| Don't hardcode credentials | [CWE-798](https://cwe.mitre.org/data/definitions/798.html) | Never allow credentials to be stored directly within the application code. | Code reviews and static code analysis tools can help to detect and prevent it.|
| Develop a strong password reset system | [CWE-640](https://cwe.mitre.org/data/definitions/640.html) | Password reset systems are often the weakest link in an application. These systems are often based on the user answering personal questions to establish their identity and in turn reset the password. <br/><br/>The system needs to be based on questions that are both hard to guess and brute force. <br/><br/>Additionally, any password reset option must not reveal whether or not an account is valid, preventing username harvesting. | |
| Implement a strong password policy and Move towards passwordless authentication | [CWE-521](https://cwe.mitre.org/data/definitions/521.html) | For password based authentication, password policy should be created and implemented so that passwords meet specific strength criteria.<br/><br/> If the user base and application can support it, leverage the various forms of passwordless authentication such as [FIDO2](https://en.wikipedia.org/wiki/FIDO_Alliance#FIDO2) based authentication or mobile application push based authenticators. | Using complementary mechanisms such as [MFA](https://en.wikipedia.org/wiki/Multi-factor_authentication) helps to protect access to the system even if the password is compromised. |
| Implement account lockout against brute force attacks | [CWE-307](https://cwe.mitre.org/data/definitions/307.html) | Account lockout needs to be implemented to guard against brute forcing attacks against both the authentication and password reset functionality.<br/><br/> After several tries on a specific user account, the account should be locked for a period of time or until manually unlocked.<br/><br/> Additionally, it is best to continue the same failure message indicating that the credentials are incorrect or the account is locked to prevent an attacker from harvesting usernames. | |
| Don't disclose too much information in error messages | | Messages for authentication errors must be clear and, at the same time, be written so that sensitive information about the system is not disclosed.<br/><br/> For example, error messages which reveal that the userid is valid but that the corresponding password is incorrect confirms to an attacker that the account does exist on the system. | I saw similar requirements on integration systems when payload gets validated against the schema. |
| Store database credentials and API keys securely | [CWE-257](https://cwe.mitre.org/data/definitions/257.html) | Modern web applications usually consist of multiple layers. The business logic tier (processing of information) often connects to the data tier (database). Connecting to the database, of course, requires authentication. The authentication credentials in the business logic tier must be stored in a centralized location that is locked down.<br/><br/>  The same applies to accessing APIs providing services to support your application. Scattering credentials throughout the source code is not acceptable. Some development frameworks provide a centralized secure location for storing credentials to the backend database. <br/><br/> Secret management solutions that are cloud based or on-premise can be used to allow the application to acquire the credential at application launch or when needed, therefore securing the credentials and avoid storing them statically on disk within a server or a container image. | There are multiple products that allow secrets such as: Hashicorp [Vault](https://www.vaultproject.io/), AWS [Key Management Service](https://aws.amazon.com/kms), AWS [Secrets Manager](https://aws.amazon.com/es/secrets-manager/), Azure [Key Vault](https://azure.microsoft.com/services/key-vault). |
| Applications and Middleware should run with minimal privileges | [CWE-250](https://cwe.mitre.org/data/definitions/250.html) | If an application becomes compromised it is important that the application itself and any middleware services be configured to run with minimal privileges. <br/><br/> For instance, while the application layer or business layer needs the ability to read and write data to the underlying database, administrative credentials that grant access to other databases or tables should not be provided. | We should check all credentials used by applications have the bare minimum privileges required. <br/><br/>Applications should not use admin credentials to connect to databases or other kind of resources. <br/><br/>In case of containers the user that run the application should be non root.|

## Session Management

| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| Regenerate Session Tokens | [CWE-384](http://cwe.mitre.org/data/definitions/384.html) | Should be regenerated when the user authenticates and when the user privilege level changes. | This will prevent steal privileges from other sessions or reuse them by accident given undesirable privileges to a session to a new login.|
| Implement an Idle Session Timeout | [CWE-613](http://cwe.mitre.org/data/definitions/613.html) | When a user is not active, the application should automatically log the user out. Be aware that Ajax applications may make recurring calls to the application effectively resetting the timeout counter automatically. <br/><br/>Set the Cookie Expiration Time. | In the modern frameworks it use to be a configuration option.|
| Implement an Absolute Session Timeout | [CWE-613](http://cwe.mitre.org/data/definitions/613.html) | Users should be logged out after an extensive amount of time has passed since they logged in. | The amount of time should be configurable. That applies even if we use "remember me / keep me login". |
| Invalidate the Session after Logout | [CWE-613](http://cwe.mitre.org/data/definitions/613.html) | When the user logs out of the application the session and corresponding data on the server must be destroyed. | This applies also when you use SSO and user browse among multiple applications. |
| Encrypt sensitive cookies | [CWE-614](https://cwe.mitre.org/data/definitions/614.html) | Sensitive cookies should not be transmited in text plain, attackers can access to this information. | Sensitive cookies must be always transmited via HTTPS only. SAST tools can help to detect this configuration as well as testing scripts.|
| Avoid sensitive cookies access from client-side scripts | [CWE-1004](https://cwe.mitre.org/data/definitions/1004.html) | Prevent client-side script from accessing cookies. HttpOnly flag in the Set-Cookie HTTP response header helps mitigate the risk associated with Cross-Site Scripting (XSS) where an attacker's script code might attempt to read the contents of a cookie. | - |


## Input and Output Handling
WIP

| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| Use Parameterized SQL Queries | [CWE](https) | xxx. | xxx.|
| Set the Encoding for Your Application | [CWE](https) | xxx. | xxx.|
| Use Secure HTTP Response Headers | [CWE](https) | xxx. | xxx.|
| Parameters and Headers validation | [CWE](https) | xxx. | xxx.|
| Syntactic and Semantic data validation | [CWE](https) | xxx. | xxx.|
| Validate Uploaded Files | [CWE](https) | xxx. | xxx.|
| Deserialize Untrusted Data with Proper Controls | [CWE](https) | xxx. | xxx.|

## Access Control
WIP
| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|
| xxx | [CWE](https) | xxx. | xxx.|