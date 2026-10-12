# Assignment 6 — Kubernetes Health Probes (Liveness)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will configure and test a Kubernetes liveness probe. You will create a baseline NGINX Deployment, add an HTTP liveness probe, intentionally make it fail, observe container restarts, and restore the working configuration.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm that you are connected to your learning cluster and remove the previous HPA and NGINX Deployment before starting this lab.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the liveness-probe lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/health-probes-liveness`

![Task 1](<screenshots/week 12-assignment 06-screenshot -01.png>).

---

### Notes

**1. What problem does a liveness probe solve?**

A liveness probe helps Kubernetes detect containers that are running but no longer functioning correctly. An application may become unresponsive because of a software bug, deadlock, or other internal problem. The liveness probe identifies repeated failures and allows Kubernetes to restart the affected container automatically.

**2. What is the key difference between a readiness probe and a liveness probe?**

A readiness probe determines whether a Pod is ready to receive application traffic, while a liveness probe determines whether a container is still functioning correctly. When readiness fails, Kubernetes marks the Pod as NotReady. When liveness fails repeatedly, Kubernetes restarts the unhealthy container.

---

# Task 2 — Create a Baseline Deployment Without Probes

## Goal

Create a baseline NGINX Deployment with two replicas and no health probes.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy-baseline.yaml` manifest

![Task 2.A](<screenshots/week 12-assignment 06-screenshot -02.png>).

---

#### Screenshot 3 — Output showing a successful rollout and two running NGINX Pods

![Task 2.B](<week 12-assignment 06-screenshot -03.png>).

---

#### Screenshot 4 — Relevant output from `kubectl describe deployment nginx-deployment`

![Task 2.C](<screenshots/week 12-assignment 06-screenshot -04.png>).

---

### Notes

**1. How many replicas does this Deployment maintain?**

The Deployment maintains two NGINX replicas. Kubernetes uses a ReplicaSet to ensure that the desired number of Pods is maintained.

**2. Are any health probes configured in the baseline Deployment?**

No. The baseline Deployment does not include readiness, liveness, or startup probes. It provides a basic NGINX configuration before health monitoring is introduced.

**3. Why is a baseline useful before adding a liveness probe?**

A baseline helps me confirm that the NGINX Deployment works correctly before introducing a liveness probe. It provides a reference point for comparing normal container behavior with the behavior observed when health checks are configured and intentionally broken.

---

# Task 3 — Add a Liveness Probe

## Goal

Add an HTTP liveness probe so Kubernetes can periodically check whether the NGINX container is still responsive.

### Evidence

#### Screenshot 5 — Completed `01-nginx-deploy-liveness.yaml` manifest showing the liveness probe

![Task 3.A](<screenshots/week 12-assignment 06-screenshot -05.png>).

---

#### Screenshot 6 — Output showing successful rollout and running Pods

![Task 3.B](<screenshots/week 12-assignment 06-screenshot -06.png>).

---

#### Screenshot 7 — Pod description showing liveness-probe details

![Task 3.C](<screenshots/week 12-assignment 06-screenshot -07.png>).

---

### Notes

**1. What path and port does the liveness probe check?**

The liveness probe checks the NGINX root path / using HTTP on port 80. This allows Kubernetes to verify whether the container is responding successfully to requests.

**2. What does `initialDelaySeconds: 10` do?**

It instructs Kubernetes to wait approximately ten seconds after the container starts before beginning liveness checks. This gives the application time to initialize before Kubernetes starts checking its health.

**3. What does `failureThreshold: 3` mean?**

It means Kubernetes must detect three consecutive failed liveness checks before treating the container as unhealthy and restarting it.

**4. Does a successful liveness probe control whether a Pod receives traffic? Explain briefly.**

No. A liveness probe does not directly determine whether a Pod receives traffic. Its main purpose is to detect unhealthy containers and trigger restarts. Readiness probes determine whether a Pod should be considered ready to receive application traffic.

---

# Task 4 — Trigger and Observe a Liveness Restart

## Goal

Intentionally make the liveness probe fail and observe Kubernetes restart the unhealthy container.

### Evidence

#### Screenshot 8 — `02-nginx-liveness-broken.yaml` showing `/does-not-exist`

![Task 4.A](<screenshots/week 12-assignment 06-screenshot -08.png>).

---

#### Screenshot 9 — Pod output showing an increased RESTARTS count

![Task 4.B](<screenshots/week 12-assignment 06-screenshot -09.png>).

---

#### Screenshot 10 — Pod description showing liveness-probe failure events or restart details

![Task 4.C](<screenshots/week 12-assignment 06-screenshot -10.A.png>)
![Task 4.C](<screenshots/week 12-assignment 06-screenshot -10.B.png>).

---

#### Screenshot 11 — Output showing stable running Pods after applying the fixed configuration

![Task 4.D](<screenshots/week 12-assignment 06-screenshot -11.A.png>).

---

### Notes

**1. Why did the liveness probe fail?**

The liveness probe failed because I intentionally configured it to check /does-not-exist, an endpoint that NGINX could not serve successfully. This caused the HTTP health checks to fail repeatedly.

**2. What happened after Kubernetes detected repeated liveness-probe failures?**

Kubernetes automatically restarted the affected NGINX containers after repeated liveness-probe failures. During my experiment, both Pods experienced multiple restarts, and their containers eventually entered the CrashLoopBackOff state.

**3. What does the RESTARTS column prove?**

The RESTARTS column shows how many times a container has restarted within a Pod. During my experiment, the restart counts increased from zero to four, demonstrating that Kubernetes was repeatedly restarting the containers in response to failed health checks.

**4. How did you restore the Deployment to a stable state?**

I restored the Deployment by applying the working liveness-probe manifest, which checks the correct NGINX root endpoint /. This allowed the containers to pass their health checks and return to stable operation.

---

# Task 5 — Optional: Observe a Restart Loop

## Goal

Observe why overly aggressive or incorrectly configured liveness probes can create restart loops.

Complete this section only if you attempt Task 5. Otherwise, mark it as “Not attempted.”

**Task status:** Completed 

### Evidence

#### Optional Screenshot — Pod output showing the RESTARTS count increasing during the restart-loop observation

![Task 5](<screenshots/week 12-assignment 06-screenshot -11.B.png>)
![Task 5](<screenshots/week 12-assignment 06-screenshot -11.C.png>)
![Task 5](<screenshots/week 12-assignment 06-screenshot -11.D.png>).

No specific restart count or CrashLoopBackOff status is required.

---

### Notes — Answer Only If Attempted

**1. What is a restart loop?**

A restart loop occurs when a container repeatedly fails and Kubernetes continuously attempts to restart it. During my liveness-probe experiment, I intentionally configured an invalid HTTP endpoint, causing repeated health-check failures. Kubernetes restarted the NGINX containers several times, and their restart counts increased. This demonstrated how an incorrect liveness configuration can prevent an application from remaining stable.

**2. Why can an aggressive liveness probe be harmful?**

An overly aggressive liveness probe can cause unnecessary container restarts, especially when an application requires additional time to initialize or temporarily becomes unresponsive. If the probe checks too frequently or allows too few failures, Kubernetes may restart containers that could otherwise recover. This can create restart loops, interrupt application availability, and increase operational overhead.

**3. Why should liveness checks be lightweight and carefully tuned?**

Liveness checks should be lightweight and carefully configured to avoid placing unnecessary pressure on the application. Appropriate initial delays, checking intervals, and failure thresholds help Kubernetes distinguish genuine application failures from temporary delays. This reduces unnecessary restarts, improves application stability, and supports reliable self-healing in production environments.

---

# Task 6 — Share Your Liveness-Probe Learning on LinkedIn

## Goal

Share what you learned about Kubernetes liveness probes, container restarts, and the difference between readiness and liveness.

### Evidence

#### Screenshot 12 — Published LinkedIn post

![LinkedIn Post](<screenshots/week 12-assignment 06-screenshot -12.png>).

#### Linkedin post URL

[LinkedIn Post](https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-kubernetes-devops-ugcPost-7515076515638792192-dJ0c/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ)

---

# Submission Instructions

- Add all required screenshots numbered 1–12.
- Include the optional Task 5 screenshot only if you attempt that task.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed baseline and liveness-probe manifests in your repository.
- Answer all Notes questions for Tasks 1–4 in your own words.
- If you attempt Task 5, complete its Notes and restore the working configuration afterward.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [-] Learning cluster confirmed and previous assignment resources removed where applicable
- [-] Liveness-probe lab directory created (Screenshot 1)
- [-] Baseline Deployment manifest completed (Screenshot 2)
- [-] Successful rollout and two baseline Pods verified (Screenshot 3)
- [-] Baseline Deployment details reviewed (Screenshot 4)
- [-] Liveness probe added successfully (Screenshot 5)
- [-] Successful liveness-probe rollout verified (Screenshot 6)
- [-] Liveness-probe details inspected (Screenshot 7)
- [-] Broken liveness configuration created (Screenshot 8)
- [-] Increased container restart count observed (Screenshot 9)
- [-] Liveness-probe failure events or restart details captured (Screenshot 10)
- [-] Working liveness configuration restored and stable Pods verified (Screenshot 11)
- [-] Optional Task 5 evidence and Notes completed, if attempted
- [-] Working configuration restored after Task 5, if attempted
- [-] LinkedIn post published (Screenshot 12)
- [-] Notes for Tasks 1–4 completed
- [-] Required manifests included
- [-] All required screenshots are clear and readable
- [-] No sensitive data exposed

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
