# Assignment 10 — Capstone: Deploy the Book Review App to Kubernetes

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy the Book Review App as a production-style three-tier application using Kubernetes manifests or Helm charts, with an accessible frontend, an internal backend, and a managed or persistent MySQL database.

---

## Submission Details

**Full Name:** Peace Nwadinachi Offor.

**Kubernetes Platform:**Azure Kubernetes Service (AKS).

**Namespace:** book-review

**Frontend URL or IP:** [Frondend URL](http://20.94.141.137).

**Access Method:** Public LoadBalancer (Azure Kubernetes Service).

**GitHub Manifests or Helm Chart URL:** [GitHub Helm Chart URL](https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra/tree/main/helm/book-review).

**Architecture Diagram:** ![ Three-Tier Kubernetes Architecture Diagram](<screenshots/week 12-assignment 10-screenshot -3.png>).

---

# Task 1 — Prepare the Kubernetes Cluster and Project

## Goal

Prepare the cluster, application source, container images, and tooling needed for the deployment.

### Evidence

#### Screenshot 1 — Active Kubernetes context and Ready nodes

![Task 1.A](<screenshots/week 12-assignment 10-screenshot -1.png>).

---

#### Screenshot 2 — If using Helm: Output of `helm version`

Required only if you choose Helm. Skip this screenshot if using YAML manifests.

![Task 1.B](<screenshots/week 12-assignment 10-screenshot -2.png>).

---

# Task 2 — Design the Three-Tier Kubernetes Architecture

## Goal

Document the workloads, networking, configuration, storage, and permitted communication paths before deployment.

### Evidence

#### Screenshot 3 — Completed Kubernetes architecture diagram

![Task 2](<screenshots/week 12-assignment 10-screenshot -3.png>).

---

# Task 3 — Create ConfigMaps and Secrets

## Goal

Provide application configuration and credentials without embedding sensitive values in images or committing them to Git.

### Evidence

#### Screenshot 4 — ConfigMap configuration or describe output showing non-sensitive values

![Task 3.A](<screenshots/week 12-assignment 10-screenshot -4.png>).

---

#### Screenshot 5 — Secret references or describe output showing names and keys without sensitive values

![Task 3.B](<screenshots/week 12-assignment 10-screenshot -5.png>).

---

# Task 4 — Deploy and Configure the MySQL Data Tier

## Goal

Provide persistent MySQL storage and allow the backend to connect without exposing the database publicly.

### Evidence

#### Screenshot 6 — Managed MySQL status or MySQL StatefulSet and PVC status

![Task 4.A](<screenshots/week 12-assignment 10-screenshot -6.png>).

---

#### Screenshot 7 — Successful database connectivity or schema verification with credentials hidden

![Task 4.B](<screenshots/week 12-assignment 10-screenshot -7.png>).

---

# Task 5 — Deploy the Backend Application Tier

## Goal

Run one or two Node.js/Express backend replicas on port 3001 and expose them through an internal ClusterIP Service.

### Evidence

#### Screenshot 8 — Backend Deployment, ready Pods, and internal Service

![Task 5.A](<screenshots/week 12-assignment 10-screenshot -8.png>).

---

#### Screenshot 9 — Backend startup logs and database connectivity evidence

If the application does not log successful database connections, provide a successful database-backed request alongside the startup logs.

![Task 5.B](<screenshots/week 12-assignment 10-screenshot -9.png>).

---

# Task 6 — Deploy the Frontend and Configure Nginx

## Goal

Run the Next.js frontend behind Nginx on port 80 and proxy API requests to the internal backend Service.

### Evidence

#### Screenshot 10 — Frontend Deployment and Ready Pods

![Task 6.A](<screenshots/week 12-assignment 10-screenshot -10.png>).

---

#### Screenshot 11 — Nginx reverse-proxy configuration showing the internal backend Service name and port 3001

![Task 6.B](<screenshots/week 12-assignment 10-screenshot -11.png>).

---

# Task 7 — Configure External and Internal Networking

## Goal

Expose the frontend and enforce the intended communication path between application tiers.

### Evidence

#### Screenshot 12 — Frontend LoadBalancer or Ingress configuration and assigned endpoint, or documented local access method

![Task 7.A](<screenshots/week 12-assignment 10-screenshot -12.png>).

---

#### Screenshot 13 — Internal backend Service and NetworkPolicy or equivalent restriction, with access-test evidence

![Task 7.B](<screenshots/week 12-assignment 10-screenshot -13.A.png>)
![Task 7.B](<screenshots/week 12-assignment 10-screenshot -13.B.png>).

---

# Task 8 — Validate the Application End to End

## Goal

Prove that the frontend, backend, and MySQL database work together and collect operational evidence.

### Evidence

#### Screenshot 14 — `kubectl get all` output for the book-review namespace

![Task 8.A](<screenshots/week 12-assignment 10-screenshot -14.png>).

---

#### Screenshot 15 — Functional Book Review App in the browser with the URL visible, including evidence of a successful user flow

![Task 8.B](<screenshots/week 12-assignment 10-screenshot -15.A.png>)
![Task 8.B](<screenshots/week 12-assignment 10-screenshot -15.B.png>)
![Task 8.B](<screenshots/week 12-assignment 10-screenshot -15.C.png>)
![Task 8.B](<screenshots/week 12-assignment 10-screenshot -15.D.png>).

---

#### Screenshot 16 — Frontend or Nginx container logs

![Task 8.C](<screenshots/week 12-assignment 10-screenshot -16.A.png>)
![Task 8.C](<screenshots/week 12-assignment 10-screenshot -16.B.png>).

---

#### Screenshot 17 — Backend logs and evidence of a successful database-backed operation

![Task 8.D](<screenshots/week 12-assignment 10-screenshot -17.A.png>)
![Task 8.D](<screenshots/week 12-assignment 10-screenshot -17.B.png>).

---

#### Screenshot 18 — Optional: Kubernetes dashboard

“Not attempted" Kubernetes resources were verified using kubectl commands instead of a graphical dashboard.

---

# Task 9 — Optional: Implement Production Improvements

## Goal

Add selected improvements without breaking the required three-tier architecture.

### Evidence

#### Screenshot 19 — Optional: Evidence of selected Helm, HPA, probe, or TLS improvements

![Task 9](<screenshots/week 12-assignment 10-screenshot -19.png>).

---

# Task 10 — Publish Your Book Review App Deployment on LinkedIn

## Goal

Explain your three-tier architecture, demonstrate the working application, and share what you learned.

### Evidence

#### Screenshot 20 — Published LinkedIn post about your Book Review App deployment on Kubernetes

![LinkedIn Post](<screenshots/week 12-assignment 10-screenshot -20.png>).

### LinkedIn Post URL

[LinkedIn URL](https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-kubernetes-azure-ugcPost-7516092482653167617-n5xh/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ).

---

# Final Summary

## What Worked

Describe the application components and user flows you successfully deployed and tested.

For this capstone assignment, I deployed a three-tier Book Review application on Azure Kubernetes Service (AKS) using Helm charts. The application consisted of a Next.js frontend, a Node.js/Express backend, an Nginx reverse proxy, and a MySQL database.

I configured the application within the book-review namespace and used Kubernetes Services to establish communication between the application components. The frontend was exposed through a public LoadBalancer, while the backend and MySQL database communicated through internal Kubernetes networking.

I also configured ConfigMaps and Secrets to manage application settings and sensitive information separately. MySQL was deployed using a StatefulSet with persistent storage to support database operations.

I verified the running Pods, confirmed successful backend connectivity to MySQL, and tested access to the application through its public IP address. Helm also allowed me to manage deployment configurations and update container images without recreating the entire infrastructure.

This assignment improved my understanding of deploying and managing interconnected applications in Kubernetes.

## Issues and Fixes

Describe the main issues encountered, their causes, and how you resolved them.

One of the major challenges I encountered was establishing communication between the frontend and backend after deploying the application to AKS.

Initially, the frontend attempted to communicate with the backend using localhost:3001, which was unsuitable for the publicly deployed application. I investigated the frontend configuration and corrected the API requests to use relative paths, allowing Nginx to forward requests to the internal backend Service.

Another issue occurred during user registration, when the application returned an HTTP 500 Internal Server Error. After examining the browser's Developer Tools and backend logs, I identified a CORS restriction that prevented requests from the application's public IP address.

I updated the backend's allowed origins, validated the JavaScript configuration, and prepared an updated container image for redeployment through Helm.

Throughout the assignment, I also learned to verify container image versions, inspect Kubernetes resources, and troubleshoot application errors systematically.

These challenges reinforced the importance of understanding networking configurations, examining logs, and testing application functionality rather than relying solely on healthy Pod statuses.

## Tools and Sources Used

List the documentation and tools that helped you complete the assignment.

I used several tools and technologies to complete this assignment.

Azure Kubernetes Service (AKS) provided the Kubernetes environment for deploying the application, while Azure Container Registry (ACR) was used to store container images.

I used Docker to package the application components and Helm to manage Kubernetes deployment configurations.

kubectl helped me inspect Pods, Deployments, Services, logs, and other Kubernetes resources. I also used ConfigMaps and Secrets to manage application configuration and credentials.

The application technologies included Next.js for the frontend, Node.js/Express for the backend, Nginx for reverse-proxy configuration, and MySQL for database storage.

My development environment included WSL Ubuntu, Visual Studio Code, and the terminal.

For troubleshooting, I used browser Developer Tools, Kubernetes logs, and application configuration files.

I also referred to the DMI training materials and official documentation for Kubernetes, Helm, Docker, and Microsoft Azure.

## Optional Improvements

Describe any optional improvements implemented, or write “Not attempted.”

For the optional improvements, I implemented Helm-based deployment management for the Book Review application.

Using Helm charts allowed me to organize Kubernetes configurations, manage application components consistently, and update container image versions through the Helm values file.

I used Helm commands to validate the chart and inspect the deployed release. This helped me understand how Helm simplifies application deployment and configuration management in Kubernetes.

I did not implement the optional Kubernetes Dashboard, Horizontal Pod Autoscaling, or TLS configuration.

Instead, I focused on understanding the three-tier architecture, troubleshooting application connectivity, and maintaining a stable Kubernetes deployment..

## Cleanup or Reuse Plan

State which resources were removed or why the environment is being retained.

I decided to retain the AKS environment temporarily to complete application testing, verify deployment evidence, and finalize the assignment documentation.

Before cleaning up the infrastructure, I will ensure that all required screenshots, Helm charts, Kubernetes configuration files, and supporting documentation are saved in my GitHub repository.

Once the assignment has been completed and submitted, I plan to review the Azure resources and delete any infrastructure that is no longer required to avoid unnecessary cloud charges.

I will retain the application source code and reusable Helm charts for future Kubernetes practice and deployment exercises.

This approach will allow me to recreate the application when necessary while improving my understanding of infrastructure lifecycle management and cloud cost optimizatione.

---

# Submission Instructions

- Include your Kubernetes manifests or Helm chart in the linked repository.
- Submit Secret examples containing placeholders only.
- Include Screenshot 1, Screenshots 3–17, and Screenshot 20.
- Include Screenshot 2 only if using Helm.
- Screenshots 18–19 are optional.
- Keep screenshot numbering consistent with the guidelines.
- Use clear, readable screenshots showing relevant configuration, commands, and outputs.
- Make your full name visible in required screenshots.
- Complete the submission details and Final Summary.
- Include your published LinkedIn post URL.
- Capture required evidence before cleanup.
- Do not expose passwords, tokens, JWT secrets, actual Secret values, kubeconfig contents, cloud credentials, or confidential account information.

---

# Completion Checklist

- [-] Selected and configured a supported Kubernetes platform
- [-] Confirmed the context and Ready nodes (Screenshot 1)
- [-] Created and selected the book-review namespace
- [-] Inspected the application repository
- [-] Prepared images accessible to the cluster
- [-] Confirmed Helm if using charts (Screenshot 2, conditional)
- [-] Created the architecture diagram (Screenshot 3)
- [-] Created ConfigMaps and Secrets (Screenshots 4–5)
- [-] Excluded actual Secret values from Git and screenshots
- [-] Provisioned private managed MySQL or persistent Kubernetes MySQL (Screenshot 6)
- [-] Initialized the required database and schema
- [-] Verified database connectivity or schema (Screenshot 7)
- [-] Deployed one or two backend replicas listening on port 3001
- [-] Created the backend ClusterIP Service (Screenshot 8)
- [-] Verified backend-to-database connectivity (Screenshot 9)
- [-] Deployed one or two frontend replicas behind Nginx (Screenshot 10)
- [-] Configured API proxying through the internal backend Service (Screenshot 11)
- [-] Configured and documented frontend access (Screenshot 12)
- [-] Enforced backend access restrictions (Screenshot 13)
- [-] Confirmed that the backend and database are not publicly exposed
- [-] Captured resource status for book-review (Screenshot 14)
- [ ] Tested application functionality and database writes (Screenshots 15 and 17)
- [-] Verified saved data after application restart
- [-] Captured frontend and backend logs (Screenshots 16–17)
- [-] Included optional dashboard or improvement evidence if attempted (Screenshots 18–19)
- [-] Published the LinkedIn post (Screenshot 20)
- [-] Included the LinkedIn post URL
- [-] Documented issues, fixes, and useful sources
- [-] Recorded cleanup status or reuse plans
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
