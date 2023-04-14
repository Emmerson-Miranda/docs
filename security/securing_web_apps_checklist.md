# SWAT Checklist
Securing Web Application Technologies - Security best practices that Developers and DevOps should be aware while build applications.

Information in this document can be considered part of **NFR** to be used during design and implementation phases to avoid creating unnecessary technical debt and prevent critical vulnerabilities in your application.

Source: [SWAT Checklist](https://www.sans.org/cloud-security/securing-web-application-technologies/)

Acronyms
- NFR - Non Functional Requirements.
- DoD - Definition of Done.
- OOM - Out Of Memory
- EDA - Event Driven Architectures
- PO  - Product Owner
- CWE - Common Weakness Enumeration, is a community-developed list of software and hardware weakness types. 

## Error Handling and Logging

| Best Practice | CWE | Description | Notes 
|---------------|-----|-------------|------|
| Display Generic Error Messages | [CWE-209](http://cwe.mitre.org/data/definitions/209.html) | Error messages should not reveal sensitive information about its environment, users, or associated data.<br/><br/>An attacker may use the contents of error messages to help launch another, more focused attack.<br/><br/>e.g. Usernames, Passwords, Tokens, Filesystems, Language | Test cases should verify error responses. Furthermore also check successful responses.<br/><br/>Should be part of DoD and code review. Worst case scenario gateways can filter this information. |
|Unhandled Exceptions| [CWE-391](http://cwe.mitre.org/data/definitions/391.html)| Error handlers should be configured to handle unexpected errors and gracefully return controlled output to the user. <br/><br/>Ignoring exceptions and other error conditions may allow an attacker to induce unexpected behavior unnoticed. | Test cases should try to recreate these scenarios ([Chaos Engineering](https://en.wikipedia.org/wiki/Chaos_engineering) may help)|
|Empty Exception Block| [CWE-1069](https://cwe.mitre.org/data/definitions/1069.html) | When an exception handling block (such as a Catch and Finally block) is used, but that block is empty, this can prevent the product from running reliably. | Should be part of DoD. <br/><br/> Static Code Analysis tools can help to check the code (SonarQube, ReSharper...)|
| Uncaught Exception | [CWE-248](https://cwe.mitre.org/data/definitions/248.html) | When an exception is not caught, it may cause the program to crash or expose sensitive information. | Applications use to be build on top of frameworks, those are not except of errors and can fail without allow developers handle exceptions (e.g. OOM). <br/><br/>Worst case scenario gateways can filter this information.<br/><br/>That can be an edge case, in some scenarios performance test can detect this malfunctioning sending large payloads to the target application constantly and in parallel during some period of time.|
|Logging security activities| [CWE-778](https://cwe.mitre.org/data/definitions/778.html) | Any activities or occasions where the user's privilege level changes should be logged. <br/><br/>Any authentication activities, whether successful or not, should be logged. <br/><br/>Any access to sensitive data should be logged. This is particularly important for corporations that have to meet regulatory requirements like HIPAA, PCI, or SOX.| Logging should be part of DoD. <br/><br/>Testing should validate logs are writting for any activity with external systems specially specially in distributed applications (e.g. Microservices, EDA, ...) |
| Do Not Log Sensitive Data | [CWE-532](https://cwe.mitre.org/data/definitions/532.html) | Do not expose sensitive data or sensitive user information in log files, it can break laws such as GDPR/LOPD. <br/><br/>Under HIPAA and PCI, it would be a violation to log sensitive data into the log itself unless the log is encrypted on the disk. | It can be allowed in non-production environments with the purpose of help developers but not in production, as long as sensitive data that identify real users is not used. <br/><br/> Should be part of DoD and verify during PO demo. <br/><br/>Impersonalization data techniques can be used to avoid write sensitive data on the logs.|
| Store Logs Securely | [CWE-533](https://cwe.mitre.org/data/definitions/533.html) | Logs should be stored and maintained appropriately to avoid information loss or tampering by intruder. <br/><br/> Log retention should also follow the retention policy set forth by the organization to meet regulatory requirements and provide enough information for forensic and incident response activities. | Even this was deprecated because is too low level all data at rest should be encrypted (see Data Protection). <br/><br/>Should be a feature provided by default by the platform. <br/><br/>Access to this info should be controlled and allowed only to authorized personnel. |


## Data Protection
| Best Practice | CWE | Description | Notes 
|---------------|-----|-------------|------|
| Encryption data in transit. | [CWE-311](https://cwe.mitre.org/data/definitions/311.html) <br/> [CWE-319](https://cwe.mitre.org/data/definitions/319.html) <br/> [CWE-523](https://cwe.mitre.org/data/definitions/523.html) | All data sensitive or critial information should be encrypted before transmition. <br/><br/>Some examples are: users, passwords, tokens, encryption keys or any information that can help to identify individuals or organizations. | Guarantees data integrity and confidentiality.<br/><br/>  [Zero Trust Security](https://www.cloudflare.com/en-gb/learning/security/glossary/what-is-zero-trust/) and [Service mesh](https://en.wikipedia.org/wiki/Service_mesh) helps to protect access to sensitive information.<br/><br/>  PCI DSS, HIPAA requires all data transfers must be encrypted.  <br/><br/>Technically it makes reference to TLS (HTTPS, SFTP, AMQP/JMS over TLS). <br/><br/> Disable HTTP or redirect to HTTPS. Use the Strict-Transport-Security Header. |
| Encryption data at rest. | [CWE-311](https://cwe.mitre.org/data/definitions/311.html) <br/> [CWE-319](https://cwe.mitre.org/data/definitions/319.html) <br/> [CWE-523](https://cwe.mitre.org/data/definitions/523.html) | All data sensitive or critial information should be encrypted before storage. | Guarantees data integrity and confidentiality. <br/><br/>Technically it makes reference to enable encryption on AWS S3 and Azure Blob.|
| Store passwords securely | [CWE-257](https://cwe.mitre.org/data/definitions/257.html) | User passwords must be stored using secure hashing techniques with strong algorithms. | Hashicorp Vault can store sensitive information securely. <br/><br/> No password should be stored in the code (application, testing, infrastructure). <br/><br/> Mechanisms to scan the code in regularly should be placed or even before push the code to the repositories. |
| Use strong TLS ciphers |  | Weak ciphers must be disabled on all servers. <br/><br/>For example, SSL v2, SSL v3, and TLS protocols prior to 1.2 have known weaknesses and are not considered secure. <br/><br/>Additionally, disable the NULL, RC4, DES, and MD5 cipher suites. Ensure all key lengths are greater than 128 bits, use secure renegotiation, and disable compression. |
| Rotate certificates regulary |  | | It makes more complicated tamper information in case an attacker have a copy of the certificate.|
| Encrypt cache with sensitive information | [CWE-524](https://cwe.mitre.org/data/definitions/524.html) | The code uses a cache that contains sensitive information, but the cache can be read by an actor outside of the intended control sphere. | Encrypt ETCD storage for kubernetes (specially when use secrets with passwords). <br/><br/>Similar approach happen when applications store information in cache (REDIS, EhCache, Coherence,...) | 

## Configuring and Applications
| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|
| Automate Application Deployment | | Automating the deployment of your application, using Continuous Integration and Continuous Deployment, helps to ensure that changes are made in a consistent, repeatable manner in all environments.| No manual changes should be accepted|
| Establish a Rigorous Change Management Process | [CWE-439](https://cwe.mitre.org/data/definitions/439.html) | A rigorous change management process must be maintained during change management operations. For example, new releases should only be deployed after process  | |
| Define Security Requirements | | Engage the business owner to define security requirements for the application. | |
| Conduct a Design Review | [CWE-701](https://cwe.mitre.org/data/definitions/701.html) | Integrating security into the design phase saves money and time. <br/><br/>Conduct a risk review with security professionals and threat model the application to identify key risks. <br/><br/>The helps you integrate appropriate countermeasures into the design and architecture of the application. | |
| Avoid Security by Obscurity | [CWE-656](https://cwe.mitre.org/data/definitions/656.html) | The application should not be protected if the attacker can make reverse engineering. | Security by obscurity can only slow down an attacker and can introduce an undesirable weakness. |
| Perform Code Reviews | [CWE-702](https://cwe.mitre.org/data/definitions/702.html) | Security focused code reviews can be one of the most effective ways to find security bugs. Regularly review your code looking for common issues like SQL Injection and Cross-Site Scripting. | Merge request or PRs to a different team member helps to mitigate this.<br/><br/> Static Code Analysis tools verification can help. |
| Perform Security Testing | | Conduct security testing both during and after development to ensure the application meets security standards. Testing should also be conducted after major releases to ensure vulnerabilities did not get introduced during the update process. | Avoid manual testing process, tests should be repeteable and if possible integrate as part of delivery pipeline. | 
| Store configuration securely | [CWE-15](https://cwe.mitre.org/data/definitions/15.html) | Setting manipulation vulnerabilities occur when an attacker can control values that govern the behavior of the system, manage specific resources, or in some way affect the functionality of the application. | Only authorized users can access and update system configuration. Any update should be audited. |
| Educate the Team on Security | | Training helps define a common language that the team can use to improve the security of the application. <br/><br/> Education should not be confined solely to software developers, testers, and architects. Anyone associated with the development process, such as business analysts and project managers, should all have periodic software security awareness training. | |



## Authentication
WIP
| Best Practice | CWE | Description | Notes |
|---------------|-----|-------------|------|

## Session Management
WIP

## Input and Output Handling
WIP

## Access Control
WIP