---
name: tf-drift-review
description: Run the read-only Terraform drift-and-policy check, analyze the evidence for destructive changes and unsafe ingress rules, and recommend whether terraform apply appears safe. Never runs terraform apply or destroy.
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

# Terraform Drift Review Skill

## Purpose

Perform a read-only review of the Terraform environment.

Follow this workflow:

1. Read `CLAUDE.md`.
2. Run:

   ```bash
   bash "AI Assignment/tf-drift-check.sh"
