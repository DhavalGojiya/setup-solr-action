# Security Policy

We take security seriously. Please follow this policy to report vulnerabilities in **setup-solr-action**.

> Screenshot of security file location in the repo:

![Security Tab](https://raw.githubusercontent.com/DhavalGojiya/setup-solr-action/main/assets/images/security-tab.png)

## Supported Versions

We accept reports for the `main` branch and latest releases.

## Reporting a Vulnerability

Do **not** open a public issue with exploit details. Instead:

- Open a private GitHub Security Advisory
- Or email: `dhavalgojiya10+security@gmail.com`

Include:

- Affected version/branch
- Steps to reproduce / proof of concept
- Expected vs actual behavior
- Impact / attack surface
- Suggested fix / mitigation
- Contact preference & disclosure timeline

## What to Expect

- Acknowledgement within 3 business days
- Triage and severity assessment
- Fix or mitigation, coordinated disclosure
- CVE assignment when applicable

## Severity Levels

- **Critical**: remote code execution, privilege escalation
- **High**: serious data leakage, authentication bypass
- **Medium**: limited info disclosure or DoS
- **Low**: minor or cosmetic issues

## Recommendations for Users

- Pin the action by SHA or version
- Run in minimal-privilege environments
- Limit secrets access and rotate regularly
- Keep your CI and Solr environment updated

_Last updated: 2025-10-08_
