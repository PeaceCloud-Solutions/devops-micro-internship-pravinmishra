# Assignment 8 — Kubernetes Services (NodePort)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Create a healthy NGINX Deployment, expose it through a NodePort Service, test access using a node IP and NodePort, and observe how the Service behaves when a backend Pod is replaced.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the NodePort Service lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/services/nodeport`

![Task 1](<screenshots/week 12-assignment 08-screenshot -01.png>).

### Notes

**1. What is the difference between ClusterIP and NodePort?**

ClusterIP provides a stable internal IP address that applications within a Kubernetes cluster can use to communicate. NodePort extends this functionality by exposing the Service through a port on each cluster node, allowing access from outside the cluster when the node network is reachable.

**2. What does a NodePort Service allow users to do?**

A NodePort Service allows users or external applications to access a Kubernetes application using a reachable node IP address and an assigned NodePort.

---

# Task 2 — Create a Healthy NGINX Deployment

## Goal

Create a healthy NGINX Deployment that can act as the backend for the NodePort Service.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy.yaml` manifest

![Task 2.A](<screenshots/week 12-assignment 08-screenshot -02.A.png>)
![Task 2.A](<screenshots/week 12-assignment 08-screenshot -02.B.png>).

---

#### Screenshot 3 — Output showing successful rollout and two ready NGINX Pods

![Task 2.B](<screenshots/week 12-assignment 08-screenshot -03.png>).

### Notes

**1. Which label will the NodePort Service use to find the NGINX Pods?**

The NodePort Service will use the label app: nginx to identify the matching NGINX Pods.

**2. Why must the Pods be ready before they can receive Service traffic?**

Readiness checks help Kubernetes determine whether Pods can handle incoming requests. Pods that fail readiness checks are excluded from normal Service routing until they become ready.

**3. What port does the NGINX container listen on?**

The NGINX container listens on TCP port 80.

---

# Task 3 — Create the NodePort Service

## Goal

Create a NodePort Service that exposes the NGINX application through a port on every cluster node.

### Evidence

#### Screenshot 4 — Completed `01-nginx-svc-nodeport.yaml` manifest

![Task 3.A](<screenshots/week 12-assignment 08-screenshot -04.png>).

---

#### Screenshot 5 — Output showing the NodePort Service and its endpoints or EndpointSlices

![Task 3.B](<screenshots/week 12-assignment 08-screenshot -05.png>).

### Notes

**1. What is the purpose of `type: NodePort`?**

The NodePort Service type exposes an application through a port on each Kubernetes node, allowing clients to access the application using a reachable node IP address and the assigned NodePort.

**2. What is the difference between `port`, `targetPort`, and `nodePort`?**

port is the port exposed by the Service internally, targetPort is the port where the backend application listens, and nodePort is the port exposed on Kubernetes nodes for external access.

**3. What NodePort was assigned or selected in your environment?**

Kubernetes automatically assigned NodePort 31245 to my NGINX Service.

**4. Why do Service endpoints need ready Pods?**

Ready Pods are eligible to receive normal Service traffic. This helps prevent requests from reaching application instances that are still starting or are not prepared to handle requests.

---

# Task 4 — Find a Node IP and Test the NodePort

## Goal

Find a reachable node IP and access the NodePort Service.

### Evidence

#### Screenshot 6 — Output of `kubectl get nodes -o wide`

![Task 4.A](<screenshots/week 12-assignment 08-screenshot -06.png>).

---

#### Screenshot 7 — Output showing the `tester` Pod running

![Task 4.B](<screenshots/week 12-assignment 08-screenshot -07.png>).

---

#### Screenshot 8 — Successful NodePort response from the laptop or the `tester` Pod

If neither route is supported by your environment, include the failed request output and ready endpoint evidence, and explain the limitation in your Notes.

![Task 4.C](<screenshots/week 12-assignment 08-screenshot -08.png>).

### Notes

**1. Which node IP and NodePort did you test?**

I tested the NodePort Service using node IP [172.18.0.2] and NodePort [30530].

**2. Was your laptop able to reach the NodePort directly? Explain your result.**

Yes. I successfully accessed the NGINX application using the node IP and assigned NodePort. The Service returned the NGINX welcome page.

**3. Why can external NodePort access behave differently in Minikube, kind, Docker Desktop, and cloud clusters?**

These Kubernetes environments use different networking configurations. Minikube and Docker Desktop often run Kubernetes inside virtualized environments, while kind uses container-based nodes. Cloud clusters may provide routable node addresses, subject to security groups and firewall rules. These differences affect whether a NodePort is directly reachable from outside the cluster.

---

# Task 5 — Optional: Test the Label-Selector Contract

## Goal

Break the Service selector, observe that usable endpoints disappear, and restore the correct selector.

Complete the Evidence and Notes below only if you attempted this optional task.

### Evidence

#### Screenshot 9 — `02-nginx-svc-selector-broken.yaml` showing the incorrect selector

![Task 5.A](<screenshots/week 12-assignment 08-screenshot -09.png>).

---

#### Screenshot 10 — Empty endpoints or EndpointSlice output after applying the broken selector

![Task 5.B](<screenshots/week 12-assignment 08-screenshot -10.png>).

---

#### Screenshot 11 — Restored endpoints or EndpointSlices after applying the original Service manifest

![Task 5.C](<screenshots/week 12-assignment 08-screenshot -11.png>).

### Notes

**1. Why did the Service endpoints become empty?**

The Service selector was changed to app: does-not-match, which did not match the labels assigned to the NGINX Pods. Kubernetes therefore removed the Pods from the Service's backend endpoint list.

**2. Why is NodePort only useful when matching ready Pods exist?**

A NodePort Service needs available backend Pods to handle incoming requests. Without matching ready Pods, the Service has no healthy application endpoints to which it can route normal traffic.

**3. How did you restore the backend connectivity?**

I reapplied the original NodePort Service manifest containing the correct selector, app: nginx. Kubernetes rediscovered the matching NGINX Pods and restored their ready endpoints.

---

# Task 6 — Observe Resilience During Pod Churn

## Goal

Delete one NGINX Pod and observe its replacement while the Service continues routing traffic to available Pods.

### Evidence

#### Screenshot 12 — Output of the Pod deletion command

![Task 6.A](<screenshots/week 12-assignment 08-screenshot -12.png>).

---

#### Screenshot 13 — Output showing the replacement Pod and two running, ready Pods

![Task 6.B](<screenshots/week 12-assignment 08-screenshot -13.png>).

### Notes

**1. What happened after you deleted one Pod?**

After I deleted one NGINX Pod, Kubernetes detected that the number of running Pods was below the Deployment's desired replica count. It automatically created a replacement Pod, which eventually reached the Running and Ready states.

**2. Which Kubernetes resource created the replacement Pod?**

The ReplicaSet managed by the NGINX Deployment created the replacement Pod to maintain the desired number of replicas.

**3. Why can the NodePort Service continue working during Pod churn?**

The NodePort Service routes requests to available ready backend Pods rather than depending on a particular Pod IP address. When one Pod is deleted, the remaining healthy Pod can continue serving requests while Kubernetes creates a replacement.

---

# Task 7 — Share Your NodePort Learning on LinkedIn

## Goal

Share what you learned about NodePort Services, backend Pods, and network access in your Kubernetes environment.

### Evidence

#### Screenshot 14 — Published LinkedIn post about your NodePort Service lab

![Task 7](<screenshots/week 12-assignment 08-screenshot -14.png>).

#### Linkedin post link

[LinkedIn Post](https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-kubernetes-devops-ugcPost-7515420757758222336-qgA_/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ).

---

# Submission Instructions

- Include the completed YAML manifests created during the lab.
- Add all required screenshots: Screenshots 1–8 and 12–14.
- Include Screenshots 9–11 only if you attempted optional Task 5.
- Complete the Notes for Tasks 1–4 and Task 6.
- Complete Task 5 Notes only if you attempted that task.
- Use clear, readable screenshots showing the relevant commands and outputs.
- Ensure your full name is visible in the required screenshots.
- If NodePort access is restricted by your environment, include the failed request output, ready endpoint evidence, and an explanation.
- Do not expose passwords, access tokens, private keys, kubeconfig contents, or account IDs.

---

# Completion Checklist

- [-] Created and entered `~/k8s-labs/services/nodeport` (Screenshot 1)
- [-] Created and applied the NGINX Deployment manifest (Screenshot 2)
- [-] Confirmed successful rollout and two ready NGINX Pods (Screenshot 3)
- [-] Created the NodePort Service manifest (Screenshot 4)
- [-] Verified the Service and its endpoints or EndpointSlices (Screenshot 5)
- [-] Recorded the assigned or selected NodePort
- [-] Identified a node IP (Screenshot 6)
- [-] Confirmed that the `tester` Pod is running (Screenshot 7)
- [-] Tested NodePort access, or documented the environment limitation with evidence (Screenshot 8)
- [-] Optional: Tested and restored the Service selector (Screenshots 9–11)
- [-] Deleted one NGINX Pod (Screenshot 12)
- [-] Confirmed the replacement Pod and two running, ready Pods (Screenshot 13)
- [-] Completed all required Notes
- [-] Published the LinkedIn post (Screenshot 14)
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
