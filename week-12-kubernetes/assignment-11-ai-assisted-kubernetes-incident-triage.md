# Assignment 11 — AI-Assisted Kubernetes Incident Triage

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Configure a read-only Bash triage script for your Book Review App, connect it to Claude Code through `/k8s-triage`, simulate one controlled failure, recover the application manually, and verify recovery.

**Workflow: Gather → Analyze → Human Act → Verify**

---

## Submission Details

**Full Name:** Offor Peace Nwadinachi.

**Kubernetes Platform:** Azure Kubernetes Service (AKS).

**Selected Workload:** triage-demo Deployment.

**Namespace:** k8s-triage-lab.

**GitHub Repository URL:** [GitHub repository URL](https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra).

**Simulated Incident:** Invalid container image (nginx:assignment11-invalid-image), resulting in ErrImagePull and ImagePullBackOff.

**Baseline Status:** HEALTHY — The original NGINX Pod was running and ready, and the Service had a ready backend endpoint.

**Recovery Status:** HEALTHY — The Deployment returned to 1/1 readiness, the Pod was running with zero restarts, the Service retained its healthy endpoint, and the latest triage verification returned exit code 0.

---

# Task 1 — Discover the Application and Capture a Healthy Baseline

## Goal

Identify the actual application configuration and prove that the selected workload is healthy before incident simulation.

### Evidence

#### Screenshot 1 — Healthy Pods and ready Service backends

![Task 1.A](<screenshots/week 12-assignment 11-screenshot -1.png>).

---

#### Screenshot 2 — Workspace directory structure

![Task 1.B](<screenshots/week 12-assignment 11-screenshot -2.png>).

### Notes

**1. What proves the selected Pods are ready, not merely running?**

I verified Pod readiness using kubectl get pods -n k8s-triage-lab. The original triage-demo Pod displayed 1/1 under the READY column and Running under STATUS.

The 1/1 readiness value confirmed that the Pod's container was ready to serve traffic, rather than simply being in the Running phase. I also checked the Deployment, which showed 1/1 ready replicas.

This distinction is important because a Pod can be running while its application is still initializing or failing readiness checks.

**2. What proves the Service has ready backends?**

I verified the Service backends using kubectl get endpoints triage-demo -n k8s-triage-lab.

The output showed the ready endpoint 10.244.0.188:80, confirming that the Service had an available Pod backend.

I also inspected the EndpointSlice, which listed the corresponding backend address.

This demonstrated that the Service could route traffic to the healthy application Pod.

**3. Why must the original image be recorded before incident simulation?**

Recording the original image provides a known working configuration that can be restored if the simulated incident causes the Deployment to fail.

For this assignment, the original image was nginx:stable. I recorded it before introducing the invalid image tag, nginx:assignment11-invalid-image.

Knowing the original image made it possible to restore the test Deployment without guessing which container version had previously worked.

This is an important precaution when performing controlled failure testing in Kubernetes.

---

# Task 2 — Configure CLAUDE.md

## Goal

Define the project configuration, incident workflow, and safety boundary for Claude Code.

### Evidence

#### Screenshot 3 — CLAUDE.md showing application configuration, workflow, safety rules, and output rules

![Task 2](<screenshots/week 12-assignment 11-screenshot -3.png>).

### Notes

**1. Why does Claude need project-specific cluster rules?**

Claude Code needs project-specific rules to understand the Kubernetes environment, selected workload, namespace, and operational boundaries before performing incident analysis.

In this assignment, the configuration identified the AKS environment, the k8s-triage-lab namespace, and the triage-demo Deployment.

These instructions helped keep the investigation focused on the intended workload and reduced the risk of diagnosing or modifying unrelated Kubernetes resources.

**2. Why must a human execute recovery commands?**

A human must execute recovery commands because Kubernetes changes can affect application availability, active workloads, and other resources.

