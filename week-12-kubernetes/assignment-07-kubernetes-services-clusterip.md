# Assignment 7 — Kubernetes Services (ClusterIP)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create and test a Kubernetes ClusterIP Service. You will connect it to a healthy NGINX Deployment, access it using DNS and its ClusterIP, break and restore its selector, and observe how readiness affects Service routing.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm your learning-cluster context and remove previous lab resources where applicable before starting this assignment.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the ClusterIP Service lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/services/clusterip`

![Task 1](<screenshots/week 12-assignment 07-screenshot -01.png>).

---

### Notes

**1. Why is it not reliable to communicate with an application using a Pod IP address?**

Pod IP addresses are temporary and can change whenever Kubernetes replaces, restarts, or reschedules Pods. Depending on individual Pod IP addresses can interrupt communication between applications.

**2. What Kubernetes resource provides a stable internal address for a group of Pods?**

A Kubernetes Service, specifically a ClusterIP Service, provides a stable internal IP address and DNS name for accessing a group of matching Pods.

---

# Task 2 — Create a Healthy NGINX Deployment

## Goal

Create an NGINX Deployment with labels, readiness probes, and liveness probes that can act as the backend for a Service.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy.yaml` manifest

![Task 2.A](<screenshots/week 12-assignment 07-screenshot -02.A.png>)
![Task 2.A](<screenshots/week 12-assignment 07-screenshot -02.B.png>).

---

#### Screenshot 3 — Output showing successful rollout and two ready NGINX Pods

![Task 2.B](<screenshots/week 12-assignment 07-screenshot -03.png>).

---

### Notes

**1. Which label will the Service use to find these Pods?**

The Service uses the label app: nginx to identify the NGINX Pods.

**2. Why is readiness important before connecting Pods to a Service?**

Readiness probes help Kubernetes determine whether a Pod is prepared to receive traffic. Pods that fail readiness checks are normally excluded from ready Service backends, preventing requests from reaching application instances that are not ready.

**3. What port does the NGINX container listen on?**

The NGINX container listens on TCP port 80.

---

# Task 3 — Create a ClusterIP Service

## Goal

Create a stable internal Service that routes traffic to the NGINX Pods.

### Evidence

#### Screenshot 4 — Completed `01-nginx-svc-clusterip.yaml` manifest

![Task 3.A](<screenshots/week 12-assignment 07-screenshot -04.png>).

---

#### Screenshot 5 — Output showing the ClusterIP Service, endpoints, or EndpointSlices

![Task 3.B](<screenshots/week 12-assignment 07-screenshot -05.png>).

---

### Notes

**1. What is the purpose of a ClusterIP Service?**

A ClusterIP Service provides a stable internal IP address and DNS name that applications inside the Kubernetes cluster can use to communicate with matching backend Pods.

**2. What is the difference between `port` and `targetPort`?**

port is the port exposed by the Service, while targetPort is the port on the backend Pod where the application receives traffic.

**3. Why must the Service selector match the Pod labels?**

Kubernetes uses the Service selector to identify which Pods should receive traffic. If the selector does not match the Pod labels, the Service cannot automatically discover those Pods.

**4. What information do EndpointSlices contain?**

EndpointSlices contain information about Service backends, including Pod IP addresses, ports, readiness conditions, and other endpoint details.

---

# Task 4 — Access the Service from Inside the Cluster

## Goal

Create a client Pod and access the NGINX Service using DNS and its ClusterIP.

### Evidence

#### Screenshot 6 — Output showing the `tester` Pod running

![Task 4.A](<screenshots/week 12-assignment 07-screenshot -06.png>).

---

#### Screenshot 7 — Successful Service request using DNS name and ClusterIP

![Task 4.B](<screenshots/week 12-assignment 07-screenshot -07.png>).

---

#### Screenshot 8 — Successful DNS lookup for the Service

![Task 4.C](<screenshots/week 12-assignment 07-screenshot -08.png>).

---

### Notes

**1. Why should an application use `nginx-svc` instead of a Pod IP address?**

The Service name provides a stable way to communicate with the application, even when Kubernetes replaces Pods or their IP addresses change.

**2. What does the DNS name `nginx-svc.default.svc.cluster.local` represent?**

It is the fully qualified DNS name of the nginx-svc Service in the default namespace, under the cluster's cluster.local DNS domain.

**3. Why can the client access the Service even if the backend Pod IPs change?**

Kubernetes updates the Service's backend endpoint information as matching Pods are created, replaced, or removed. The client continues using the same Service name or ClusterIP.

---

# Task 5 — Break and Restore the Label-Selector Contract

## Goal

Break the Service selector, observe that usable endpoints disappear, and then restore the correct selector.

### Evidence

#### Screenshot 9 — `02-nginx-svc-selector-broken.yaml` showing the incorrect selector

![Task 5.A](<screenshots/week 12-assignment 07-screenshot -09.png>).

---

#### Screenshot 10 — Empty endpoints or EndpointSlice output after applying the broken selector

![Task 5.B](<screenshots/week 12-assignment 07-screenshot -10.png>).

---

#### Screenshot 11 — Failed request output from the `tester` Pod

![Task 5.C](<screenshots/week 12-assignment 07-screenshot -11.png>).

---

#### Screenshot 12 — Restored endpoints and successful Service request

![Task 5.D](<screenshots/week 12-assignment 07-screenshot -12.png>).

---

### Notes

**1. Why did the Service endpoints become empty?**

The Service selector was changed to app: does-not-match, which did not match the labels on the NGINX Pods. Consequently, Kubernetes could not associate those Pods with the Service.

**2. What caused the request from the client Pod to fail?**

The Service had no available backend endpoints because its selector did not match any NGINX Pods. As a result, the client could resolve the Service name but could not reach an application backend.

**3. How did you restore connectivity to the NGINX Pods?**

I reapplied the original Service manifest containing the correct selector, app: nginx. Kubernetes rediscovered the matching Pods, restored their endpoints, and the Service request succeeded again.

---

# Task 6 — Observe How Readiness Affects Service Routing

## Goal

Observe how a new Pod that fails readiness is excluded from ready Service backends while the existing healthy Pod continues serving traffic.

### Evidence

#### Screenshot 13 — Output showing the Deployment scaled to one ready Pod

![Task 6.A](<screenshots/week 12-assignment 07-screenshot -13.png>).

---

#### Screenshot 14 — Completed `03-readiness-broken.yaml` patch file

![Task 6.B](<screenshots/week 12-assignment 07-screenshot -14.png>).

---

#### Screenshot 15 — Output showing the expected incomplete rollout or NotReady Pod

![Task 6.C](<screenshots/week 12-assignment 07-screenshot -15.png>).

---

#### Screenshot 16 — EndpointSlice output showing the healthy Pod with `ready: true` and the new NotReady Pod with `ready: false`

![Task 6.D](<screenshots/week 12-assignment 07-screenshot -16.png>).

---

#### Screenshot 17 — Service EndpointSlice output showing ready backends after restoring the Deployment

![Task 6.E](<screenshots/week 12-assignment 07-screenshot -17.png>).

---

### Notes

**1. Why was the new NotReady Pod excluded from ready Service backends?**

The new Pod failed its readiness probe because Kubernetes attempted to access a nonexistent NGINX path. Kubernetes marked the Pod as NotReady, preventing normal Service traffic from being routed to it.

**2. What is the relationship between readiness probes and Service routing?**

Readiness probes determine whether Pods are prepared to receive requests. Kubernetes uses the resulting readiness conditions to decide which Service endpoints are eligible for normal traffic routing.

**3. Why does this behavior protect users from unhealthy application instances?**

It prevents requests from being directed to application instances that are not ready to serve them. During this test, the existing healthy Pod continued receiving traffic while the new Pod remained NotReady.

---

# Task 7 — Share Your ClusterIP Service Learning on LinkedIn

## Goal

Share what you learned about ClusterIP Services, Kubernetes DNS, selectors, and readiness-aware Service routing.

### Evidence

#### Screenshot 18 — Published LinkedIn post

![Task 7](<screenshots/week 12-assignment 07-screenshot -18.png>).

#### Linkedin post link

[LinkedIn Post](https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-kubernetes-devops-ugcPost-7515216293118140416-TgpJ/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ)

---

# Submission Instructions

- Add all required screenshots numbered 1–18.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed NGINX Deployment and ClusterIP Service manifests in your repository.
- Answer all Notes questions for Tasks 1–6 in your own words.
- Include evidence of the intentional failures and successful recovery.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [-] Learning-cluster context confirmed and previous lab resources removed where applicable
- [-] ClusterIP lab directory created (Screenshot 1)
- [-] Healthy NGINX Deployment manifest completed (Screenshot 2)
- [-] Successful rollout and two ready NGINX Pods verified (Screenshot 3)
- [-] ClusterIP Service manifest completed (Screenshot 4)
- [-] Service and backend endpoints or EndpointSlices verified (Screenshot 5)
- [-] Client Pod created and running (Screenshot 6)
- [-] Service accessed using DNS name and ClusterIP (Screenshot 7)
- [-] Service DNS resolution verified (Screenshot 8)
- [-] Broken selector manifest created (Screenshot 9)
- [-] Empty endpoints observed (Screenshot 10)
- [-] Failed Service request captured (Screenshot 11)
- [-] Original selector restored and connectivity verified (Screenshot 12)
- [-] Deployment scaled to one ready Pod (Screenshot 13)
- [-] Broken readiness patch created (Screenshot 14)
- [-] Incomplete rollout or NotReady Pod observed (Screenshot 15)
- [-] Readiness effect on Service backends verified (Screenshot 16)
- [-] Deployment restored and ready Service backends verified (Screenshot 17)
- [-] LinkedIn post published (Screenshot 18)
- [-] Notes for Tasks 1–6 completed
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
