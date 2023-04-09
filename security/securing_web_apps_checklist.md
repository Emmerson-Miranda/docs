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

## Error Handling and Logging

| Best Practice | CWE | Description | Notes 
|---------------|-----|-------------|------|
| Display Generic Error Messages | [CWE-209](http://cwe.mitre.org/data/definitions/209.html) | Error messages should not reveal sensitive information about its environment, users, or associated data.<br/><br/>An attacker may use the contents of error messages to help launch another, more focused attack.<br/><br/>e.g. Usernames, Passwords, Tokens, Filesystems, Language | Test cases should verify error responses. Furthermore also check successful responses.<br/><br/>Should be part of DoD and code review. Worst case scenario gateways can filter this information. |
|Unhandled Exceptions| [CWE-391](http://cwe.mitre.org/data/definitions/391.html)| Error handlers should be configured to handle unexpected errors and gracefully return controlled output to the user. <br/><br/>Ignoring exceptions and other error conditions may allow an attacker to induce unexpected behavior unnoticed. | Test cases should try to recreate these scenarios ([Chaos Engineering](https://en.wikipedia.org/wiki/Chaos_engineering) may help)|
|Empty Exception Block| [CWE-1069](https://cwe.mitre.org/data/definitions/1069.html) | When an exception handling block (such as a Catch and Finally block) is used, but that block is empty, this can prevent the product from running reliably. | Should be part of DoD. <br/><br/> Static Code Analysis tools can help to check the code (SonarQube, ReSharper...)|
| Uncaught Exception | [CWE-248](https://cwe.mitre.org/data/definitions/248.html) | When an exception is not caught, it may cause the program to crash or expose sensitive information. | Applications use to be build on top of frameworks, those are not except of errors and can fail without allow developers handle exceptions (e.g. OOM). <br/><br/>Worst case scenario gateways can filter this information.<br/><br/>That can be an edge case, in some scenarios performance test can detect this malfunctioning sending large payloads to the target application constantly and in parallel during some period of time.|
|Logging security activities| [CWE-778](https://cwe.mitre.org/data/definitions/778.html) | Any activities or occasions where the user's privilege level changes should be logged. <br/><br/>Any authentication activities, whether successful or not, should be logged. <br/><br/>Any access to sensitive data should be logged. This is particularly important for corporations that have to meet regulatory requirements like HIPAA, PCI, or SOX.| Logging should be part of DoD. <br/><br/>Testing should validate logs are writting for any activity with external systems specially specially in distributed applications (e.g. Microservices, EDA, ...) |
| Do Not Log Sensitive Data | [CWE-532](https://cwe.mitre.org/data/definitions/532.html) | Do not expose sensitive data or sensitive user information in log files, it can break laws such as GDPR/LOPD. <br/><br/>Under HIPAA and PCI, it would be a violation to log sensitive data into the log itself unless the log is encrypted on the disk. | It can be allowed in non-production environments with the purpose of help developers but not in production, as long as sensitive data that identify real users is not used. <br/><br/> Should be part of DoD and verify during PO demo. <br/><br/>Impersonalization data techniques can be used to avoid write sensitive data on the logs.|
| Store Logs Securely | [CWE-533](https://cwe.mitre.org/data/definitions/533.html) | Logs should be stored and maintained appropriately to avoid information loss or tampering by intruder. <br/><br/> Log retention should also follow the retention policy set forth by the organization to meet regulatory requirements and provide enough information for forensic and incident response activities. | Even this was deprecated because is too low level all data at rest should be encrypted. <br/><br/>Should be a feature provided by default by the platform. <br/><br/>Access to this info should be controlled and allowed only to authorized personnel. |


## Data Protection
WIP

## Configuring and applications
WIP

## Authentication
WIP

## Session Management
WIP

## Input and Output Handling
WIP

## Access Control
WIP