Although Claude Code can analyze diagnostic evidence and recommend corrective actions, it may not have enough operational context to determine whether a change is safe.

Keeping recovery actions under human control allows the operator to review the proposed command, confirm the root cause, assess possible risks, and approve the change before execution.

**3. Which rule prevents an unsupported diagnosis?**

The evidence-based diagnosis rule prevents Claude Code from presenting assumptions as confirmed causes.

Claude should identify a root cause only when it is supported by actual Kubernetes outputs, such as Pod conditions, Deployment status, and event logs.

If the available evidence is insufficient, Claude should explain the uncertainty and recommend additional read-only checks rather than inventing a diagnosis.

In this incident, the ErrImagePull and ImagePullBackOff events supported the conclusion that the replacement Pod could not retrieve the invalid container image.

---

# Task 3 — Plan the Read-Only Triage Workflow

## Goal

Ask Claude Code to explain the five health checks before running the supplied script.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check read-only plan

![Task 3](<screenshots/week 12-assignment 11-screenshot -4.png>).

### Notes

**1. Which part represents the Gather phase?**

The Gather phase involves collecting Kubernetes evidence before attempting to diagnose or resolve the incident.

In my workflow, this included inspecting the Deployment, checking Pod status and readiness, reviewing container restarts, examining Kubernetes events, and verifying Service backends.

Read-only commands such as kubectl get, kubectl describe, and kubectl logs help collect the information required for evidence-based incident analysis.

The gathered evidence provides the foundation for identifying possible causes and recommending recovery actions.

**2. How did you verify that Claude did not change anything?**

I restricted Claude Code's role to planning, evidence gathering, and analysis, while keeping cluster-changing commands under human control.

The read-only workflow used diagnostic commands rather than operations such as kubectl apply, kubectl delete, kubectl scale, or kubectl set image.

To verify that no unintended changes occurred, I could compare the Deployment configuration, container image, replica count, and Pod status before and after the analysis.

The absence of unexpected configuration changes would confirm that the investigation remained read-only.

**3. Why is planning before coding useful for incident triage?**

Planning before coding helps establish which Kubernetes resources need to be checked, what evidence should be collected, and how the results should be interpreted.

It also allows safety boundaries to be defined before executing commands.

For this assignment, the read-only plan organized the investigation around Deployment health, Pod readiness, container restarts, Kubernetes events, and Service backends.

This made the triage process more structured and reduced the risk of making unnecessary changes before understanding the incident.

---

# Task 4 — Configure and Validate the Bash Script

## Goal

Configure the supplied triage script for the selected workload and validate its syntax.

### Evidence

#### Screenshot 5 — Script configuration variables and checks array

![Task 4.A](<screenshots/week 12-assignment 11-screenshot -5.png>).

---

#### Screenshot 6 — Functions for status, readiness, restarts, events, and Service backends

![Task 4.B](<screenshots/week 12-assignment 11-screenshot -6.png>).

---

#### Screenshot 7 — Preflight, summary, and exit-code logic

![Task 4.C](<screenshots/week 12-assignment 11-screenshot 7.png>).

---

#### Screenshot 8 — Successful syntax validation and executable permission

![Task 4.D](<screenshots/week 12-assignment 11-screenshot -8.png>).

### Notes

**1. Why must the script fail when no Pods match the configured selector?**

The script must report a failure when no Pods match the configured selector because it cannot verify workload health without identifying the intended Pods.

An incorrect selector could cause the script to inspect the wrong resources or incorrectly report a healthy state.

Treating an empty Pod selection as a failure ensures that missing workloads and configuration mistakes are not overlooked.

**2. How does the readiness check detect a running but unready Pod?**

A readiness check examines the Pod's READY value or container readiness conditions rather than relying only on its Running status.

For example, a Pod displaying 0/1 readiness is not ready to serve traffic, even if its phase is Running.

By comparing ready containers with the expected number of containers, the script can identify workloads that have started but are not yet available to receive traffic.

