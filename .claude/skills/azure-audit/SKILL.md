---
name: azure-audit
description: Run and explain the read-only Azure security posture audit.
allowed-tools:
  - Bash
  - Read
---

# Azure Audit

Run the existing `azure-audit.sh` script.

Read its generated report and explain:

1. Every PASS finding.
2. Every WARN finding.
3. Every FAIL finding.
4. The security risk associated with each WARN or FAIL.
5. A recommended remediation for human review.

## Safety Requirements

- Do not modify Azure resources.
- Do not use Write.
- Do not edit the audit script.
- Do not execute remediation commands.
- Do not run mutating Azure CLI commands.
- Base every finding on report evidence.
- Never expose credentials, subscription IDs, tenant IDs, tokens, keys, or connection strings.
- Clearly state that remediation must be reviewed and executed by the human operator.