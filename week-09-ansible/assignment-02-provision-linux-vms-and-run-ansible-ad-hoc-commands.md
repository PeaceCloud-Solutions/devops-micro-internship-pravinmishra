# Assignment 02 — Provision Linux VMs with Terraform and Run Ansible Ad-Hoc Commands

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision three or four Ubuntu Linux Virtual Machines on either Microsoft Azure or Amazon Web Services.

You will configure SSH key-based authentication, organize the servers using a custom Ansible inventory, and run Ansible ad-hoc commands across individual hosts and inventory groups.

---

# Task 1 — Create the Multi-Host Lab Structure

## Goal

Create a separate project directory for the multi-host lab and prepare the Terraform, Ansible, and documentation files.

This project will use the Git repository and Ansible controller prepared in Assignment 01.

### Evidence

#### Screenshot 1 — Terminal showing the complete `ansible-adhoc-lab` project structure

![Task 1.A](<screenshots/week 09-assignment 02-screenshot 1.png>).

---

#### Screenshot 2 — Terminal showing `git status --short` with the new project files and updated `.gitignore`

![Task 1.B](<screenshots/week 09-assignment 02-screenshot 2.png>).

---  

### Notes

I created the ansible-adhoc-lab project inside my existing Ansible workspace and separated the project into terraform and ansible directories. The Terraform directory contains the infrastructure configuration files, while the Ansible directory contains the custom inventory. I also created the project README.md and updated .gitignore to prevent Terraform state files, virtual environments, SSH private keys, and other sensitive/generated files from being committed to Git.

---

# Task 2 — Create the Terraform Configuration

## Goal

Create the Terraform configuration required to provision three or four Ubuntu Linux VMs on your selected cloud platform.

Complete only one option:

- Option A — Microsoft Azure
- Option B — Amazon Web Services

Do not configure both providers for this assignment.

### Evidence

#### Screenshot 3 — Terraform configuration showing the three or four server roles and the `for_each` or `count` implementation

![Task 2.A](<screenshots/week 09-assignment 02-screenshot 3.png>).

---

#### Screenshot 4 — Terraform configuration showing SSH restricted to the controller IP and HTTP allowed only for web hosts

![Task 2.B](<screenshots/week 09-assignment 02-screenshot 4.png>).

---

#### Screenshot 5 — Terraform output configuration showing how public IP addresses are associated with the server roles

![Task 2.C](<screenshots/week 09-assignment 02-screenshot 5.png>).

---

### Notes

I used Amazon Web Services (AWS) and selected the three-VM option for this assignment. I created the web1, app1, and db1 server roles and used Terraform for_each to provision the EC2 instances consistently from the same configuration. I configured an Ubuntu AMI, VPC, public subnet, Internet Gateway, route table, security groups, and an AWS key pair using my existing SSH public key. SSH access on port 22 was restricted to my Ansible controller's current public IP using a /32 CIDR instead of allowing SSH from anywhere. Terraform outputs were also configured to map each server role to its public IP address.

---

# Task 3 — Provision the Infrastructure with Terraform

## Goal

Initialize and validate the Terraform configuration, review the execution plan, provision the selected three or four VMs, and retrieve their public IP addresses.

### Evidence

#### Screenshot 6 — Final `terraform apply` output showing `Apply complete`

![Task 3.A](<screenshots/week 09-assignment 02-screenshot 6.png>).

---

#### Screenshot 7 — `terraform output public_ips` showing the role-to-IP mapping for all three or four VMs

![Task 3.B](<screenshots/week 09-assignment 02-screenshot 7.png>).

---

#### Screenshot 8 — Azure Portal or AWS Management Console showing all three or four VMs in the `Running` state, with their role-based names visible

![Task 3.C](<screenshots/week 09-assignment 02-screenshot 8.png>).

---

### Notes

I initialized the Terraform working directory, formatted and validated the configuration, reviewed the execution plan, and then applied the configuration to AWS. Terraform successfully provisioned the required infrastructure and three Ubuntu EC2 instances. The final apply completed successfully with 11 resources added, and I used terraform output public_ips to retrieve the public IP addresses mapped to web1, app1, and db1. I also verified in the AWS Management Console that all three EC2 instances were running.

---

# Task 4 — Verify SSH Key-Based Access

## Goal

Verify that each managed VM can be accessed from the Ansible controller using SSH key-based authentication.