This distinction is important because a running process does not necessarily mean that an application is healthy.

**3. Why are Service backends checked separately from Pod health?**

Service backends must be checked separately because healthy Pods do not automatically guarantee that a Kubernetes Service can route traffic to them.

A Service may have an incorrect selector, mismatched labels, or no ready endpoints.

Checking the Service endpoints and EndpointSlices confirms whether Kubernetes has identified suitable backend Pods for traffic routing.

During my incident, the original Pod remained ready, and the Service retained the endpoint 10.244.0.188:80, even though the replacement Pod failed.

**4. What do exit codes 0, 1, and 2 represent?**

The intended triage-script exit codes represent different health outcomes:

Exit code 0 — HEALTHY: The required health checks passed.
Exit code 1 — WARN: A warning condition was detected that requires attention but does not necessarily indicate complete workload failure.
Exit code 2 — FAIL: A critical health check failed or the workload could not be verified successfully.

These exit codes allow the script's results to be interpreted consistently and can support automated reporting or monitoring.

During my latest recovery verification, the script returned exit code 0, confirming that its configured health checks passed.

---

# Task 5 — Run the Healthy Baseline Report

## Goal

Run the script on the healthy application and confirm that it contains no failed checks.

### Evidence

#### Screenshot 9 — Baseline report showing your full name and all checks

![Task 5.A](<screenshots/week 12-assignment 11-screenshot -9.png>).

---

#### Screenshot 10 — Captured exit code and final summary

![Task 5.B](<screenshots/week 12-assignment 11-screenshot -10.pngpng>).

### Notes

**1. What is the baseline status?**

My baseline status was HEALTHY.

Before introducing the controlled incident, the triage-demo Deployment had one ready replica, and the original NGINX Pod was running successfully using the nginx:stable image.

The Service also had an available backend endpoint, confirming that the test workload was operational before failure simulation.

Establishing this baseline allowed me to compare the healthy state with the subsequent incident and recovery results.

**2. Which evidence proves the Service has a ready backend?**

The Kubernetes Service endpoint output showed 10.244.0.188:80.

This confirmed that the triage-demo Service had a ready backend associated with the healthy NGINX Pod.

The EndpointSlice output provided additional evidence of the backend address.

These results demonstrated that Kubernetes had an available destination for traffic routed through the Service.

**3. What is the difference between a warning and a failure?**

A warning indicates a condition that requires attention but may not prevent the workload from operating.

For example, the Kubernetes Endpoints API deprecation warning indicated that EndpointSlices should be preferred, but it did not mean that the application was unavailable.

A failure indicates that an important health condition has not been met.

During my incident, the replacement Pod entered ImagePullBackOff because Kubernetes could not retrieve its container image.

Although the original Pod remained available, the failed replacement Pod represented an unresolved deployment-update problem.

This demonstrated why warning and failure conditions should be evaluated using the actual workload state and supporting evidence.

---

# Task 6 — Configure and Run the Claude Code Skill

## Goal

Connect the Bash script to a manually invoked Claude Code evidence-analysis workflow.

### Evidence

#### Screenshot 11 — SKILL.md showing frontmatter and safety rules

![Task 6.A](<screenshots/week 12-assignment 11-screenshot -11.png>).

---

#### Screenshot 12 — Baseline `/k8s-triage` analysis

![Task 6.B](<screenshots/week 12-assignment 11-screenshot -12.A.png>)
![Task 6.B](<screenshots/week 12-assignment 11-screenshot -12.B.png>).

### Notes

**1. What does Bash do in this workflow?**

Bash performs the repeatable Kubernetes health checks and collects diagnostic evidence.

The triage script examines the selected Deployment, Pod status, readiness, Service backends, and Kubernetes events.

It also generates a report that can be saved and reviewed later.

Using Bash makes the evidence-gathering process consistent and reduces the need to manually repeat the same diagnostic commands.

