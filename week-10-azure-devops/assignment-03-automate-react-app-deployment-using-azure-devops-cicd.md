# Assignment 3 — Automate React App Deployment Using Azure DevOps CI/CD

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create a multi-stage Azure DevOps pipeline that builds, tests, publishes, and deploys a React application to an Ubuntu VM hosted on AWS or Azure. The pipeline will automatically run when changes are committed to `main`, transfer the production build as an artifact, and deploy it through Nginx.

---

# Task 0 — Verify the Starting Environment

## Goal

Confirm that Azure DevOps, the pipeline agent, Terraform, Ansible, and the selected cloud environment are ready.

No submission screenshot is required for this task.

---

# Task 1 — Import and Personalize the React Application

## Goal

Import the React application into Azure Repos and add your Full Name and the current date.

## Evidence

### Screenshot 1 — Imported React Project in Azure Repos

Add a screenshot of Azure Repos showing:

* Imported React project
* Repository name
* `main` branch
* Project files

![Task 1](<screenshots/week 10-assignment 03-screenshot 1.png>).

---

# Task 2 — Provision and Configure the Target VM

## Goal

Provision an Ubuntu VM using Terraform and configure Nginx, React SPA routing, SSH access, and deployment permissions using Ansible.

No separate submission screenshot is required for this task.

---

# Task 3 — Create or Update the SSH Service Connection

## Goal

Create or update an Azure DevOps SSH Service Connection that allows the pipeline to connect securely to the target VM.

No separate submission screenshot is required for this task.

> Do not include the VM password, SSH private key, token, or another secret in the submission.

---

# Task 4 — Author the Multi-Stage Azure Pipeline

## Goal

Create an Azure Pipeline containing Build, Test, Publish, and Deploy stages with an automatic trigger for commits to `main`.

## Evidence

### Screenshot 2 — Multi-Stage Pipeline YAML

Add a screenshot of the Azure Pipeline YAML open in the editor showing:

* Trigger
* Build stage
* Test stage
* Publish stage
* Deploy stage

![Task 4](<screenshots/week 10-assignment 03-screenshot 2.A.png>)
![Task 4](<screenshots/week 10-assignment 03-screenshot 2.B.png>)
![Task 4](<screenshots/week 10-assignment 03-screenshot 2.C.png>)
![Task 4](<screenshots/week 10-assignment 03-screenshot 2.D.png>)
![Task 4](<screenshots/week 10-assignment 03-screenshot 2.E.png>).

> Do not expose passwords, private keys, tokens, or cloud credentials.

---

# Task 5 — Run the Pipeline and Resolve Configuration Issues

## Goal

Complete a successful end-to-end pipeline run containing all four stages.

## Evidence

### Screenshot 3 — Successful Multi-Stage Pipeline Run

Add a screenshot of one Azure DevOps pipeline run showing all four stages succeeded:

* Build
* Test
* Publish
* Deploy

![Task 5](<screenshots/week 10-assignment 03-screenshot 3.A.png>)
![Task 5](<screenshots/week 10-assignment 03-screenshot 3.B.png>).

---

# Task 6 — Verify the Deployment on the VM

## Goal

Confirm that the pipeline deployed the production-ready React files to the correct Nginx web root.

## Evidence

### Screenshot 4 — Post-Deployment Contents of /var/www/html

Add a screenshot of the pipeline SSH verification log or VM terminal showing the post-deployment contents of:

`/var/www/html`

![Task 6](<screenshots/week 10-assignment 03-screenshot 4.png>).

---

# Task 7 — Verify the Website and Automatic Trigger

## Goal

Confirm that the React application is accessible and that a commit to `main` automatically triggers the CI/CD pipeline.

## Evidence

### Screenshot 5 — Deployed React Application

Add a browser screenshot showing:

* Deployed React application
* VM public IP address in the browser address bar
* Your Full Name
* Deployment date

![Task 7](<screenshots/week 10-assignment 03-screenshot 5.png>).

## Final Application URL

`http://51.21.3.169`

Replace the placeholder and paste your final application URL below:

[[Final Application URL](http://51.21.3.169/).]

---

# CI/CD Workflow Summary

Write a short explanation of the CI/CD workflow you created.

[I implemented a multi-stage Azure DevOps CI/CD pipeline to automate the build, testing, artifact publishing, and deployment of a React application. The pipeline is automatically triggered by changes committed to the main branch. During the Build stage, the required Node.js environment and dependencies are prepared and the React production build is generated. The Test stage executes the application's tests before deployment can continue.

The production build is transferred between stages using Azure DevOps Pipeline Artifacts. During the Publish stage, the deployment artifact is verified and published for use by the Deploy stage. The Deploy stage downloads the artifact and uses an Azure DevOps SSH Service Connection to securely transfer the compiled React files to /var/www/html on the Ubuntu VM.

Nginx serves the deployed React application from the VM, with SPA routing configured through Ansible. The deployment is verified by confirming that index.html and the compiled assets exist in /var/www/html, Nginx is active, and the application responds successfully over HTTP. This workflow provides an automated CI/CD process from a commit to main through production deployment.]

---

# LinkedIn Requirement

## Evidence

### Screenshot 6 — LinkedIn Post

Add a screenshot of your LinkedIn post showing:

* Post text
* At least one image or link

![Task 5](<screenshots/week 10-assignment 03-screenshot 6.png>).

## LinkedIn Post URL

[[LinkedIn Post](https://lnkd.in/p/evGzRzXd).]

> Do not expose VM passwords, tokens, private keys, cloud credentials, or other sensitive information.

---

# Submission Instructions

* Complete all tasks in sequence.
* Include the short CI/CD workflow summary.
* Include Screenshots 1–6.
* Include the final application URL.
* Include the public LinkedIn post URL.
* Confirm that all screenshots are readable and show the required context.
* Do not expose passwords, PATs, private keys, cloud credentials, subscription IDs, account IDs, or other secrets.
* Follow the Assignment Submission Guidelines.

---

# Completion Checklist

* [-] All tasks were completed in sequence
* [-] The correct React repository was imported into Azure Repos
* [-] Your Full Name and date were added to the application
* [-] The pipeline YAML was authored and committed to the repository
* [-] Commits to `main` trigger the pipeline automatically
* [-] The pipeline contains Build, Test, Publish, and Deploy stages
* [-] All four stages succeeded in the same pipeline run
* [-] The production build moved between stages as a pipeline artifact
* [-] The Deploy stage used the SSH Service Connection
* [-] No password or secret is stored in the YAML
* [-] `index.html` is directly inside `/var/www/html`
* [-] Raw React source code was not deployed to the Nginx web root
* [-] `node_modules/` was not deployed to the Nginx web root
* [-] Nginx is active
* [-] The application opens through the VM public IP address
* [-] Your Full Name and date are visible in the browser screenshot
* [-] Screenshots 1–6 are included and readable
* [-] No password, token, private key, account ID, or other secret is visible
* [-] The final application URL is included
* [-] The LinkedIn post is published
* [-] The LinkedIn post URL is included

---

*This submission is part of the DevOps Micro Internship (DMI) — Agentic AI Track.*
