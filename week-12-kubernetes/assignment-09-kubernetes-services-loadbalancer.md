# Assignment 09 — Kubernetes Services: LoadBalancer on AKS

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy a healthy NGINX application to Azure Kubernetes Service (AKS), expose it publicly using a LoadBalancer Service, observe readiness behavior, and scale the application behind the same public endpoint.

---

# Task 1 — Create or Connect to an AKS Cluster

## Goal

Create a small AKS cluster for this lab, or connect to an existing approved AKS lab cluster.

### Evidence

#### Screenshot 1 — Output of `kubectl get nodes` showing ready AKS node(s)

![Task 1](<screenshots/week 12-assignment 09-screenshot -01.png>).

### Notes

**1. Why does this lab use a cloud-capable Kubernetes environment such as AKS for the LoadBalancer Service?**

AKS provides integration between Kubernetes and Azure networking services. This allows Kubernetes to request a cloud load balancer and public IP address so that applications can be accessed from the internet. Unlike my previous Docker Desktop labs, AKS provides the cloud infrastructure needed to test a publicly accessible LoadBalancer Service.

**2. What Azure resources can Kubernetes provision when a LoadBalancer Service is created?**

When I create a LoadBalancer Service, AKS can configure Azure Load Balancer components, a public IP address, load-balancing rules, health probes, and related networking configurations. These resources allow incoming requests to reach the Kubernetes application.

**3. Why is it important to delete unused AKS resources after the lab?**

AKS clusters use Azure resources that can continue generating charges even when I am not actively using them. Deleting unused lab resources helps control costs, avoid unnecessary resource consumption, and maintain an organized Azure environment.

---

# Task 2 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the LoadBalancer Service manifests.

### Evidence

#### Screenshot 2 — Terminal showing the output of `pwd` confirming that you are working inside `~/k8s-labs/services/loadbalancer`

![Task 2](<screenshots/week 12-assignment 09-screenshot -02.png>).

### Notes

**1. Why is it useful to keep Kubernetes manifests organized in dedicated directories?**

Keeping Kubernetes manifests in dedicated directories helps me separate assignments, locate configuration files quickly, and avoid applying the wrong YAML files. It also makes troubleshooting, documentation, and version control easier.

**2. What are the names of the main Deployment and LoadBalancer Service YAML files you will create in this assignment?**

The two main files are 00-nginx-deploy.yaml, which defines the NGINX Deployment, and 01-nginx-svc-loadbalancer.yaml, which defines the public LoadBalancer Service. I will also create 02-readiness-broken.yaml to test readiness behavior.

---

# Task 3 — Deploy a Healthy NGINX Application

## Goal

Create a healthy NGINX Deployment with readiness and liveness probes.

### Evidence

#### Screenshot 3 — Completed `00-nginx-deploy.yaml` manifest

![Task 3.A](<screenshots/week 12-assignment 09-screenshot -03.A.png>)
![Task 3.A](<screenshots/week 12-assignment 09-screenshot -03.B.png>).

---

#### Screenshot 4 — Output showing successful rollout and two ready NGINX Pods

![Task 3.B](<screenshots/week 12-assignment 09-screenshot -04.png>).

### Notes

**1. Why must Pods be ready before they should receive public traffic?**

Pods must be ready before receiving public traffic because they need to be capable of handling requests successfully. Routing traffic to Pods that are still starting or experiencing problems could cause failed requests and affect application availability.

**2. What is the role of the readiness probe in this Deployment?**

The readiness probe checks whether NGINX can respond successfully to HTTP requests on port 80. Kubernetes uses the result to determine whether each Pod should be included among the Service's ready backends.

**3. What is the role of the liveness probe in this Deployment?**

The liveness probe checks whether the NGINX container remains healthy. If the container repeatedly fails the liveness check, Kubernetes can restart it to help restore normal operation.

---

# Task 4 — Create and Test the LoadBalancer Service

## Goal

Create a public LoadBalancer Service and verify that the NGINX application is reachable from the internet.

