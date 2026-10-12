# Assignment 5 — Kubernetes Health Probes (Readiness)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will configure and test a Kubernetes readiness probe. You will create a baseline NGINX Deployment, add an HTTP readiness probe, intentionally break it, observe a stalled rollout, and restore the working configuration.

You will also demonstrate how readiness probes protect rolling updates.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm that you are connected to your learning cluster and remove the previous assignment’s HPA and NGINX Deployment before starting this lab.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the readiness-probe lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/health-probes-readiness`

![Task 1](<screenshots/week 12-assignment 05-screenshot -01.png>).

---

### Notes

**1. What is the purpose of a readiness probe?**

A readiness probe helps Kubernetes determine whether a container is prepared to receive application traffic. It checks a defined condition, such as an HTTP endpoint, before marking the Pod as ready. This prevents traffic from being directed to an application that is still starting or experiencing problems.

**2. Why is a Pod being Running not always enough to confirm it can serve traffic?**

A Pod can be in the Running state while its application is still initializing, loading configuration, or waiting for dependencies. Running only indicates that the container is executing, while readiness confirms that the application can respond successfully to requests.

---

# Task 2 — Create a Baseline Deployment Without Probes

## Goal

Create a baseline NGINX Deployment with two replicas and no readiness probe.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy-baseline.yaml` manifest

![Task 2.A](<screenshots/week 12-assignment 05-screenshot -02.png>).

---

#### Screenshot 3 — Output showing a successful rollout and two running NGINX Pods

![Task 2.B](<screenshots/week 12-assignment 05-screenshot -03.png>).

---

#### Screenshot 4 — Relevant output from `kubectl describe deployment nginx-deployment`

![Task 2.C](<screenshots/week 12-assignment 05-screenshot -04.png>).

---

### Notes

**1. How many replicas does this Deployment maintain?**

The Deployment maintains two NGINX replicas. Kubernetes uses a ReplicaSet to ensure that the desired number of Pods remains available.

**2. What does `maxUnavailable: 0` mean during a rolling update?**

It means Kubernetes should not intentionally reduce the number of available Pods below the desired replica count during a rolling update. With two replicas, Kubernetes must maintain two available Pods while introducing new ones.

**3. Is a readiness probe configured in this baseline Deployment?**

No. The baseline Deployment does not contain a readiness probe. Kubernetes therefore does not perform an application-specific HTTP readiness check.

---

# Task 3 — Add a Readiness Probe

## Goal

Add an HTTP readiness probe so Kubernetes checks whether each NGINX container is ready to accept requests.

### Evidence

#### Screenshot 5 — Completed `01-nginx-deploy-readiness.yaml` manifest showing the readiness probe

![Task 3.A](<screenshots/week 12-assignment 05-screenshot -05.png>).

---

#### Screenshot 6 — Output of the successful rollout and ready Pods

![Task 3.B](<screenshots/week 12-assignment 05-screenshot -06.png>).

---

#### Screenshot 7 — Pod description showing readiness conditions and readiness probe details

![Task 3.D](<screenshots/week 12-assignment 05-screenshot -07.png>).

---

### Notes

**1. What path and port does the readiness probe check?**

The readiness probe checks the NGINX root path / using HTTP on port 80. A successful response indicates that the container can serve requests.

**2. What does `initialDelaySeconds: 2` do?**

It instructs Kubernetes to wait approximately two seconds after the container starts before beginning readiness checks. This gives the application a short period to initialize.

**3. What does `periodSeconds: 5` do?**

It configures Kubernetes to perform readiness checks approximately every five seconds, allowing the system to monitor whether the application remains ready.

**4. What must happen before Kubernetes considers this Pod ready?**

The readiness probe must successfully reach the configured HTTP endpoint. With successThreshold: 1, one successful readiness check is sufficient for the container to be considered ready.

---

# Task 4 — Break and Restore Readiness

## Goal

Intentionally fail the readiness probe, observe the NotReady behavior, and then restore the working probe configuration.

### Evidence

#### Screenshot 8 — `02-nginx-readiness-broken.yaml` showing `/does-not-exist`

![Task 4.A](<screenshots/week 12-assignment 05-screenshot -08.png>).

---

#### Screenshot 9 — Output showing the rollout timeout or incomplete rollout

![Task 4.B](<screenshots/week 12-assignment 05-screenshot -09.png>).

---

#### Screenshot 10 — Pod details showing `Ready: False` or readiness-probe failure events

![Task 4.C](<screenshots/week 12-assignment 05-screenshot -10.png>).

---

#### Screenshot 11 — Output showing successful rollout and ready Pods after the fix

![Task 4.D](<screenshots/week 12-assignment 05-screenshot -11.png>).

---

### Notes

**1. Why did the readiness probe fail?**

The readiness probe failed because I intentionally changed the HTTP path from / to /does-not-exist. Since the NGINX server did not have a resource at that path, it returned an HTTP 404 response, causing the readiness check to fail.

**2. What happened to the Pod readiness status?**