**2. What does Claude do in this workflow?**

Claude Code supports the investigation by interpreting the evidence collected by the Bash script.

It helps identify unusual conditions, explain possible causes, and recommend additional diagnostic checks or recovery actions.

For example, the ErrImagePull and ImagePullBackOff events provided evidence that the replacement Pod could not retrieve its configured container image.

Claude's role was to assist with reasoning and recommendations while leaving recovery decisions and execution under human control.

**3. Why are instructions alone insufficient to guarantee read-only access?**

nstructions describe the expected behavior of an AI assistant, but they do not technically prevent the assistant from executing commands if it has permission to do so.

For stronger protection, read-only instructions should be combined with restricted tool permissions, appropriate Kubernetes RBAC roles, and human approval requirements.

This creates an additional security boundary between the AI assistant's recommendations and potentially disruptive cluster operations.

The assignment reinforced the importance of enforcing safety through both written instructions and technical access controls.

---

# Task 7 — Simulate One Controlled Incident

## Goal

Create one controlled failure, save its evidence, and let Claude analyze it without executing recovery.

### Evidence

#### Screenshot 13 — Failed or unready Pod evidence and current Service backends

![Task 7.A](<screenshots/week 12-assignment 11-screenshot -13.png>).

---

#### Screenshot 14 — Failed `/k8s-triage` analysis with evidence and a suggested manual recovery command

![Task 7.B](<screenshots/week 12-assignment 11-screenshot -14.A.png>)
![Task 7.B](<screenshots/week 12-assignment 11-screenshot -14.B.png>)
![Task 7.B](<screenshots/week 12-assignment 11-screenshot -14.C.png>).

---

#### Screenshot 15 — Saved `incident-failure-report.txt`

![Task 7.C](<screenshots/week 12-assignment 11-screenshot -15.png>).

### Notes

**1. Which failure did you choose?**

I chose to simulate an invalid container image failure in my AKS environment.

I changed the triage-demo Deployment from its original working image, nginx:stable, to the invalid image tag nginx:assignment11-invalid-image.

Kubernetes attempted to create a replacement Pod, but the image could not be retrieved.

As a result, the replacement Pod entered the ImagePullBackOff state.

This allowed me to investigate a realistic deployment failure without intentionally disrupting my existing Book Review application.

**2. Which checks failed, and what evidence proved it?**

The replacement Pod failed the container image retrieval and readiness checks.

The Pod displayed 0/1 readiness with the status ImagePullBackOff.

Kubernetes events recorded ErrImagePull and ImagePullBackOff, including an error indicating that the configured image could not be found.

However, the original Pod remained healthy with 1/1 readiness, and the Service retained its available backend endpoint.

The Bash triage script initially reported the overall workload as healthy because it checked ready replicas and Service availability without detecting the failed replacement Pod.

This revealed a limitation in the script's failure-detection logic and demonstrated the importance of examining individual Pod states and rollout progress.

**3. Did Claude execute recovery? Why is that important?**

Claude Code was used to support evidence gathering, incident analysis, and recovery recommendations rather than independently performing the recovery.

I retained responsibility for reviewing the evidence and manually applying the corrective action.

This distinction is important because automated cluster changes can introduce operational risks if the diagnosis is incomplete or incorrect.

Keeping a human involved ensures that recovery actions are reviewed and approved before affecting Kubernetes resources.

**4. Why might the Service retain ready backends during the incident?**

The Service retained ready backends because Kubernetes preserved the original healthy Pod while attempting to create the replacement Pod.

Although the new Pod entered ImagePullBackOff, the original Pod continued running with 1/1 readiness.

The Service therefore retained its healthy endpoint at 10.244.0.188:80.

This behavior demonstrated how Kubernetes rolling updates can preserve application availability even when a replacement Pod fails to start.

It also highlighted why Service availability alone is not sufficient to confirm that a Deployment rollout has succeeded.

---

