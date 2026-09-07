# Capstone Assignment — Deploy the Book Review App Using Terraform and Claude Code Agentic AI

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Peace Nwadinachi Offor  
**Cloud Platform:** AWS  
**GitHub Repository URL:** (https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra) 
**Public Application URL / Load-Balancer DNS:** [Public Application URL](http://book-review-public-alb-735743509.eu-north-1.elb.amazonaws.com)

---

## Purpose

Deploy the Book Review App using Terraform on AWS or Azure in a secure, highly available, production-style three-tier architecture. Use Claude Code, specialized subagents, Terraform MCP, and validation hooks to support the engineering workflow while keeping all infrastructure-changing operations under human control.

---

# Task 0 — Prepare the Project and Agentic AI Environment

## Goal

Prepare the Book Review App project and configure the provided Claude Code Agentic AI starter kit with project context, specialized subagents, Terraform MCP, validation hooks, and safety guardrails.

## Evidence

### Screenshot 1 — Project `CLAUDE.md`

Add a screenshot of the project `CLAUDE.md` showing the three-tier architecture, security boundaries, Terraform requirements, and human-approval rules.

![Task 0.A](<screenshots/week 08-assignment 05-screenshot 1.A.png>).
![Task 0.A](<screenshots/week 08-assignment 05-screenshot 1.B.png>)

---

### Screenshot 2 — Terraform Engineer Subagent

Add a screenshot showing the Terraform Engineer subagent configuration.

![Task 0.B](<screenshots/week 08-assignment 05-screenshot 2.png>).

---

### Screenshot 3 — Architecture and Security Reviewer Subagent

Add a screenshot showing the Architecture and Security Reviewer subagent configuration.

![Task 0.C](<screenshots/week 08-assignment 05-screenshot 3.png>).

---

### Screenshot 4 — Terraform MCP Connection

Add a screenshot showing Terraform MCP connected and available.

![Task 0.D](<screenshots/week 08-assignment 05-screenshot 4.png>).

---

### Screenshot 5 — Validation Hooks

Add a screenshot showing the configured Claude Code validation hooks.

![Task 0.E](<screenshots/week 08-assignment 05-screenshot 5.A.png>).
![Task 0.E](<screenshots/week 08-assignment 05-screenshot 5.B.png>)

---

# Task 1 — Design the Three-Tier Architecture

## Goal

Design the required secure, highly available three-tier architecture and create an architecture diagram before building the infrastructure.

The diagram must show:

- VPC or VNet
- Availability Zones or equivalent availability locations
- Six subnets
- Internet connectivity
- NAT or outbound design
- Public load balancer
- Web Tier
- Internal load balancer
- Application Tier
- Managed MySQL
- Read replica
- Main traffic flow

## Architecture Diagram

![Task 1 - Architecture Diagram](<screenshots/week 08-assignment 05-screenshot 5.B.png>).

---

# Task 2 — Build the Terraform Networking and Security Layers

## Goal

Create the modular Terraform project and implement the network and security layers across the required public and private subnets.

## Evidence

### Screenshot 6 — Modular Terraform Project Structure

Add a screenshot showing the modular Terraform project structure.

![Task 3.A](<screenshots/week 08-assignment 05-screenshot 6.png>).

---

### Screenshot 7 — Six-Subnet Architecture

Add a screenshot showing the six-subnet architecture across two availability locations.

![Task 3.B](<screenshots/week 08-assignment 05-screenshot 7.png>).

---

### Screenshot 8 — Public and Private Tier Separation

Add a screenshot showing the public and private tier separation, including routing and security boundaries.

![Task 3.C](<screenshots/week 08-assignment 05-screenshot 8.png>).

---

# Task 3 — Build the Load-Balancing and Compute Layers

## Goal

Deploy the public and internal load balancers and the Web and Application compute resources required by the Book Review App.

## Evidence

### Screenshot 9 — Web and Application Compute

Add a screenshot showing the Web and Application compute resources in their required subnets.

![Task 3.A](<screenshots/week 08-assignment 05-screenshot 9.png>).

---

### Screenshot 10 — Public Load Balancer

Add a screenshot showing the internet-facing public load balancer.

![Task 3.B](<screenshots/week 08-assignment 05-screenshot 10.png>).

---

### Screenshot 11 — Internal Load Balancer

Add a screenshot showing the private internal load balancer.

![Task 3.C](<screenshots/week 08-assignment 05-screenshot 11.png>).

---

### Screenshot 12 — Healthy Targets

Add a screenshot showing healthy target groups or backend pools.

![Task 3.D](<screenshots/week 08-assignment 05-screenshot 12.A.png>).
![Task 3.D](<screenshots/week 08-assignment 05-screenshot 12.B.png>)
![Task 3.D](<screenshots/week 08-assignment 05-screenshot 12.C.png>)


---

# Task 4 — Build the Managed MySQL Database Layer

## Goal

Deploy a private, highly available managed MySQL database with a read replica and restrict database connectivity to the Application Tier.

## Evidence

### Screenshot 13 — Managed MySQL Database

Add a screenshot showing the managed MySQL database deployment.

![Task 4.A](<screenshots/week 08-assignment 05-screenshot 13.png>).

---

### Screenshot 14 — High Availability

Add a screenshot showing the Multi-AZ or high-availability configuration.

![Task 4.B](<screenshots/week 08-assignment 05-screenshot 14.png>).

---

### Screenshot 15 — Read Replica

Add a screenshot showing the read replica configuration.

![Task 4.C](<screenshots/week 08-assignment 05-screenshot 15.png>).

---

### Screenshot 16 — Private Database Access

Add a screenshot showing that the database is private and accepts MySQL traffic only from the Application Tier.

![Task 4.D](<screenshots/week 08-assignment 05-screenshot 16.A.png>)
![Task 4.D](<screenshots/week 08-assignment 05-screenshot 16.B.png>)
![Task 4.D](<screenshots/week 08-assignment 05-screenshot 16.C.png>).

---

# Task 5 — Validate, Review, and Apply the Terraform Configuration

## Goal

Validate the Terraform configuration, review the execution plan using both Agentic AI and human judgment, and apply the infrastructure changes only after all required checks pass.

## Evidence

### Screenshot 17 — Terraform Validation

Add a screenshot showing successful `terraform validate` output.

![Task 5.A](<screenshots/week 08-assignment 05-screenshot 17.A.png>)
![Task 5.A](<screenshots/week 08-assignment 05-screenshot 17.B.png>).


---

### Screenshot 18 — Terraform Plan

Add a screenshot showing the Terraform plan output.

![Task 5.B](<screenshots/week 08-assignment 05-screenshot 18.A.png>)
![Task 5.B](<screenshots/week 08-assignment 05-screenshot 18.B.png>)
![Task 5.B](<screenshots/week 08-assignment 05-screenshot 18.C.png>).

---

### Screenshot 19 — Terraform Apply

Add a screenshot showing successful `terraform apply` completion.

![Task 5.C](<screenshots/week 08-assignment 05-screenshot 19.A.png>).

---

# Task 6 — Deploy and Configure the Book Review Application

## Goal

Deploy and configure the Book Review App across the Web, Application, and Database tiers and verify the complete application functionality.

## Evidence

### Screenshot 20 — Homepage

Add a screenshot showing the Book Review App homepage through the public endpoint.

![Task 6.A](<screenshots/week 08-assignment 05-screenshot 20.png>).

---

### Screenshot 21 — Login or Authentication

Add a screenshot showing successful login or authentication.

![Task 6.B](<screenshots/week 08-assignment 05-screenshot 21.png>).

---

### Screenshot 22 — Book Data

Add a screenshot showing the book listing or book details.

![Task 6.C](<screenshots/week 08-assignment 05-screenshot 22.png>).

---

### Screenshot 23 — Review Functionality

Add a screenshot showing the review functionality working successfully.

![Task 6.D](<screenshots/week 08-assignment 05-screenshot 23.png>).

---

### Screenshot 24 — Backend or API Evidence

Add a screenshot showing that the backend or API is working successfully.

![Task 6.E](<screenshots/week 08-assignment 05-screenshot 24.png>).

---

### Screenshot 25 — Database Reads and Writes

Add a screenshot showing successful database reads and writes.

![Task 6.F](<screenshots/week 08-assignment 05-screenshot 25.png>).

## Public Application URL

**Public Application URL / DNS:** (http://book-review-public-alb-735743509.eu-north-1.elb.amazonaws.com/)

---

# Task 7 — Demonstrate the Agentic AI Workflow

## Goal

Demonstrate how Claude Code assisted with Terraform generation, architecture and security review, and evidence-based troubleshooting while infrastructure-changing decisions remained under human control.

You do not need to submit your complete Claude Code conversation history. Include only focused evidence.

## Evidence

### Screenshot 26 — AI-Assisted Terraform Generation

Add a screenshot showing one useful example of AI-assisted Terraform generation or improvement.

![Task 7.A](<screenshots/week 08-assignment 05-screenshot 26.A.png>).
![Task 7.A](<screenshots/week 08-assignment 05-screenshot 26.B.png>)
![Task 7.A](<screenshots/week 08-assignment 05-screenshot 26.C.png>)
![Task 7.A](<screenshots/week 08-assignment 05-screenshot 26.D.png>)
![Task 7.A](<screenshots/week 08-assignment 05-screenshot 26.E.png>)

---

### Screenshot 27 — Architecture or Security Review

Add a screenshot showing one structured architecture or security review result.

![Task 7.B](<screenshots/week 08-assignment 05-screenshot 27.A.png>).
![Task 7.B](<screenshots/week 08-assignment 05-screenshot 27.B.png>)
![Task 7.B](<screenshots/week 08-assignment 05-screenshot 27.C.png>)

---

### Screenshot 28 — AI-Assisted Troubleshooting

Add a screenshot showing one AI-assisted troubleshooting interaction based on collected evidence.

![Task 7.C](<screenshots/week 08-assignment 05-screenshot 28.A.png>).
![Task 7.C](<screenshots/week 08-assignment 05-screenshot 28.B.png>)
![Task 7.C](<screenshots/week 08-assignment 05-screenshot 28.C.png>)
![Task 7.C](<screenshots/week 08-assignment 05-screenshot 28.D.png>)
![Task 7.C](<screenshots/week 08-assignment 05-screenshot 28.E.png>)

---

# Task 8 — Complete the Final Architecture Review

## Goal

Review the completed infrastructure against the original capstone requirements and resolve significant architecture, security, reliability, and cost issues.

Confirm that the final review covers:

- Tier separation
- Availability
- Public exposure
- Routing
- Security rules
- Load balancing
- Database privacy
- Secrets
- Terraform quality
- Module structure
- Reliability
- Obvious cost risks

Use Screenshot 27 as the focused evidence for the structured architecture or security review.

---

# Task 9 — Answer the Reflection Questions

## Goal

Reflect on the architecture, Terraform implementation, and Agentic AI workflow. Answer each question briefly in your own words.

## Architecture

### 1. Why did you separate the Web, Application, and Database tiers?

I separated the tiers so that each layer has a specific responsibility and can be secured independently. The Web Tier handles incoming requests, the Application Tier handles business logic, and the Database Tier stores persistent data. This also reduces unnecessary exposure between components.

### 2. Why is the Application Tier private?

The Application Tier is private because users do not need to communicate with it directly. Requests reach it through the Web Tier and Internal ALB. Keeping it private reduces the attack surface and prevents direct internet access to the backend on port 3001.

### 3. Why is MySQL private?

MySQL contains sensitive application and user data, so it should never be directly accessible from the internet. I configured RDS with publicly_accessible = false and restricted port 3306 so that database traffic comes only from the Application Tier.

### 4. Why are multiple Availability Zones used?

Multiple Availability Zones improve availability and fault tolerance. If resources in one Availability Zone experience a failure, resources in the second AZ can continue serving the application.

### 5. What is the difference between Multi-AZ/high availability and a read replica?

Multi-AZ is primarily for high availability and failover. AWS maintains a standby database that can take over if the primary fails. A read replica is primarily for read scaling, allowing read workloads to be moved away from the primary database. They solve different problems.

## Terraform

### 6. How did you divide your Terraform into modules?

I divided the Terraform configuration according to infrastructure responsibilities. I created separate modules for network, security, compute, load-balancer, and database.The network module manages the VPC, subnets, routing, Internet Gateway and NAT Gateway. Security manages security groups, compute manages EC2 instances, load-balancer manages the public and internal ALBs, and database manages RDS.

### 7. How do the modules communicate through variables and outputs?
Modules expose important resource information through outputs, and the root configuration passes those values into other modules as input variables. For example, the network module outputs subnet and VPC IDs, which are passed to the compute, security, load-balancer, and database modules where required.

### 8. What did you specifically check in `terraform plan`?

I checked that Terraform planned only the changes I expected. I paid particular attention to unexpected resource destruction or replacement, networking changes, security-group rules, EC2 placement, load balancers, and RDS changes.

This was especially important when Terraform initially proposed replacing my RDS read replica. I investigated the cause instead of applying the plan immediately and corrected the configuration before proceeding.

## Agentic AI

### 9. What was the purpose of `CLAUDE.md`?

CLAUDE.md provided project-specific instructions and guardrails for Claude Code. It helped define the architecture, Terraform workflow, security expectations, validation requirements, and actions Claude should not perform automatically, such as applying or destroying infrastructure without human review.

### 10. What work did the Terraform Engineer subagent perform?

The Terraform Engineer inspected the Terraform configuration and compared it against the capstone requirements. It reviewed the VPC, six-subnet design, routing, EC2 placement, public and internal load balancers, security groups, RDS configuration, Multi-AZ deployment, read replica, and module relationships. It also recommended targeted improvements where necessary.

### 11. What did the Architecture and Security Reviewer identify?

The reviewer confirmed that most of the required architecture and security controls were correctly implemented, including tier separation, private application instances, private RDS, security-group chaining, Multi-AZ, and the read replica.

It also identified risks such as a single-AZ NAT Gateway, static EC2 instances without Auto Scaling, local Terraform state, cost exposure from always-on resources, and limited RDS deletion protection.

### 12. Why did you use Terraform MCP instead of relying only on Claude's existing Terraform knowledge?

I used Terraform MCP so Claude could work with more relevant Terraform information and tooling rather than relying only on its general knowledge. This helped make the Agentic AI workflow more grounded in Terraform-specific context and reduced the risk of relying on outdated assumptions.

### 13. What was the purpose of your validation hooks?

The validation hooks provided automated checks around the Terraform workflow. Their purpose was to catch formatting or configuration problems early and encourage validation before infrastructure changes were considered.This supported the workflow: Generate/Edit >> terraform fmt >> terraform validate >> terraform plan >> AI review >> Human review >> terraform apply

### 14. Describe one real issue Claude helped you troubleshoot.

Claude helped troubleshoot the Book Review App authentication problem. The application loaded, but registration/login was not working correctly. Claude inspected the frontend and backend source code and found that the frontend API requests appeared to omit the /api prefix even though Express mounted the backend routes under /api. It also identified a second possibility: App1 and App2 could be using inconsistent database configuration.Claude also discovered that the seeded demo users contained password values that were not valid bcrypt hashes, meaning those demo accounts could fail authentication even though the normal registration controller correctly hashes new passwords.

### 15. Describe one recommendation you reviewed, modified, or rejected instead of accepting blindly.

During the final architecture review, Claude recommended changes such as deploying a NAT Gateway in each Availability Zone and replacing the static EC2 design with Auto Scaling Groups.
I reviewed these recommendations instead of automatically implementing them. They are useful production improvements, but they went beyond the specific requirements of the capstone and would also increase complexity and, in some cases, cost. This reinforced an important lesson for me: AI recommendations should be treated as engineering input, not automatic decisions.

---

# Task 10 — Publish the Mandatory LinkedIn Post

## Goal

Publish a LinkedIn post describing the capstone, the technical work completed, the Agentic AI workflow, and the lessons learned.

Write the post in your own words, include at least one project image or other proof, and ensure that it can be viewed by the submission reviewer.

## LinkedIn Post URL

**LinkedIn Post URL:** (https://lnkd.in/p/e87JanMQ)

---

# Submission Instructions

- Complete Tasks 0–10 in sequence.
- Include all Screenshots 1–28 exactly as specified.
- Ensure that your full name is visible in the required screenshots.
- Include the selected cloud platform.
- Include the completed architecture diagram.
- Include the modular Terraform project structure.
- Include the working public application URL or public load-balancer DNS.
- Include all required Agentic AI workflow evidence.
- Answer all 15 reflection questions briefly in your own words.
- Include the published LinkedIn post URL.
- Do not expose cloud credentials, database passwords, SSH private keys, JWT secrets, access tokens, account IDs, Terraform state containing sensitive values, or other confidential information.
- Review all screenshots and project files carefully before submitting through GitHub.

---

# Completion Checklist

- [-]Selected AWS or Azure
- [-] Added and reviewed the Agentic AI starter files
- [-] Configured `CLAUDE.md`
- [-] Configured the Terraform Engineer subagent
- [-] Configured the Architecture and Security Reviewer subagent
- [-] Connected Terraform MCP
- [-] Configured validation hooks and safety guardrails
- [-] Created the architecture diagram
- [-] Created the six-subnet design
- [ ] Configured public Web Tier routing
- [-] Kept the Application Tier private
- [-] Kept the Database Tier private
- [-] Configured tier-specific Security Groups or NSGs
- [-] Restricted backend port `3001`
- [-] Restricted MySQL port `3306` to the Application Tier
- [-] Created the public load balancer
- [-] Created the internal load balancer
- [-] Configured listeners and health checks
- [-] Deployed the Web Tier compute resources
- [-] Deployed the private Application Tier compute resources
- [-] Provisioned private managed MySQL
- [-] Configured Multi-AZ or high availability
- [-] Configured a read replica
- [-] Created the modular Terraform project
- [-] Used variables, outputs, and module dependencies
- [-] Used current Terraform documentation through MCP
- [-] Used hooks for deterministic validation
- [-] Completed `terraform fmt`
- [-] Completed `terraform validate`
- [-] Reviewed `terraform plan`
- [-] Completed the Terraform Engineer review
- [-] Completed the Architecture and Security review
- [-] Applied the infrastructure only after human approval
- [-] Deployed and configured the backend
- [-] Deployed and configured the frontend
- [-] Configured Nginx where required
- [-] Configured the internal backend endpoint
- [-] Configured the public frontend endpoint
- [-] Verified the homepage
- [-] Verified login or authentication
- [-] Verified book data
- [-] Verified review functionality
- [-] Verified the backend API
- [-] Verified database reads and writes
- [-] Verified healthy load-balancer targets
- [-] Included AI-assisted Terraform generation evidence
- [-] Included one architecture or security review
- [-] Included one AI-assisted troubleshooting example
- [-] Completed the final architecture review
- [-] Answered all 15 reflection questions
- [-] Published the mandatory LinkedIn post
- [-] Added the LinkedIn post URL
- [-] Captured all 28 required screenshots
- [-] Confirmed that my full name is visible in the required screenshots
- [-] Checked that no secrets or sensitive information are exposed-
---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory), focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations through hands-on experience.

---

## Resources

- Book Review App Repository: [https://github.com/pravinmishraaws/book-review-app](https://github.com/pravinmishraaws/book-review-app)
- DMI Official Website: [https://dmi.pravinmishra.com](https://dmi.pravinmishra.com)
- University: [https://university.pravinmishra.com](https://university.pravinmishra.com)
- Discord Community: [https://discord.pravinmishra.com](https://discord.pravinmishra.com)
- Blog: [https://dmi.pravinmishra.com/blog](https://dmi.pravinmishra.com/blog)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra on LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory on LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