### Evidence

#### Screenshot 5 — Completed `01-nginx-svc-loadbalancer.yaml` manifest

![Task 4.A](<screenshots/week 12-assignment 09-screenshot -05.png>).

---

#### Screenshot 6 — Output showing the Service with an assigned EXTERNAL-IP

![Task 4.B](<screenshots/week 12-assignment 09-screenshot -06.png>).

---

#### Screenshot 7 — Successful curl output from the public IP

![Task 4.C](<screenshots/week 12-assignment 09-screenshot -07.png>).

### Notes

**1. What does `type: LoadBalancer` instruct AKS to do?**

The LoadBalancer Service type instructs AKS to configure Azure networking resources that expose the Kubernetes application through a public IP address. This allows users outside the cluster to access NGINX without knowing the individual Pod IP addresses.

**2. What public IP was assigned to your Service?**

Azure assigned the public IP address [40.74.161.136] to my nginx-svc-lb Service.

**3. How does the public request eventually reach the NGINX Pods?**

When a user sends a request to the public IP, Azure Load Balancer forwards the traffic toward the AKS cluster. Kubernetes Service networking then directs the request to one of the available ready NGINX Pods, which processes the request and returns the response.

**4. Why should you wait for EXTERNAL-IP before testing the Service?**

I must wait for the external IP because Azure needs time to provision and configure the load-balancing infrastructure. Until the public IP is assigned, I do not have a confirmed public address to use for testing.

---

# Task 5 — Observe How Readiness Protects Public Traffic

## Goal

Intentionally break readiness and observe how Kubernetes excludes unready Pods from ready Service backends while existing healthy Pods continue serving public traffic.

### Evidence

#### Screenshot 8 — Completed `02-readiness-broken.yaml` patch file

![Task 5.A](<screenshots/week 12-assignment 09-screenshot -08.png>).

---

#### Screenshot 9 — Output showing the expected incomplete rollout or readiness failure

![Task 5.B](<screenshots/week 12-assignment 09-screenshot -09.png>).

---

#### Screenshot 10 — EndpointSlice output showing ready healthy backends and the effect of the readiness failure

![Task 5.C](<screenshots/week 12-assignment 09-screenshot -10.png>).

---

#### Screenshot 11 — Successful public curl response after recovery

![Task 5.D](<screenshots/week 12-assignment 09-screenshot -11.png>).

### Notes

**1. Why did the rollout not complete?**

The rollout did not complete because I intentionally changed the readiness probe to request /does-not-exist, which returned an unsuccessful HTTP response. As a result, the new NGINX Pod remained unready, preventing Kubernetes from completing the rolling update.

**2. Why can the public endpoint still work while new Pods fail readiness?**

The public endpoint can remain accessible because the existing healthy Pods continue serving requests. The Deployment's rolling update strategy uses maxUnavailable: 0, which helps preserve the required number of available replicas while the new Pod is not ready.

**3. What would happen if Kubernetes routed traffic to Pods before they were ready?**

Users could experience failed requests, connection errors, or inconsistent application responses. Readiness checks reduce this risk by preventing unready Pods from receiving normal Service traffic.

**4. How did you restore the Deployment successfully?**

I reapplied the original healthy Deployment manifest, restoring the readiness probe to /. Kubernetes then completed the rollout, returned the Deployment to two ready Pods, and allowed the LoadBalancer Service to continue routing traffic to healthy backends.

---

# Task 6 — Scale the Deployment Behind the Load Balancer

## Goal

Scale the NGINX Deployment and confirm that more ready Pods become available behind the same public endpoint.

### Evidence

#### Screenshot 12 — Two ready NGINX Pods verified initially; four ready Pods verified after scaling

![Task 6.A](<screenshots/week 12-assignment 09-screenshot -12.png>).

---

#### Screenshot 13 — Successful public curl response after scaling

![Task 6.B](<screenshots/week 12-assignment 09-screenshot -13.png>).

### Notes

**1. What changed after scaling the Deployment from two to four replicas?**

