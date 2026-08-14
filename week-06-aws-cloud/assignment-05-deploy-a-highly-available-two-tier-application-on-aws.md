# Assignment 5 — Deploy a Highly Available Two-Tier Application on AWS (VPC + ALB + ASG + Multi-AZ RDS)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will design and deploy a highly available two-tier web application on AWS: highly available networking across two Availability Zones, an Application Load Balancer, an Auto Scaling Group for the web tier, and a private Multi-AZ RDS database. You must prove high availability with real failure tests.

---

# Task 1 — Create HA Networking (VPC + 4 Subnets + IGW + NAT + Route Tables)

## Goal

Build a VPC (10.0.0.0/16) with two public and two private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, and the matching public/private route tables.

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

![Task 1.A](<screenshots/week 06-assignment 05-screenshot 1.png>).

---

#### Screenshot 2 — Subnets list showing four subnets and their Availability Zones

![Task 1.B](<screenshots/week 06-assignment 05-screenshot 2.png>).

---

#### Screenshot 3 — Public route table showing the Internet Gateway route and both public-subnet associations

![Task 1.C](<screenshots/week 06-assignment 05-screenshot 3.png>).

---

#### Screenshot 4 — Private route table showing the NAT Gateway route and both private-subnet associations

![Task 1.D](<screenshots/week 06-assignment 05-screenshot 4.png>).

---

#### Screenshot 5 — NAT Gateway status showing Available and the Elastic IP

![Task 1.E](<screenshots/week 06-assignment 05-screenshot 5.png>).

---

# Task 2 — Create Security Groups (ALB, EC2, RDS) with Least Privilege

## Goal

Create `ha-alb-sg` (HTTP public), `ha-web-sg` (HTTP only from `ha-alb-sg`, SSH from your IP), and `ha-db-sg` (database port only from `ha-web-sg`).

### Evidence

#### Screenshot 6 — ALB Security Group inbound rules

![Task 2.A](<screenshots/week 06-assignment 05-screenshot 6.png>).

---

#### Screenshot 7 — EC2 Security Group inbound rules showing the ALB Security Group reference and SSH from your IP

![Task 2.B](<screenshots/week 06-assignment 05-screenshot 7.png>).

---

#### Screenshot 8 — RDS Security Group inbound rule showing the database port allowed only from the EC2 Security Group

![Task 2.C](<screenshots/week 06-assignment 05-screenshot 8.png>).

---

# Task 3 — Deploy Database Tier (RDS Multi-AZ in Private Subnets)

## Goal

Launch a private, Multi-AZ RDS database (MySQL or PostgreSQL) using the private DB Subnet Group and `ha-db-sg`.

### Evidence

#### Screenshot 9 — RDS summary showing Multi-AZ = Yes and Publicly accessible = No

![Task 3.A](<screenshots/week 06-assignment 05-screenshot 9.A.png>).

![Task 3.A](<screenshots/week 06-assignment 05-screenshot 9.B.png>).

---

#### Screenshot 10 — RDS connectivity section showing the DB Subnet Group and Security Group

![Task 3.B](<screenshots/week 06-assignment 05-screenshot 10.png>).

---

# Task 4 — Build a Launch Template (User Data Installs App + Connects to DB)

## Goal

Create a Launch Template whose user data installs the web-server runtime, deploys the application, configures the database connection, and starts the required services.

### Evidence

#### Screenshot 11 — Launch Template details showing that user data exists, including a visible snippet

![Task 4.A](<screenshots/week 06-assignment 05-screenshot 11.png>).

---

#### Screenshot 12 — A running instance created from the template showing that the application responds on port 80 through a local test or browser using its public IP

![Task 4.B](<screenshots/week 06-assignment 05-screenshot 12.A.png>).
![Task 4.B](<screenshots/week 06-assignment 05-screenshot 12.B.png>).

---

# Task 5 — Create an Application Load Balancer (ALB) Across 2 Public Subnets

## Goal

Create an internet-facing ALB across both public subnets with an HTTP listener and a healthy instance target group.

### Evidence

#### Screenshot 13 — ALB details showing two public subnets in two Availability Zones

![Task 5](<screenshots/week 06-assignment 05-screenshot 13.png>).

---

#### Screenshot 14 — Target group showing at least one healthy target

![Task 5](<screenshots/week 06-assignment 05-screenshot 14.png>).

---

# Task 6 — Create Auto Scaling Group (ASG) in 2 Public Subnets

## Goal

Create an Auto Scaling Group from the Launch Template across both public subnets, with desired capacity 2, minimum 2, and maximum 4, registered to the ALB target group.

### Evidence

#### Screenshot 15 — Auto Scaling Group showing desired, minimum, and maximum capacity and the selected subnet Availability Zones

Add your screenshot here.

---

#### Screenshot 16 — EC2 instances list showing two running instances in different Availability Zones

![Task 6](<screenshots/week 06-assignment 05-screenshot 16.png>).

---

# Task 7 — Configure App to Use RDS + Validate Read/Write

## Goal

Confirm the application communicates with the RDS database through the ALB DNS name with at least one read and one write operation.

### Evidence

#### Screenshot 17 — Browser showing the application loaded through the ALB DNS name with the URL visible

