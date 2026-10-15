# Kubernetes Incident Summary

**Full Name:** Peace Nwadinachi Offor
**Program:** DevOps Micro Internship (DMI) with Agentic AI
**Week:** 12
**Assignment:** 11 — AI-Assisted Kubernetes Incident Triage
**Platform:** Azure Kubernetes Service (AKS)
**Kubernetes Context:** `dmi-week12-aks`
**Namespace:** `k8s-triage-lab`
**Deployment:** `triage-demo`
**Service:** `triage-demo`
**Incident Date:** October 15, 2026

## 1. Reported Symptom

During my Kubernetes incident-triage exercise, I introduced a controlled container image failure in an isolated test Deployment.

I changed the test workload from its original image, `nginx:stable`, to an invalid image tag, `nginx:assignment11-invalid-image`.

Kubernetes attempted to create a replacement Pod but could not retrieve the specified image.

The replacement Pod, `triage-demo-6d7ccdfbdb-qbjdw`, remained in `ImagePullBackOff` with `0/1` readiness.

However, the original Pod, `triage-demo-5544457d7b-j7w7b`, remained healthy with `1/1` readiness.

This demonstrated that a failed Kubernetes rolling update does not necessarily interrupt an application's existing healthy Service backends.

## 2. Evidence Collected

I collected evidence using Kubernetes diagnostic commands and the Bash triage script.

The investigation included:

* Deployment readiness checks.
* Pod status and readiness inspection.
* Kubernetes event analysis.
* Service endpoint verification.
* EndpointSlice inspection.
* Deployment rollout verification.
* Saved failure and recovery reports.

### Failed Pod

`triage-demo-6d7ccdfbdb-qbjdw`

**Status:** `ImagePullBackOff`
**Readiness:** `0/1`

### Original Healthy Pod

`triage-demo-5544457d7b-j7w7b`

**Status:** `Running`
**Readiness:** `1/1`

### Deployment Readiness

The Deployment displayed:

`READY: 1/1`

Although the Deployment retained one ready replica, the replacement Pod failed to start.

### Service Endpoint

The Service retained the following ready backend:

`10.244.0.188:80`

This showed that traffic could still be directed to the existing healthy Pod.

### Kubernetes Events

The event logs recorded:

* `ErrImagePull`
* `ImagePullBackOff`
* Failure to retrieve the invalid image tag.
* Repeated attempts to pull the unavailable image.

The failure report was preserved in:

`reports/incident-failure-report.txt`

### Triage Script Limitation

The initial failure report returned a `HEALTHY` result because the existing Pod and Service endpoint remained ready.

However, the report also contained clear evidence that the replacement Pod was experiencing `ImagePullBackOff`.

This highlighted an important limitation of relying only on ready replica counts and Service endpoints when diagnosing failed rolling updates.

A more complete triage process should also examine Deployment rollout progress and individual container waiting states.

## 3. Most Likely Cause

The incident was caused by an invalid container image reference.

The Deployment attempted to use:

`nginx:assignment11-invalid-image`

Kubernetes reported that the image could not be found.

As a result, the replacement Pod could not start and remained in `ImagePullBackOff`.

The evidence supported an image availability problem rather than an application crash or a readiness probe failure.

## 4. Human-Approved Recovery Action

The recovery involved restoring the original container image:

`nginx:stable`

The recovery procedure used for the exercise was to update the test Deployment back to the original image and allow Kubernetes to reconcile the workload.

The corresponding manual recovery command is:

```bash
kubectl set image deployment/triage-demo \
  nginx=nginx:stable \
  -n k8s-triage-lab
```

The saved Kubernetes events subsequently showed that the failed replacement Pod was deleted and its ReplicaSet scaled down to zero.

Claude Code's role in the assignment was to support investigation and recommend recovery actions. Cluster-changing actions were reserved for human review and execution.

## 5. Verification

Following recovery, I verified the Deployment, Pod, Service, endpoints, and rollout status.

### Deployment Status

`triage-demo`

**READY:** `1/1`
**UP-TO-DATE:** `1`
**AVAILABLE:** `1`

### Recovered Pod

`triage-demo-5544457d7b-j7w7b`

**READY:** `1/1`
**STATUS:** `Running`
**RESTARTS:** `0`

### Service Endpoint

The Service had a ready endpoint:

`10.244.0.188:80`

### Rollout Verification

The rollout status command returned:

`deployment "triage-demo" successfully rolled out`

### Recovery Report

The recovery report was saved as:

`reports/recovery-report.txt`

Its final health assessment was:

Recovery Report Exit Code: 0 (HEALTHY) — The Kubernetes triage script completed successfully. The Deployment had 1/1 ready replicas, the Pod was running, and the Service had a ready backend endpoint.`HEALTHY: Deployment and Service backends are ready.`

The recovery report still contained historical image-pull failure events. These referred to the earlier incident and did not represent an ongoing Pod failure.

The report also contained Kubernetes API deprecation warnings for the traditional Endpoints resource. EndpointSlices were available and provided the corresponding backend information.

The successful rollout, healthy Pod, and ready Service endpoint confirmed that the test workload had recovered.

## 6. Safety Decision

I conducted the controlled failure in the isolated `k8s-triage-lab` namespace instead of deliberately disrupting my existing Book Review application.

Before introducing the failure, I identified the original container image so that the test workload could be restored.

I used a human-in-the-loop approach in which Claude Code was assigned to evidence gathering, investigation, and recommendations.

Cluster-changing commands required human review.

I also avoided including Kubernetes Secrets, authentication tokens, credentials, or other sensitive configuration details in my assignment evidence.

## 7. Agentic Loop Mapping

### Observe

I collected Kubernetes Deployment, Pod, Service, and event information to understand the initial workload state.

### Investigate

I used read-only Kubernetes commands and the Bash triage script to gather evidence about the failed replacement Pod.

### Reason

The image-pull errors helped identify the invalid container image as the most likely cause.

### Recommend

Claude Code was used as an investigation assistant to help interpret the evidence and recommend recovery steps.

### Human Approval

The recovery action was reviewed before making changes to the Kubernetes Deployment.

### Act

The test Deployment's original container image was restored through a manual recovery procedure.

### Verify

I checked the Deployment rollout, Pod readiness, Service endpoints, and saved recovery report to confirm that the workload returned to a healthy state.

## Conclusion

This assignment strengthened my understanding of Kubernetes incident investigation, image-pull failures, rolling-update behavior, and Service endpoint availability.

One particularly important lesson was that a Deployment can retain healthy replicas while a replacement Pod fails.

I also learned that automated health checks must examine more than the availability of existing replicas to detect incomplete rollouts.

The exercise demonstrated how AI-assisted troubleshooting can support incident response while keeping operational decisions and recovery actions under human control.