### Evidence

#### Screenshot 9 — Terminal showing successful SSH hostname output from all VMs

![Task 4](<screenshots/week 09-assignment 02-screenshot 9.A.png>).
![Task 4](<screenshots/week 09-assignment 02-screenshot 9.B.png>)

---

### Notes

I verified SSH key-based authentication from my WSL Ansible controller to all three Ubuntu EC2 instances. I retrieved the public IP addresses from the Terraform outputs and connected using the ubuntu user and my ED25519 SSH key. I executed the hostname command remotely against web1, app1, and db1, and each server returned its hostname successfully. During testing, I also refreshed the controller's public IP /32 security-group rule when required so that SSH remained restricted to my current public IP.

---

# Task 5 — Create the Custom Ansible Inventory

## Goal

Create an Ansible inventory file that groups the managed VMs by role.

The inventory allows Ansible to run commands against all servers, or only specific groups such as `web`, `app`, or `db`.

### Evidence

#### Screenshot 10 — `inventory.ini` showing the `web`, `app`, and `db` groups

![Task 5.A](<screenshots/week 09-assignment 02-screenshot 10.png>).

---

#### Screenshot 11 — Output of `ansible-inventory -i inventory.ini --graph`

![Task 5.B](<screenshots/week 09-assignment 02-screenshot 11.png>).

---

### Notes

I created a custom inventory.ini file and organized the three managed servers into the [web], [app], and [db] groups. Each inventory host uses its EC2 public IP address because my Ansible controller is outside the AWS VPC. I configured the ubuntu SSH user and my existing ED25519 private-key path for authentication. I then used ansible-inventory -i inventory.ini --graph to verify that web1, app1, and db1 were assigned to the correct inventory groups.

---

# Task 6 — Run Ansible Ad-Hoc Commands

## Goal

Run Ansible ad-hoc commands from the controller to verify connectivity, check server information, and manage packages and services across inventory groups.

This task proves that the inventory is working and that Ansible can control multiple managed VMs without writing a playbook.

### Evidence

#### Screenshot 12 — Output of `ansible all -i inventory.ini -m ping`

![Task 6.A](<screenshots/week 09-assignment 02-screenshot 12.png>).

---

#### Screenshot 13 — Output of `ansible all -i inventory.ini -m command -a "uptime"`

![Task 6.B](<screenshots/week 09-assignment 02-screenshot 13.png>).

---

#### Screenshot 14 — Output of `ansible web -i inventory.ini -m apt -a "name=nginx state=present update_cache=yes" --become`

![Task 6.C](<screenshots/week 09-assignment 02-screenshot 14.png>).

---

#### Screenshot 15 — Output of `ansible web -i inventory.ini -m service -a "name=nginx state=started enabled=yes" --become`

![Task 6.D](<screenshots/week 09-assignment 02-screenshot 15.png>).

---

#### Screenshot 16 — Output of `ansible all -i inventory.ini -m apt -a "name=htop state=present update_cache=yes" --become`

![Task 6.E](<screenshots/week 09-assignment 02-screenshot 16.png>).

---

#### Screenshot 17 — Output of `ansible web -i inventory.ini -m command -a "systemctl is-active nginx"`

![Task 6.F](<screenshots/week 09-assignment 02-screenshot 17.png>).

---

### Notes

I used Ansible ad-hoc commands to manage the three EC2 instances without creating a playbook. I first used the Ansible ping module to verify SSH connectivity and Python execution on all managed hosts, followed by the command module to check their uptime. I targeted only the web group to install, start, and enable Nginx using privilege escalation with --become. I then installed htop across all managed servers and verified that the Nginx service on the web server returned active. These tests demonstrated how Ansible inventory groups can be used to perform either role-specific or environment-wide administrative operations from a single controller.

---

# LinkedIn Post Required

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_devops-ansible-terraform-activity-7504138582903877633-PAX3?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

#### Screenshot — Published LinkedIn post

![Linkedin Post](<screenshots/week 09-assignment 02-screenshot 18.png>).

---

# Assignment Questions

Answer the following in your own words:

**1. What is the purpose of an Ansible inventory file?**

An Ansible inventory file defines the managed servers that Ansible connects to and organizes them into groups. It can also store connection information such as the server IP address, SSH username, and SSH private-key path. This allows me to target all servers or specific groups when running Ansible commands.

---