The newly created Pod remained in the Running state but was marked NotReady because its readiness probe failed. This demonstrated that a running container is not necessarily ready to serve traffic.

**3. Why did the rollout fail to complete?**

The rollout could not complete because the new Pod failed its readiness checks. Kubernetes could not count the Pod as available, so it did not replace the healthy Pods as required to finish the rolling update.

**4. How did you restore the Deployment successfully?**

I restored the working readiness configuration by changing the HTTP probe path back to / and applying the corrected Deployment manifest. After the readiness checks succeeded, Kubernetes completed the rollout and returned the Deployment to its desired healthy replica count.

---

# Task 5 — See How Readiness Protects Rolling Updates

## Goal

Observe how readiness prevents a bad new Pod from replacing healthy Pods during a rolling update.

### Evidence

#### Screenshot 12 — Successful update command and rollout status

![Task 5.A](<screenshots/week 12-assignment 05-screenshot -12.png>).

---

#### Screenshot 13 — ReplicaSets and Pods after the successful rolling update

![Task 5.B](<screenshots/week 12-assignment 05-screenshot -13.png>).

---

#### Screenshot 14 — Completed `04-readiness-broken-patch.yaml`

![Task 5.C](<screenshots/week 12-assignment 05-screenshot -14.png>).

---

#### Screenshot 15 — Output showing the expected stalled rollout or timeout

![Task 5.D](<screenshots/week 12-assignment 05-screenshot -15.png>).

---

#### Screenshot 16 — Deployment or Pod output showing the effect of the broken readiness probe

![Task 5.E](<screenshots/week 12-assignment 05-screenshot -16.png>).

---

#### Screenshot 17 — Successful rollout status after restoring the fixed configuration

![Task 5.F](<screenshots/week 12-assignment 05-screenshot -17.png>).

---

### Notes

**1. What happened during the successful rolling update?**

During the successful rolling update, Kubernetes created a new ReplicaSet for the updated NGINX image. New Pods were gradually introduced and passed their readiness checks before Kubernetes removed the older Pods. This allowed the Deployment to update while maintaining application availability.

**2. Why did Kubernetes create a new ReplicaSet?**

Kubernetes created a new ReplicaSet because I changed the container image in the Deployment's Pod template. Each Deployment revision with a different Pod template is managed through a ReplicaSet, allowing Kubernetes to track changes and manage rolling updates.

**3. Why were the new Pods unable to replace the existing healthy Pods after readiness was broken?**

The new Pods could not replace the existing healthy Pods because their readiness probes were configured to check /does-not-exist, which returned HTTP 404. Kubernetes marked these Pods NotReady, preventing them from counting as available during the rollout.

**4. How does `maxUnavailable: 0` protect availability during this rollout?**

The maxUnavailable: 0 setting instructs Kubernetes to maintain the desired number of available replicas during a rolling update. When the new Pods failed readiness checks, Kubernetes retained the older healthy Pods rather than reducing application availability.

---

# Task 6 — Share Your Readiness-Probe Learning on LinkedIn

## Goal

Share what you learned about Kubernetes readiness probes and how they protect rolling updates.

### Evidence

#### Screenshot 18 — Published LinkedIn post

![LinkedIn Post](<screenshots/week 12-assignment 05-screenshot -18.png>).

#### Linkedin post link

[LinkedIn Post](https://www.linkedin.com/posts/peace-offor-aa736a147_kubernetes-devops-cloudnative-ugcPost-7514776475028340736-8sAt)

---

# Submission Instructions

- Add all required screenshots numbered 1–18.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed baseline and readiness-probe manifests in your repository.
- Answer all Notes questions for Tasks 1–5 in your own words.
- Include evidence of the intentional readiness failure and successful recovery.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [-] Learning cluster confirmed and previous assignment resources removed where applicable
- [-] Readiness-probe lab directory created (Screenshot 1)
- [-] Baseline Deployment created successfully (Screenshot 2)
- [-] Two baseline Pods running and successful rollout verified (Screenshot 3)
- [-] Baseline Deployment details reviewed (Screenshot 4)
- [-] Readiness probe added successfully (Screenshot 5)
- [-] Successful readiness rollout verified (Screenshot 6)
- [-] Pod readiness conditions and probe details inspected (Screenshot 7)
- [-] Broken readiness configuration created (Screenshot 8)
- [-] Stalled rollout or timeout observed (Screenshot 9)
- [-] NotReady status or readiness-probe failure events captured (Screenshot 10)
- [-] Working readiness configuration restored (Screenshot 11)
- [-] Successful image update completed (Screenshot 12)
- [-] ReplicaSets and Pods inspected after the update (Screenshot 13)
- [-] Broken-readiness patch created (Screenshot 14)
- [-] Stalled rollout observed after the patch (Screenshot 15)
- [-] Effect of broken readiness captured (Screenshot 16)
- [-] Final recovery completed (Screenshot 17)
- [-] LinkedIn post published (Screenshot 18)
- [-] Notes for Tasks 1–5 completed
- [-] Required manifests included
- [-] All screenshots are clear and readable
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
