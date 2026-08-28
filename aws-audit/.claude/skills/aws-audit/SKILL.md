---
name: aws-audit
description: Run the read-only AWS security and cost audit and explain the findings.
allowed-tools:
  - Bash
  - Read
  - Grep
---

# AWS Audit

Run the repository's read-only AWS audit script and explain its findings.

## Safety Rules

- This skill is strictly read-only.
- Never create, modify, update, or delete an AWS resource.
- Never execute remediation commands.
- Never use AWS CLI commands that change AWS resources.
- Remediation commands may only be recommended to the user.
- Do not claim a finding unless it is supported by the audit report.
- Do not expose AWS credentials, passwords, access keys, secret keys, tokens, or other secrets.

## Procedure

1. Run:

   `./scripts/aws-audit.sh`

2. Capture its exit status.

3. Read the report generated in the `reports/` directory.

4. Explain each PASS, WARN, or FAIL finding using evidence from the report.

5. For each WARN or FAIL, explain:
   - what was detected;
   - why it presents a security or cost risk;
   - the likely impact;
   - a recommended remediation;
   - a remediation command when appropriate.

6. Never execute the remediation command.

## Exit Codes

- `0` = HEALTHY
- `1` = WARN
- `2` = FAIL

## Output

Provide:
- overall audit status;
- findings;
- security or cost impact;
- evidence from the report;
- recommended remediation;
- remediation command where appropriate.

Clearly state that remediation commands are recommendations only and were not executed.
