# Assignment 4 — Auto-Scaling & Auto-Healing: Let Kubernetes React for You

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Create Deployments, test Pod auto-healing, configure CPU requests and limits, verify Metrics Server, and create a Horizontal Pod Autoscaler.

Optionally generate CPU load to observe how the HPA responds.

---

# Task 0 — Check the Existing Cluster Resources

## Goal

Confirm that you are connected to your learning cluster and inspect existing Deployments and HPAs.

### Evidence

No screenshots required.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the auto-scaling lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/autoscaling`

![Task 1](<screenshots/week 12-assignment 04-screenshot -1.png>).

---

### Notes

**1. What is the difference between auto-healing and auto-scaling?**

Auto-healing automatically replaces failed or deleted Pods to maintain the desired number of replicas. Auto-scaling adjusts the number of Pods based on workload demand, such as CPU utilization. Auto-healing focuses on maintaining availability, while auto-scaling focuses on adjusting capacity.


---

**2. Which Kubernetes feature will you use for CPU-based auto-scaling?**

I will use the Horizontal Pod Autoscaler (HPA). It monitors CPU utilization and automatically adjusts the number of Pods based on the configured target, minimum replicas, and maximum replicas.

---

# Task 2 — Test Auto-Healing with a Deployment

## Goal

Create a Deployment with two replicas, delete one Pod, and observe Kubernetes create a replacement Pod.

### Evidence

#### Screenshot 2 — Completed `autohealing-deployment.yaml` manifest

![Task 2.A](<screenshots/week 12-assignment 04-screenshot -2.png>).

---

#### Screenshot 3 — Output of `kubectl get pods` showing two running Pods before deletion

![Task 2.B](<screenshots/week 12-assignment 04-screenshot -3.png>).

---

#### Screenshot 4 — Output of the `kubectl delete pod` command

![Task 2.C](<screenshots/week 12-assignment 04-screenshot -4.png>).

---

#### Screenshot 5 — Output of `kubectl get pods` showing the replacement Pod and two running Pods

![Task 2.D](<screenshots/week 12-assignment 04-screenshot -5.png>).

---

### Notes

**1. What happened after you deleted one Pod?**

After I deleted one Pod, Kubernetes detected that the Deployment had fewer Pods than its desired replica count. It automatically created a replacement Pod to restore the required two replicas.

---

**2. What Kubernetes resource maintains the desired replica count for this Deployment?**

The ReplicaSet maintains the desired number of Pods. The Deployment manages the ReplicaSet, which ensures that the required number of Pods continues running.

---

**3. What proves that auto-healing worked?**

Auto-healing was successful because Kubernetes created a new Pod after I deleted one of the original Pods. The replacement Pod had a different name, and the Deployment returned to two running Pods without manual intervention.

---

# Task 3 — Create a Deployment for HPA

## Goal

Create a Deployment with CPU resource requests and limits so that HPA can calculate CPU utilization.

### Evidence

#### Screenshot 6 — Completed `hpa-deployment.yaml` manifest showing CPU requests and limits

![Task 3.A](<screenshots/week 12-assignment 04-screenshot -6.png>).

---

#### Screenshot 7 — Output showing `nginx-deployment` and its running Pods

![Task 3.B](<screenshots/week 12-assignment 04-screenshot -7.png>).

---

### Notes

**1. What does `cpu: "100m"` mean?**

cpu: "100m" means 100 millicores, equivalent to 0.1 CPU core. It specifies the CPU capacity requested by the container.

---

**2. What is the difference between a CPU request and a CPU limit?**

A CPU request specifies the amount of CPU Kubernetes uses when scheduling a container. A CPU limit specifies the maximum CPU capacity the container is allowed to use. Requests help Kubernetes allocate resources, while limits prevent containers from consuming more CPU than configured.

---

**3. Why does CPU-based HPA require CPU requests?**

CPU-based HPA uses CPU requests to calculate utilization as a percentage. Without CPU requests, Kubernetes may not be able to determine the utilization percentage needed to make scaling decisions.

---

# Task 4 — Enable and Verify Metrics Server

## Goal

Ensure the cluster can collect resource metrics for the HPA.

### Evidence

#### Screenshot 8 — Output showing Metrics Server running, or `kubectl top pods` displaying Pod metrics

![Task 4.A](<screenshots/week 12-assignment 04-screenshot -8.png>).

---

### Notes

**1. Why does HPA need Metrics Server?**

HPA needs Metrics Server to obtain CPU and memory usage information from Pods. These metrics help HPA determine whether the Deployment needs more or fewer replicas.

---

**2. What issue can occur if Metrics Server is not working?**

If Metrics Server is unavailable, HPA may not receive the CPU metrics needed to calculate utilization. The HPA can display <unknown> values and may be unable to make the expected scaling decisions.

---

**3. What does `kubectl top pods` help you check?**

The kubectl top pods command displays the current CPU and memory usage of Pods. It helps me verify that Metrics Server is providing resource metrics and understand how much CPU and memory the running Pods are consuming.

---

# Task 5 — Create a Horizontal Pod Autoscaler

## Goal

Create an HPA that keeps at least two Pods running and can scale up to five Pods when average CPU utilization exceeds 50%.

### Evidence

#### Screenshot 9 — The imperative command output OR completed `hpa-nginx.yaml` manifest

![Task 5.A](<screenshots/week 12-assignment 04-screenshot -9.png>).

---

#### Screenshot 10 — Output of `kubectl get hpa` and the relevant `kubectl describe hpa` command

![Task 5.B](<screenshots/week 12-assignment 04-screenshot -10.png>).

---

### Notes

**1. What does `minReplicas: 2` mean?**

minReplicas: 2 means the HPA should maintain at least two Pods for the Deployment. Even when CPU utilization is low, the HPA will not intentionally scale the Deployment below two replicas.

---

**2. What does `maxReplicas: 5` mean?**

maxReplicas: 5 sets the maximum number of replicas the HPA can request. When CPU utilization increases, the HPA can scale the Deployment up to five Pods but not beyond that limit.

---

**3. What does `averageUtilization: 50` mean?**

averageUtilization: 50 means the HPA aims to maintain average CPU utilization at approximately 50% of the configured CPU requests across the targeted Pods. When utilization rises above the target, the HPA may increase the number of replicas.

---

**4. Why should only one HPA manage a Deployment at a time?**

Only one HPA should manage a Deployment because multiple HPAs targeting the same Deployment can issue conflicting replica-count updates. This can lead to unpredictable scaling behavior.

---

# Task 6 — Optional: Generate CPU Load and Observe Scaling

## Goal

Generate CPU load in one NGINX Pod and observe how HPA responds.

### Evidence

If you skip this task, write “Not completed — optional” and leave the remaining Task 6 placeholders blank.

Task status: Add your status here.

#### Screenshot 11 — Terminal showing the CPU-load command running inside the selected Pod

![Task 6.A](<screenshots/week 12-assignment 04-screenshot -11.png>).

---

#### Screenshot 12 — Output of `kubectl get hpa` and `kubectl get pods` while HPA evaluates or changes the replica count

![Task 6.B](<screenshots/week 12-assignment 04-screenshot -12.png>).

---

### Notes

Complete these answers only if you perform the optional test.

**1. Did the HPA change the number of Pods? Explain what you observed.**

Yes. During the CPU-load test, I observed the HPA increase the number of NGINX Pods from two to four. The selected Pod consumed approximately 201 millicores of CPU, and the HPA responded by increasing the replica count to accommodate the workload.

This demonstrated how Kubernetes automatically adjusts application capacity based on CPU utilization.

---

**2. If scaling did not happen, what are two possible reasons?**

Not applicable, as scaling occurred successfully.

However, two possible reasons scaling might fail are insufficient CPU utilization to trigger scaling and unavailable CPU metrics from Metrics Server.

---

**3. Why is automatic scale-down useful after traffic decreases?**

Automatic scale-down helps Kubernetes reduce unnecessary resource consumption when application demand decreases.

By removing excess Pods while maintaining the minimum required replicas, Kubernetes improves resource efficiency and reduces infrastructure costs.

---

# LinkedIn Requirement

### Evidence

#### Screenshot 13 — Published LinkedIn post showing your name, the required explanation, and the attached Kubernetes screenshot

![Task 6.C](<screenshots/week 12-assignment 04-screenshot -13.png>).

#### Linkedin Post Link

[LinkedIn Post](https://www.linkedin.com/posts/peace-offor-aa736a147_kubernetes-devops-cloudnative-ugcPost-7514669991271579649-rixg/?utm_source=chatgpt.com)

---

# Submission Instructions

- Include required Screenshots 1–10 and Screenshot 13.
- Include Screenshots 11–12 only if you complete Task 6.
- Full Name must be visible in required screenshots.
- Ensure screenshots are clear and readable.
- Include the completed `autohealing-deployment.yaml` and `hpa-deployment.yaml` files.
- Include `hpa-nginx.yaml` if you selected the declarative HPA method.
- Complete the Notes sections for Tasks 1–5 in your own words.
- Complete Task 6 notes only if you perform the optional test.
- Do not expose passwords, tokens, private keys, kubeconfig files, or account IDs.

---

# Completion Checklist

- [-] Checked the active context and existing cluster resources
- [-] Created the autoscaling working directory (Screenshot 1)
- [-] Created `autohealing-deployment.yaml` (Screenshot 2)
- [-] Confirmed two auto-healing Pods were running (Screenshot 3)
- [-] Deleted one managed Pod (Screenshot 4)
- [-] Confirmed that the Pod was automatically replaced (Screenshot 5)
- [-] Created `hpa-deployment.yaml` with CPU requests and limits (Screenshot 6)
- [-] Verified `nginx-deployment` and its running Pods (Screenshot 7)
- [-] Verified Metrics Server and confirmed Pod metrics are available (Screenshot 8)
- [-] Created one HPA using the selected method (Screenshot 9)
- [-] Verified minimum replicas of 2, maximum replicas of 5, and a CPU target of 50% (Screenshot 10)
- [-] Completed Notes for Tasks 1–5
- [-] Completed Task 6 evidence and notes, or marked it “Not completed — optional”
- [-] Stopped the CPU-load command and exited the container shell, if Task 6 was completed
- [-] Published the LinkedIn post with the required explanation and attached screenshot (Screenshot 13)
- [-] Included the required manifest files
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