**2. What is the difference between the `web`, `app`, and `db` groups in your inventory?**

The groups organize the servers according to their roles. The web group contains the web server, the app group contains the application server, and the db group contains the database server. Grouping the hosts allows me to run commands only on the servers that require them, such as installing Nginx only on the web group.

---

**3. What does the Ansible `ping` module verify?**

The Ansible ping module verifies that Ansible can successfully connect to a managed server through SSH and execute Python on the remote system. It is different from the normal network ICMP ping command.

---

**4. Why do package installation commands require `--become`?**

Package installation and service-management operations require administrative privileges. The --become option tells Ansible to use privilege escalation on the managed server so that tasks such as installing Nginx or htop can run with the required permissions.

---

**5. When would you use an ad-hoc command instead of a playbook?**

I would use an Ansible ad-hoc command for a quick, one-time administrative operation, such as checking uptime, testing connectivity, checking disk space, installing a small package, or restarting a service. I would use a playbook when the configuration needs to be repeatable, structured, and reusable.

---

**6. What is one challenge you faced while setting up SSH or inventory, and how did you fix it?**

One challenge I faced was setting up SSH correctly on my WSL Ansible controller. Initially, the expected SSH key and configuration files were not available in the correct Linux home directory. I created the required .ssh directory, generated/configured my ED25519 SSH key, started the SSH agent, and added the private key with ssh-add. I then verified the setup using ssh-add -l. This helped ensure that my controller was ready to authenticate to managed servers using SSH keys.

---

# Required Files

Confirm that the following files are included in your assignment workspace:

- [-] `ansible-adhoc-lab/README.md`
- [-] `ansible-adhoc-lab/terraform/providers.tf`
- [-] `ansible-adhoc-lab/terraform/main.tf`
- [-] `ansible-adhoc-lab/terraform/variables.tf`
- [-] `ansible-adhoc-lab/terraform/outputs.tf`
- [-] `ansible-adhoc-lab/ansible/inventory.ini`
- [-] Updated `.gitignore`

---

# Submission Instructions

- Add all required screenshots from the tasks.
- Full Name must be visible in required screenshots.
- Mention whether you used Azure or AWS.
- Mention whether you used the three-VM option or four-VM option.
- Add the public IP addresses of the VMs, redacted if preferred.
- Add your `inventory.ini` proof.
- Add a short explanation of what you learned.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, Terraform state files, cloud credentials, passwords, access keys, secret keys, account IDs, or subscription IDs.
- Submit only one Google Doc link.

---

# Completion Checklist

- [-] Task 1: `ansible-adhoc-lab` project structure created
- [-] Task 1: `.gitignore` updated for Terraform files
- [-] Task 2: Terraform configuration created
- [-] Task 2: Server roles defined for either three or four VMs
- [-] Task 2: `count` or `for_each` used
- [-] Task 2: SSH restricted to the controller public IP
- [-] Task 2: HTTP allowed only for web hosts
- [-] Task 2: Terraform output maps roles to public IPs
- [-] Task 3: Terraform initialized successfully
- [-] Task 3: Terraform configuration validated
- [-] Task 3: Terraform apply completed successfully
- [-] Task 3: All selected VMs are running
- [-] Task 4: SSH key-based access works for every VM
- [-] Task 5: `inventory.ini` contains `web`, `app`, and `db` groups
- [-] Task 5: `ansible-inventory -i inventory.ini --graph` shows the correct groups
- [-] Task 6: `ansible all -i inventory.ini -m ping` returns `SUCCESS`
- [-] Task 6: Ad-hoc commands run successfully
- [-] Task 6: `--become` was used for package and service tasks
- [-] Task 6: Nginx is active on the `web` group
- [-] Screenshots 1–17 are included
- [-] Assignment questions are answered
- [-] LinkedIn post published
- [-] LinkedIn post URL added
- [-] No sensitive information is exposed
- [-] Google Doc is accessible

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra and The CloudAdvisory, focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## Resources

- DMI Official Website: [https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme)
- University: [https://university.pravinmishra.com?utm_source=github&utm_medium=readme](https://university.pravinmishra.com?utm_source=github&utm_medium=readme)
- Discord Community: [https://discord.pravinmishra.com?utm_source=github&utm_medium=readme](https://discord.pravinmishra.com?utm_source=github&utm_medium=readme)
- Blog: [https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*