# Task 8 — Recover Manually and Verify

## Goal

Restore the healthy configuration yourself and verify recovery using a second triage report.

### Evidence

#### Screenshot 16 — Recovered Pods and ready Service backends

![Task 8.A](<screenshots/week 12-assignment 11-screenshot -16.png>).

---

#### Screenshot 17 — Recovered `/k8s-triage` analysis

![Task 8.B](<screenshots/week 12-assignment 11-screenshot -17.png>).

---

#### Screenshot 18 — Reports directory showing failure and recovery reports

![Task 8.C](<screenshots/week 12-assignment 11-screenshot -18.png>).

---

#### Screenshot 19 — `incident-summary.md` with all required sections

![Task 8.D](<screenshots/week 12-assignment 11-screenshot -19.A.png>)
![Task 8.D](<screenshots/week 12-assignment 11-screenshot -19.B.png>).

### Notes

**1. What manual recovery action did you execute?**

After identifying the invalid container image as the cause of the incident, I restored the triage-demo Deployment to its original working image, nginx:stable, within the k8s-triage-lab namespace.

The recovery procedure involved updating the Deployment's container image using kubectl set image deployment/triage-demo nginx=nginx:stable -n k8s-triage-lab.

Following this correction, Kubernetes removed the failed replacement Pod and scaled down its ReplicaSet. I then checked the Deployment rollout to confirm that the workload had returned to its intended configuration.

This recovery process reinforced the importance of identifying the root cause before applying corrective changes to a Kubernetes workload.

**2. What proves the workload recovered?**

I confirmed the recovery by checking the Deployment, Pod status, Service endpoints, and rollout results.

The triage-demo Deployment returned to 1/1 readiness, while the remaining Pod was running with zero restarts. The Service retained a healthy endpoint at 10.244.0.188:80.

The rollout verification returned deployment "triage-demo" successfully rolled out.

Additionally, the saved recovery report confirmed that the Deployment and Service backends were healthy. A subsequent execution of the Bash triage script returned an exit code of 0 (HEALTHY).

Together, these results provided evidence that the controlled incident had been resolved.

**3. Why is the second triage run necessary?**

The second triage run was necessary to verify that the recovery action had resolved the incident rather than simply assuming the Deployment was healthy after changing its configuration.

By running the triage script again, I could compare the initial failure evidence with the recovered workload's current state.

The second run confirmed that the Deployment had 1/1 ready replicas, the Pod was running successfully, and the Service had a ready backend endpoint.

It also helped distinguish historical Kubernetes warning events from active failures.

This reinforced the importance of verifying recovery through fresh diagnostic evidence before closing an incident.

**4. Why should AI not automatically restart every failing production workload?**

AI should not automatically restart every failing production workload because a restart does not necessarily resolve the underlying problem and may introduce additional risks.

For example, the incident I investigated was caused by an invalid container image reference. Restarting the affected Pod would not make the unavailable image accessible, so the failure would likely continue.

In production environments, unnecessary restarts can interrupt healthy services, affect active users, and potentially cause data loss or additional instability.

AI-assisted tools should therefore focus on collecting evidence, identifying possible causes, and recommending appropriate recovery actions. Human approval should be required before executing potentially disruptive operations.

This approach ensures that recovery decisions are based on verified evidence, operational context, and an understanding of the potential consequences.

### Remaining WARN Results

Explain any WARN results remaining after recovery, or write “None.”

Following recovery, the Kubernetes triage script confirmed that the Deployment and Service backends were healthy, and the latest verification returned an exit code of 0.

However, the original recovery report contained Kubernetes Endpoints API deprecation warnings and historical ErrImagePull and ImagePullBackOff events.

The deprecation warnings indicated that the traditional Endpoints API is being replaced by EndpointSlices. This was not an application failure because the EndpointSlice still contained the healthy backend.

The image-pull warnings referred to the earlier controlled incident. The failed replacement Pod had already been removed, and the Deployment successfully completed its rollout.

