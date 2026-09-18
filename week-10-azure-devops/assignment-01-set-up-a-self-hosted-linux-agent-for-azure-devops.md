# Assignment 1 — Set Up a Self-Hosted Linux Agent for Azure DevOps (Ubuntu + PAT)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will set up a self-hosted Azure DevOps build agent on an Ubuntu VM (AWS or Azure), registering it with a Personal Access Token in a dedicated agent pool, running it as a system service, and verifying it by running a test pipeline.

---

# Task 1 — Create a Personal Access Token (PAT)

## Goal

Create a PAT with Agent Pools (Read & Manage) and Build (Read & Execute) scopes, and store it securely.

> No PAT value screenshot required. If you capture the token settings page, ensure the secret value is not visible.

---

# Task 2 — Create an Agent Pool

## Goal

Create a self-hosted agent pool (e.g. `SelfHostedPool`) in Azure DevOps Organization Settings.

### Evidence

#### Screenshot 1 — Azure DevOps Agent Pools page showing the newly created pool

![Task 2](<screenshots/week 10-assignment 01-screenshot 1.png>).

---

# Task 3 — Provision the Ubuntu VM

## Goal

Create an Ubuntu 22.04 (or latest) VM in AWS or Azure with SSH access, and confirm connectivity.

### Evidence

#### Screenshot 2 — Cloud console showing the running Ubuntu VM and its public IP or DNS name

![Task 3.A](<screenshots/week 10-assignment 01-screenshot 2.png>).

---

#### Screenshot 3 — Terminal showing a successful SSH login and Ubuntu version details

![Task 3.B](<screenshots/week 10-assignment 01-screenshot 3.png>).

---

# Task 4 — Install and Configure the Agent

## Goal

Download the Linux agent package, register it with your organization/pool/PAT via `config.sh`, and install/start it as a system service.

### Evidence

#### Screenshot 4 — Terminal showing successful agent configuration without exposing the PAT

![Task 4.A](<screenshots/week 10-assignment 01-screenshot 4.png>).

---

#### Screenshot 5 — Terminal showing the agent service running successfully

![Task 4.B](<screenshots/week 10-assignment 01-screenshot 5.png>).

---

# Task 5 — Verify the Setup

## Goal

Confirm the agent service is running and the agent shows as Online in the Azure DevOps agent pool.

### Evidence

#### Screenshot 6 — Agent Pool listing showing the registered agent online

![Task 5](<screenshots/week 10-assignment 01-screenshot 6.png>).

---

# Task 6 — Run a Test Pipeline

## Goal

Create and run a YAML pipeline targeting the self-hosted pool, running `uname -a`, `whoami`, and `df -h` on the VM.

### Evidence

#### Screenshot 7 — Successful test pipeline run output in Azure DevOps showing the Linux commands

![Task 6](<screenshots/week 10-assignment 01-screenshot 7.png>).

---

### Notes

Note the cloud platform used, your Azure DevOps organization/project name, and the agent pool name. Describe any issue you faced and how you resolved it.

### Notes

Cloud Platform: Microsoft Azure
Azure DevOps Organization: DMI-Cohort3-PeaceOffor
Azure DevOps Project: Self-Hosted-Agent
Agent Pool: SelfHostedPool

For this assignment, I used Microsoft Azure to provision an Ubuntu VM that served as the self-hosted Linux agent for Azure DevOps.

During the setup, I encountered some challenges while configuring and connecting the self-hosted agent to Azure DevOps. I resolved these by verifying the agent configuration, confirming that my "Personal Access Token (PAT)" had the required permissions, and checking that the Azure DevOps agent service was properly installed and running on the Ubuntu VM. I also verified that the agent was registered to the correct agent pool. After completing these checks, the self-hosted agent successfully appeared as **Online** in Azure DevOps.

To validate the complete setup, I created and ran a test YAML pipeline using the "SelfHostedPool". The pipeline successfully executed the required Linux commands, including `uname -a`, `whoami`, and `df -h`, directly on the Ubuntu VM. The output confirmed the Linux system information, showed that the pipeline was running under the `azureuser` account, and displayed the VM's disk usage.

The successful pipeline run confirmed that my Microsoft Azure Ubuntu VM was correctly registered as a self-hosted Azure DevOps agent and was ready to execute CI/CD pipeline workloads.


---

# Submission Instructions

- Add all required screenshots in your submission
- Do not display the PAT, SSH private key, or other secrets in screenshots or logs

---

# Completion Checklist

- [-] Task 1: PAT created with required scopes and stored securely
- [-] Task 2: Self-hosted agent pool created (Screenshot 1)
- [-] Task 3: Ubuntu VM provisioned and SSH verified (Screenshots 2–3)
- [-] Task 4: Agent installed, registered, and running as a service (Screenshots 4–5)
- [-] Task 5: Agent verified Online (Screenshot 6)
- [-] Task 6: Test pipeline run successfully (Screenshot 7)
- [-] Platform/org/pool details and issue notes written (Notes)
- [-] No secrets exposed

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

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
