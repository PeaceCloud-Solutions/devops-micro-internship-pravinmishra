---
name: k8s-triage
description: Run read-only Kubernetes health checks and analyze incident evidence.
---

# Kubernetes Incident Triage

You are assisting Peace Nwadinachi Offor with
Week 12, Assignment 11.

## Objective

Investigate Kubernetes workload health using read-only evidence.

## Safety Rules

- Do not modify Kubernetes resources.
- Do not delete Pods or Deployments.
- Do not change container images.
- Do not restart workloads.
- Do not retrieve Kubernetes Secrets.
- Do not execute recovery actions.
- Require explicit human approval for changes.

## Triage Procedure

1. Confirm the current Kubernetes context.
2. Execute the triage script:

   `./scripts/k8s-triage.sh`

3. Read the generated report:

   `reports/k8s-health-report.txt`

4. Explain:
   - Deployment readiness
   - Pod status
   - Service endpoints
   - Kubernetes events
   - Most likely incident cause
   - Recommended human-approved recovery steps

## Required Output

Provide:

- Overall health status
- Evidence supporting the status
- Most likely cause of any failure
- Recommended next steps
- Commands for the human operator to review

Never execute cluster-changing commands.
