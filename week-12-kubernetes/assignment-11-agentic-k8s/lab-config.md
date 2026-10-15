# Kubernetes Lab Configuration

**Student:** Peace Nwadinachi Offor

## Kubernetes Environment

- Platform: Azure Kubernetes Service (AKS)
- Context: dmi-week12-aks
- Namespace: k8s-triage-lab
- Deployment: triage-demo
- Service: triage-demo
- Pod Selector: app=triage-demo
- Original Image: nginx:stable
- Failure Image: nginx:assignment11-invalid-image

## Existing Book Review Application

- Namespace: book-review
- Deployment: book-review-backend
- Container: backend
- Service: book-review-backend
- Original Image: peacebookreviewacr.azurecr.io/book-review-backend:v2

## Safety Boundaries

- Conduct controlled failures only on the isolated test workload.
- Use read-only commands for investigation.
- Preserve the failure report before recovery.
- Require human approval for cluster-changing actions.
- Verify Deployment, Pod, and Service health after recovery.
- Do not include credentials or Kubernetes Secrets in reports.
