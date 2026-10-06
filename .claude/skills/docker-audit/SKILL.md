---
name: docker-audit
description: Analyze Docker container hardening audit evidence and recommend one safe manual hardening improvement.
---

# Docker Audit

Use the read-only `docker-audit.sh` script to analyze a running Docker container.

## Responsibilities

1. Review the audit findings.
2. Explain each WARN or FAIL finding.
3. Explain the associated security risk.
4. Recommend a manual Dockerfile or Docker Compose fix.
5. Explain how the user can verify the improvement.

## Safety Rules

- Do not edit the Dockerfile.
- Do not edit Docker Compose configuration.
- Do not rebuild images.
- Do not recreate or restart containers.
- Do not expose credentials or environment-variable values.
- Do not make destructive Docker changes.

The user must review and manually apply any recommended hardening change.
