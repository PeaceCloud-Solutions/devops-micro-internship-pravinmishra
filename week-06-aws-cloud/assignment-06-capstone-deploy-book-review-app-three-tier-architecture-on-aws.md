# Assignment 6 — Capstone Assignment — Deploy Book Review App (Three-Tier Architecture) on AWS

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a fully production-style three-tier architecture on AWS: a Next.js Web Tier behind Nginx and a public ALB, a private Node.js/Express App Tier behind an internal ALB, and a private Multi-AZ MySQL RDS database with a read replica. You are expected to design, deploy, isolate, debug, and document the result independently.

---

# Task 1 — Architecture Diagram

## Goal

Create an architecture diagram showing the custom VPC (10.0.0.0/16), the six subnets across two Availability Zones (two public Web Tier, two private App Tier, two private Database Tier), the public ALB, Web Tier EC2/Nginx, internal ALB, private App Tier EC2, private Multi-AZ RDS with its read replica, and the permitted traffic flow.

### Evidence

#### Diagram image or link

![Task 1](<screenshots/week 06-assignment 06-screenshot 1.png>).

---

# Task 2 — AWS Region & Services Used

## Goal

Record the AWS Region used and list every AWS service used across networking, compute, load balancing, security, and the database.

### Notes

**Region:**


Europe (Stockholm)-eu-north-1.

---

**Services:**

Networking: Amazon VPC, public and private subnets, Internet Gateway, NAT Gateway, Elastic IP, and Route Tables.
Compute: Amazon EC2.
Load Balancing: Application Load Balancer (public and internal) and Target Groups.
Security: EC2/VPC Security Groups.
Database: Amazon RDS for MySQL, Multi-AZ deployment, and RDS Read Replica.

---

# Task 3 — Public Entry Point

## Goal

Confirm the Book Review App loads through the public ALB DNS name.

### Evidence

#### Public ALB DNS

Paste your public ALB DNS name here:

`http://book-review-public-alb-16602954.eu-north-1.elb.amazonaws.com`

---

# Task 4 — Evidence Screenshots

## Goal

Capture visual proof of every tier and load balancer.

### Evidence

#### Web EC2

![Task 4.A](<screenshots/week 06-assignment 06-screenshot 2.png>).

---

#### App EC2

![Task 4.B](<screenshots/week 06-assignment 06-screenshot 3.png>).

---

#### Public ALB

![Task 4.C](<screenshots/week 06-assignment 06-screenshot 4.png>).

---

#### Internal ALB

![Task 4.D](<screenshots/week 06-assignment 06-screenshot 5.A.png>).

!![Task 4.D](<Screenshots/week 06-assignment 06-screenshot 5.B.png>).

![Task 4.D](<screenshots/week 06-assignment 06-screenshot 5.C.png>).

---

#### RDS + Replica

![Task 4.E](<screenshots/week 06-assignment 06-screenshot 6.png>).

---

#### App UI proof

![Task 4.F](<screenshots/week 06-assignment 06-screenshot 7.png>).

---

# Task 5 — Summary

## Goal

Summarize what worked in the final deployment, the issues encountered and how each was fixed, and the tools or sources used to research and debug.

### Notes

**What worked:**

The Book Review application was deployed using a three-tier AWS architecture in the Europe (Stockholm) eu-north-1 Region. The Web Tier uses EC2 instances running Next.js/Nginx across two public subnets, while a public Application Load Balancer provides the application's external entry point. The App Tier consists of private EC2 instances running the Node.js/Express backend behind an internal Application Load Balancer. The Database Tier uses private Amazon RDS for MySQL with Multi-AZ availability and a read replica. Security groups restrict communication between each tier to the required ports.

---

**Issues + fixes:**

During deployment, I encountered SSH connectivity problems when accessing private App EC2 instances through the Web Tier, backend database authentication errors, and configuration issues with environment variables. I tested connectivity separately at each layer rather than troubleshooting the entire architecture at once. Direct MySQL connections were used to verify App-to-RDS connectivity and database credentials, while local curl, ss, and Node.js tests were used to verify that the backend was listening correctly on port 3001. Security-group rules and jump-host connectivity were also checked when troubleshooting private-instance access.

---

**Tools/sources used:**

AWS Management Console, Ubuntu/Linux command-line tools, SSH, Git, GitHub, Nginx, Node.js/npm, MySQL client, PM2, curl, nc, ss, AWS documentation, and application repository documentation were used to deploy, test, and troubleshoot the architecture..

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post sharing the capstone deployment, including the public ALB DNS (or a redacted screenshot), three to five lines on what you built and why it is production-style, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_aws-devops-cloudcomputing-ugcPost-7494727499528998912-r7MW/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

#### Screenshot of LinkedIn post

![Task 5](<screenshots/week 06-assignment 06-screenshot 8.png>).

---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, RDS credentials, connection strings, private keys, or account IDs

---

# Completion Checklist

- [-] Task 1: Architecture diagram completed
- [-] Task 2: AWS Region and services documented
- [-] Task 3: Public ALB DNS confirmed working
- [-] Task 4: All six evidence screenshots captured (Web Tier, App Tier, both ALBs, RDS + replica, app UI)
- [-] Task 5: Deployment summary completed (what worked, issues/fixes, tools/sources)
- [-] LinkedIn post published and URL submitted
- [-] App Tier and Database Tier confirmed not publicly accessible
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

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*