After scaling the Deployment, Kubernetes increased the number of NGINX Pods from two to four. The two additional Pods were created and, once they passed their readiness probes, became available to receive traffic through the LoadBalancer Service. This demonstrated how Kubernetes can increase application capacity without interrupting access to the existing healthy Pods.

**2. Did the public IP change after scaling? Explain why or why not.**

The public IP remained unchanged because I scaled the NGINX Deployment without deleting or recreating the LoadBalancer Service. Kubernetes updated the Service's backend endpoints to include the additional ready Pods while maintaining the same public entry point.

**3. Why does scaling behind a LoadBalancer Service not require users to change the URL or IP they use?**

A LoadBalancer Service provides a stable public entry point that operates independently of individual application Pods. When the Deployment scales, Kubernetes automatically updates the Service's backend endpoints to include the additional healthy Pods. This allows users to continue accessing the application through the same public IP address without needing to know which Pod handles their request.

---

# Task 7 — Share Your LoadBalancer Lab on LinkedIn

## Goal

Share what you learned about exposing an NGINX application publicly through a LoadBalancer Service on AKS.

### Evidence

#### Screenshot 14 — Published LinkedIn post about your LoadBalancer lab on AKS

![Task 6.C](<screenshots/week 12-assignment 09-screenshot -14.png>).

#### LinkedIn post link

[LinkedIn URL](https://www.linkedin.com/posts/peace-offor-aa736a147_%F0%9D%97%AA%F0%9D%97%B2%F0%9D%97%B2%F0%9D%97%B8-%F0%9D%9F%AD%F0%9D%9F%AE-%F0%9D%97%94%F0%9D%98%80%F0%9D%98%80%F0%9D%97%B6%F0%9D%97%B4%F0%9D%97%BB%F0%9D%97%BA%F0%9D%97%B2%F0%9D%97%BB%F0%9D%98%81-%F0%9D%9F%AC-ugcPost-7515663092039467011-hxAa/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ).

---

# Submission Instructions

- Include the completed YAML files:
  - `00-nginx-deploy.yaml`
  - `01-nginx-svc-loadbalancer.yaml`
  - `02-readiness-broken.yaml`
- Add all required screenshots, numbered 1–14, under their corresponding Evidence sections.
- Use clear, readable screenshots showing the relevant commands, configuration, and outputs.
- Ensure your full name is visible in the required screenshots.
- Complete the Notes for Tasks 1–6 in your own words.
- Capture all required evidence before cleaning up Azure resources.
- Plan or complete Azure cleanup according to your lab ownership and reuse arrangements.
- Do not expose passwords, tokens, private keys, cluster credentials, kubeconfig contents, subscription IDs, account IDs, or infrastructure details you are not permitted to share.

---

# Completion Checklist

- [-] Created or connected to an approved AKS lab cluster
- [-] Confirmed ready AKS node(s) (Screenshot 1)
- [-] Created and entered the LoadBalancer lab directory (Screenshot 2)
- [-] Created the NGINX Deployment manifest (Screenshot 3)
- [-] Verified successful rollout and two ready NGINX Pods initially (Screenshot 4)
- [-] Created the LoadBalancer Service manifest (Screenshot 5)
- [-] Verified the assigned external IP (Screenshot 6)
- [-] Verified successful public access using curl (Screenshot 7)
- [-] Created the broken readiness patch (Screenshot 8)
- [-] Observed the expected incomplete rollout or readiness failure (Screenshot 9)
- [-] Inspected EndpointSlices during the readiness failure (Screenshot 10)
- [-] Restored the healthy Deployment and verified public access (Screenshot 11)
- [-] Scaled the Deployment to four ready Pods and verified updated Service backends (Screenshot 12)
- [-] Verified public access after scaling (Screenshot 13)
- [-] Completed the Notes for Tasks 1–6
- [-] Published the LinkedIn post (Screenshot 14)
- [-] Included all required YAML files and screenshots
- [-] Planned or completed Azure cleanup
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