A later triage run showed no Kubernetes events in the test namespace.

Therefore, no active workload failure warnings remained after recovery. The warnings preserved in the original report were historical or related to API deprecation rather than an unresolved application incident.

---

# Task 9 — Publish Your Kubernetes Incident-Triage Workflow on LinkedIn

## Goal

Share the incident-triage workflow you completed and explain the role of human control.

### Evidence

#### Screenshot 20 — Published LinkedIn post about your Kubernetes incident-triage workflow

![Task 9](<screenshots/week 12-assignment 11-screenshot -20.png>).

### LinkedIn Post URL

[LinkedIn Post URL](https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-kubernetes-devops-ugcPost-7516390597448859649-faaW/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ).

---

# Required Project Files

Include these files in your project repository:

- `CLAUDE.md`
- `lab-config.md`
- `scripts/k8s-triage.sh`
- `.claude/skills/k8s-triage/SKILL.md`
- `reports/incident-failure-report.txt`
- `reports/recovery-report.txt`
- `incident-summary.md`

Your `incident-summary.md` must contain:

1. Reported Symptom
2. Evidence Collected
3. Most Likely Cause
4. Human-Approved Recovery Action
5. Verification
6. Safety Decision
7. Agentic Loop Mapping

---

# Final Summary

## Evidence and Cause

Summarize the evidence and the supported cause of the incident.

## Evidence and Cause

During this assignment, I investigated a controlled Kubernetes incident in my AKS environment using diagnostic commands and a Bash triage script. I introduced an invalid container image, `nginx:assignment11-invalid-image`, into the `triage-demo` Deployment within the `k8s-triage-lab` namespace.

The investigation revealed that the replacement Pod entered the `ImagePullBackOff` state because Kubernetes could not retrieve the specified image. The event logs confirmed `ErrImagePull` and `ImagePullBackOff` errors, identifying the invalid image reference as the root cause.

However, the original Pod remained healthy with `1/1` readiness, and the Service retained its available endpoint at `10.244.0.188:80`. Interestingly, the triage script initially reported the Deployment as healthy despite the failed replacement Pod. This highlighted the importance of examining individual Pod states and Kubernetes events rather than relying solely on Deployment readiness and Service availability.

The evidence confirmed that the incident resulted from an unavailable container image, demonstrating how a failed rolling update can occur while an existing application Pod continues serving traffic.

## Manual Recovery

Describe the command or configuration change you performed.

After identifying the invalid container image as the cause of the incident, I restored the `triage-demo` Deployment to its original working image, `nginx:stable`.

The manual recovery command was:

```bash
kubectl set image deployment/triage-demo \
  nginx=nginx:stable \
  -n k8s-triage-lab
```

This configuration change allowed Kubernetes to restore the intended Deployment state. The failed replacement Pod was subsequently removed, and its ReplicaSet was scaled down to zero.

I then verified the Deployment rollout using:

```bash
kubectl rollout status deployment/triage-demo \
  -n k8s-triage-lab \
  --timeout=180s
```

The command returned `deployment "triage-demo" successfully rolled out`, confirming that the Deployment had recovered.

This exercise reinforced the importance of reviewing diagnostic evidence before applying corrective changes. I maintained human control over the recovery process, using Claude Code for investigation and recommendations rather than allowing it to make changes automatically.

## Verification

Explain how the recovery report and Kubernetes outputs confirmed recovery.

After performing the manual recovery, I verified the health of the Kubernetes Deployment, Pods, and Service using diagnostic commands and my Bash triage script.

The Kubernetes outputs confirmed that the `triage-demo` Deployment had returned to `1/1` readiness, with one available and up-to-date replica. The remaining Pod was running successfully with zero restarts, while the Service retained its healthy endpoint at `10.244.0.188:80`.

I also executed `kubectl rollout status deployment/triage-demo -n k8s-triage-lab --timeout=180s`, which returned `deployment "triage-demo" successfully rolled out`.