![Task 7](<screenshots/week 06-assignment 05-screenshot 17.png>).

---

#### Screenshot 18 — Proof of a database write through a UI message or database query output

![Task 7](<screenshots/week 06-assignment 05-screenshot 18.png>).

---

# Task 8 — High Availability Tests (Must Do Both)

## Goal

Test A: terminate one web instance and confirm the Auto Scaling Group replaces it automatically without interrupting the ALB.

Test B: simulate an Availability Zone impact (stop, detach, or reduce desired capacity in one AZ) and confirm the application stays available.

### Evidence

#### Screenshot 19 — EC2 showing the terminated instance and the newly launched instance; timestamps are helpful

![Task 8.A](<screenshots/week 06-assignment 05-screenshot 19.png>).

---

#### Screenshot 20 — Target group showing healthy targets after replacement

![Task 8.B](<screenshots/week 06-assignment 05-screenshot 20.png>).

---

#### Screenshot 21 — Evidence that an instance was removed, detached, placed in Standby, or stopped in one Availability Zone

![Task 8.C](<screenshots/week 06-assignment 05-screenshot 21.png>).

---

#### Screenshot 22 — Browser showing that the ALB DNS endpoint still works during the change

![Task 8.D](<screenshots/week 06-assignment 05-screenshot 22.png>) EpicBook remained accessible through the Application Load Balancer DNS endpoint while one web instance was placed in Standby, demonstrating continued application availability.

---

# Task 9 — Architecture and Test-Results Summary

## Goal

Summarize the VPC/subnet layout, the ALB and Auto Scaling Group setup, the private Multi-AZ RDS setup, and the results of both high-availability tests.

### Evidence

#### Screenshot 23 — A simple architecture diagram, which may be hand-drawn, or an AWS console overview showing the components

![Task 9](<screenshots/week 06-assignment 05-screenshot 23.png>)Add your screenshot here.

---

### Notes

Summarize the VPC and subnets across the two Availability Zones.

I created a custom VPC for the highly available EpicBook application in the eu-north-1 AWS Region. The architecture spans two Availability Zones, eu-north-1a and eu-north-1b. Public subnets are used for the Application Load Balancer and web-tier EC2 instances, while private subnets are used for the RDS database tier. Distributing the infrastructure across two Availability Zones reduces dependence on a single AZ and improves application availability.

Summarize the ALB and Auto Scaling Group setup.

I configured an internet-facing Application Load Balancer (ha-alb) across the two public subnets. The ALB uses an HTTP listener on port 80 and forwards requests to the ha-web-tg target group. The web servers are managed by the ha-web-asg Auto Scaling Group with a desired capacity of 2, minimum capacity of 2, and maximum capacity of 4. The ASG distributes EC2 instances across the two Availability Zones and automatically replaces instances when required.

Summarize the private Multi-AZ RDS setup.

I configured an Amazon RDS MySQL database for the EpicBook application in private subnets so that the database is not directly exposed to the public internet. The RDS configuration spans multiple Availability Zones for improved database availability. The EC2 application tier connects to RDS over MySQL port 3306 using security-group-controlled access. I validated database connectivity and configured the application to use the RDS endpoint through its database connection environment variable.

Summarize the results of both high-availability tests.

Test A — Instance replacement: I removed/terminated one web-tier EC2 instance while keeping the Auto Scaling Group desired capacity at 2. The Auto Scaling Group detected the capacity change and launched a replacement instance. After initialization and health checks, the replacement became healthy and was available to the load balancer.

Test B — Availability Zone/instance impact: I placed one EC2 instance in Standby to simulate loss of capacity in one Availability Zone. The remaining healthy instance continued serving requests through the Application Load Balancer. I refreshed the ALB DNS endpoint during the test and confirmed that the EpicBook application remained accessible.

These tests demonstrated that the architecture can maintain application availability when a web instance is removed from service and that the Auto Scaling Group can restore the required web-tier capacity.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the high-availability build, including the ALB URL (or a redacted screenshot), three to five lines on what you built and how you tested high availability, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_aws-devops-cloudcomputing-activity-7494069858188414976-3pu3?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

#### Screenshot of LinkedIn post

![Linkedin Post](<screenshots/week 06-assignment 05-screenshot 24.png>).

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose passwords, connection strings, private keys, or account IDs

---

# Completion Checklist

- [-] Task 1: VPC, four subnets, IGW, NAT Gateway, and route tables created (Screenshots 1–5)
- [-] Task 2: Least-privilege ALB, EC2, and RDS security groups created (Screenshots 6–8)
- [-] Task 3: Private Multi-AZ RDS created (Screenshots 9–10)
- [-] Task 4: Self-configuring Launch Template created and tested (Screenshots 11–12)
- [-] Task 5: ALB created across both public subnets (Screenshots 13–14)
- [-] Task 6: Auto Scaling Group running two instances across two AZs (Screenshots 15–16)
- [-] Task 7: Application verified through the ALB with a database read and write (Screenshots 17–18)
- [-] Task 8: Both high-availability tests completed (Screenshots 19–22)
- [-] Task 9: Architecture and test-results summary completed (Screenshot 23 & Notes)
- [-] LinkedIn post published and URL submitted
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