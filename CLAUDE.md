# Azure Security Posture Audit

## Project Overview

This workspace contains a read-only security audit for Azure resources deployed during Week 7 of the DevOps Micro Internship.

The audit covers:

- Network Security Groups
- Azure Storage Accounts
- Azure Virtual Machine disk encryption
- Azure Database for MySQL Flexible Server

## Audit Workflow

1. Discover Azure resources using read-only Azure CLI commands.
2. Audit the four required security categories.
3. Record evidence as PASS, WARN, or FAIL.
4. Explain findings based only on evidence produced by the audit.
5. Recommend remediation commands for human review.
6. Never execute remediation automatically.
7. The human operator performs all changes.
8. Re-run the audit after remediation to verify the result.

## Required Security Checks

1. Detect NSG inbound rules exposing TCP 22 or 3389 to 0.0.0.0/0 or equivalent Internet-wide sources.
2. Check whether Storage Accounts permit public blob access.
3. Check Azure VM disk encryption status.
4. Check whether Azure Database for MySQL permits public network access.

## Safety Rules

- Use read-only Azure CLI commands during auditing.
- Never run create, update, delete, set, add, remove, enable, disable, or other mutating commands.
- Never modify Azure resources automatically.
- Never claim a security finding without evidence from the audit report.
- Never expose subscription IDs, tenant IDs, secrets, passwords, keys, tokens, or connection strings.
- Remediation commands may be recommended but must never be executed by Claude.
- A human must review and execute every remediation.
- Re-run the read-only audit after human remediation.