The saved recovery report, `reports/recovery-report.txt`, confirmed that the Deployment and Service backends were healthy. A subsequent verification using my triage script returned an exit code of `0 (HEALTHY)`, providing additional evidence that the workload had recovered.

Although the original recovery report contained historical `ImagePullBackOff` events and Kubernetes Endpoints API deprecation warnings, the current Pod status, Service availability, and successful rollout confirmed that the incident was resolved.

This verification process reinforced the importance of checking multiple Kuber.

## Safety Decision

Explain how you kept Claude’s role limited to evidence gathering and analysis.

Throughout this assignment, I followed a human-in-the-loop approach to Kubernetes incident management, ensuring that Claude Code's role remained limited to evidence gathering, analysis, and recommending possible recovery actions.

I configured the instructions in `CLAUDE.md` to establish safety boundaries and prioritize read-only diagnostic commands such as `kubectl get`, `kubectl describe`, and `kubectl logs`. This allowed me to investigate the Deployment, Pod status, Kubernetes events, and Service endpoints without granting Claude Code permission to modify cluster resources.

To minimize operational risks, I introduced the controlled failure within the isolated `k8s-triage-lab` namespace rather than disrupting my existing Book Review application. I also preserved the original incident report before performing recovery, ensuring that the evidence remained available for review.

After identifying the invalid container image as the cause, I retained responsibility for reviewing and manually executing the recovery action. Claude Code supported the investigation but did not independently perform deployment updates, rollbacks, or other cluster-changing operations.

This exercise reinforced the importance of maintaining human oversight when using AI-assisted troubleshooting tools, particularly in.

---

# Submission Instructions

- Include all 20 required screenshots under their corresponding Evidence sections.
- Complete all Notes questions in your own words.
- Include the required project files in your linked repository.
- Include your published LinkedIn post URL.
- Use clear, readable screenshots showing relevant commands, configuration, and outputs.
- Display your full name before taking required terminal screenshots.
- Preserve the failure report before recovery.
- Ensure the baseline and recovery reports contain no FAIL results.
- Explain any WARN results remaining after recovery.
- Review reports, logs, configuration records, and screenshots before publishing.
- Do not expose credentials, kubeconfig contents, tokens, certificates, JWT secrets, or confidential account information.

---

# Completion Checklist

- [-] Confirmed the personal lab context
- [-] Discovered and recorded application configuration
- [-] Recorded the original working image
- [-] Captured healthy Pods and ready Service backends (Screenshot 1)
- [-] Created the workspace (Screenshot 2)
- [-] Configured CLAUDE.md (Screenshot 3)
- [-] Reviewed the five-check triage plan (Screenshot 4)
- [-] Configured and reviewed the supplied script (Screenshots 5–7)
- [-] Passed Bash syntax validation and set executable permission (Screenshot 8)
- [-] Captured a baseline report with no FAIL (Screenshot 9)
- [-] Captured the correct exit code (Screenshot 10)
- [-] Configured and invoked `/k8s-triage` (Screenshots 11–12)
- [-] Simulated one controlled incident manually (Screenshot 13)
- [-] Reviewed Claude’s failed-state analysis (Screenshot 14)
- [-] Saved failure evidence before recovery (Screenshot 15)
- [-] Executed recovery manually and waited for rollout completion
- [-] Confirmed recovered Pods and ready Service backends (Screenshot 16)
- [-] Captured recovery analysis with no FAIL (Screenshot 17)
- [-] Explained any remaining warnings
- [-] Saved failure and recovery reports (Screenshot 18)
- [-] Completed the seven-section incident summary (Screenshot 19)
- [-] Answered all Notes questions
- [-] Published the LinkedIn post (Screenshot 20)
- [-] Included the LinkedIn post URL
- [-] Included all required project files
- [-] Checked that no sensitive information is exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
