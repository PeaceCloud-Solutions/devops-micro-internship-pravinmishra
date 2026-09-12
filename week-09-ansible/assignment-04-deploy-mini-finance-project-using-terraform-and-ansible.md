 # Assignment 04 — Deploy Mini Finance on Azure Using Terraform and Ansible

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision Azure infrastructure using Terraform and deploy the Mini Finance website using an Ansible multi-play playbook.

Terraform will create the Azure Virtual Machine and networking resources. Ansible will install Nginx, clone the Mini Finance repository, deploy the website, and verify the deployment.

---

# Task 1 — Create the Project Structure

## Goal

Create separate directories and files for the Terraform infrastructure and Ansible configuration.

### Evidence

#### Screenshot 1 — Terminal or VS Code showing the complete `mini-finance` project structure

![Task 1](<screenshots/week 09-assignment 04-screenshot 1.png>).

---

### Notes

I created the mini-finance project structure with separate terraform and ansible directories. I also created the required Terraform configuration files, Ansible files, README.md, and .gitignore to keep the project properly organized.

---

# Task 2 — Create the Azure Infrastructure Using Terraform

## Goal

Use Terraform to provision an Ubuntu Virtual Machine with the required Azure networking and security resources.

### Evidence

#### Screenshot 2 — Terraform code showing the `Allow-SSH` rule for port `22` and the `Allow-HTTP` rule for port `80`

![Task 2.A](<screenshots/week 09-assignment 04-screenshot 2.png>).

---

#### Screenshot 3 — Terraform code showing the association between `nsg-mini-finance` and `nic-mini-finance`

![Task 2.B](<screenshots/week 09-assignment 04-screenshot 3.png>).

---

### Notes

I created the Terraform configuration for the Azure infrastructure, including the Resource Group, Virtual Network, subnet, Network Security Group, Public IP, Network Interface, and Ubuntu Virtual Machine. SSH access on port 22 was restricted to my controller's public IP address, while HTTP port 80 was opened for public access to the website. I also associated the NSG with the VM's Network Interface.

---

# Task 3 — Initialize and Apply the Terraform Configuration

## Goal

Format and validate the Terraform configuration, review the execution plan, and provision the Azure infrastructure.

### Evidence

#### Screenshot 4 — End of the `terraform apply` output showing `Apply complete!` with no errors

![Task 3.A](<screenshots/week 09-assignment 04-screenshot 4.png>).

---

#### Screenshot 5 — Output of `terraform output public_ip` showing the VM’s public IP address

![Task 3.B](<screenshots/week 09-assignment 04-screenshot 5.png>).

---

### Notes

I formatted, initialized, validated, and applied the Terraform configuration to provision the Azure infrastructure. During deployment, I encountered a VM quota limitation with my initial VM size, so I changed the size to Standard_D2als_v6. The deployment then completed successfully, and Terraform returned the public IP address of the Azure VM.

---

# Task 4 — Verify Passwordless SSH Access

## Goal

Confirm that the Ansible controller can connect to the Terraform-provisioned Azure VM using SSH key authentication.

### Evidence

#### Screenshot 6 — Passwordless SSH command and the returned `mini-finance` hostname

![Task 4](<screenshots/week 09-assignment 04-screenshot 6.png>).

---

### Notes

I tested passwordless SSH connectivity from my Ansible controller to the Azure VM using my existing SSH key. The connection was successful, and the VM returned the hostname mini-finance, confirming that key-based SSH authentication was working correctly.

---

# Task 5 — Create the Ansible Inventory and Verify Connectivity

## Goal

Add the Terraform-provisioned Azure VM to the Ansible inventory and confirm that Ansible can connect to it.

### Evidence

#### Screenshot 7 — Ansible ping output showing `SUCCESS` and `pong` from the Azure VM

![Task 5](<screenshots/week 09-assignment 04-screenshot 7.png>).

---

### Configuration File

Copy and paste the complete contents of your `ansible/inventory.ini` file below:

```ini
[web]
mini-finance ansible_host=20.114.78.236

[web:vars]
ansible_user=azureuser
ansible_ssh_private_key_file=/home/dell_peace/.ssh/id_ed25519
ansible_python_interpreter=/usr/bin/python3
```

---

# Task 6 — Create the Multi-Play Ansible Playbook

## Goal

Create one Ansible playbook containing separate plays to install Nginx, deploy the Mini Finance website, and verify the deployment.

### Evidence

#### Screenshot 8 — `site.yml` showing Play 1 and the beginning of Play 2

Screenshot must show:

- Play 1 targeting the `web` group
- Installation of `nginx`, `git`, and `rsync`
- Nginx service configured as started and enabled
- Beginning of Play 2 with the Git repository URL and synchronization task

![Task 6.A](<screenshots/week 09-assignment 04-screenshot 8.png>).

---

#### Screenshot 9 — `site.yml` showing the deployment destination, handler, and Play 3 verification

Screenshot must show:

- Website destination `/var/www/html/`
- Ownership set to `www-data:www-data`
- Nginx reload handler
- Play 3 targeting `localhost`
- The `uri` verification and `assert` condition

![Task 6.B](<screenshots/week 09-assignment 04-screenshot 9.png>).

---

### Configuration File

Copy and paste the complete contents of your `ansible/site.yml` file below:

```yaml
---
- name: Install and configure Nginx
  hosts: web
  become: true

  tasks:
    - name: Update APT package cache
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install required packages
      ansible.builtin.apt:
        name:
          - nginx
          - git
          - rsync
        state: present

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

- name: Clone and deploy Mini Finance website
  hosts: web
  become: true

  tasks:
    - name: Clone or update Mini Finance repository
      ansible.builtin.git:
        repo: https://github.com/pravinmishraaws/mini_finance
        dest: /opt/mini-finance
        version: main
        update: true

    - name: Synchronize website files to Nginx document root
      ansible.posix.synchronize:
        src: /opt/mini-finance/
        dest: /var/www/html/
        delete: true
        rsync_opts:
          - "--exclude=.git"
      delegate_to: "{{ inventory_hostname }}"
      notify: Reload Nginx

    - name: Set ownership of website files
      ansible.builtin.file:
        path: /var/www/html/
        owner: www-data
        group: www-data
        recurse: true

  handlers:
    - name: Reload Nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded

- name: Verify Mini Finance deployment
  hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Verify website returns HTTP 200
      ansible.builtin.uri:
        url: "http://{{ hostvars[groups['web'][0]].ansible_host }}"
        method: GET
        status_code: 200
      register: website_check

    - name: Assert website is available
      ansible.builtin.assert:
        that:
          - website_check.status == 200
        success_msg: "Mini Finance returned HTTP {{ website_check.status }}"
        fail_msg: "Mini Finance verification failed with HTTP {{ website_check.status }}"
```

---

# Task 7 — Validate and Run the Ansible Playbook

## Goal

Validate the syntax of the multi-play Ansible playbook and run it to install Nginx, deploy the Mini Finance website, and verify the deployment.

### Evidence

#### Screenshot 10 — Successful playbook syntax check showing `playbook: site.yml`

![Task 7.A](<screenshots/week 09-assignment 04-screenshot 10.png>).

---

#### Screenshot 11 — Play 3 output showing the successful HTTP verification and assertion

![Task 7.B](<screenshots/week 09-assignment 04-screenshot 11.png>).

---

#### Screenshot 12 — Final `PLAY RECAP` showing `failed=0` and `unreachable=0`

![Task 7.C](<screenshots/week 09-assignment 04-screenshot 12.png>).

---

### Notes

I first performed an Ansible syntax check to confirm that site.yml was valid. I then ran the complete multi-play playbook to configure Nginx, deploy the Mini Finance website, and verify the deployment. During testing, I discovered that the original repository URL returned “Repository not found.” I identified the correct repository URL, updated site.yml, and reran the playbook successfully. The final play confirmed HTTP status code 200 with no failed or unreachable hosts.

---

# Task 8 — Test the Mini Finance Website in a Browser

## Goal

Confirm that the Mini Finance website is publicly accessible through the Azure VM’s public IP address.

### Evidence

#### Screenshot 13 — Mini Finance website successfully loading in the browser, with the Azure VM’s public IP address visible in the address bar

![Task 8](<screenshots/week 09-assignment 04-screenshot 13.png>).

---

### Website URL

Add your deployed website URL below:

```text
http://20.114.78.236
```

---

# Task 9 — Create the Project README

## Goal

Create a `README.md` file to document the Mini Finance infrastructure and deployment project.

### Evidence

#### Screenshot 14 — Completed `README.md` displayed in the VS Code Markdown preview or terminal

![Task 9.A](<screenshots/week 09-assignment 04-screenshot 14.png>).

---

### README Content

Copy and paste the complete contents of your `README.md` file below:

```markdown
# Mini Finance Deployment on Azure Using Terraform and Ansible

## Project Objective

This project demonstrates how Terraform and Ansible can work together to provision cloud infrastructure and deploy an application. Terraform was used to create the Azure infrastructure, while Ansible configured the Ubuntu server, installed the required packages, deployed the Mini Finance website, and verified the deployment.

## Tools and Technologies

- Terraform
- Microsoft Azure
- Ansible
- Ubuntu Linux
- Nginx
- Git
- rsync

## Infrastructure Created

Terraform provisioned the following Azure resources:

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Static Public IP address
- Network Interface
- Ubuntu Virtual Machine

The Network Security Group allows HTTP traffic on port 80 from the internet while SSH access on port 22 is restricted to the public IP address of my Ansible controller.

## Ansible Deployment Workflow

The Ansible playbook uses three separate plays.

The first play installs Nginx, Git, and rsync and ensures that Nginx is running and enabled.

The second play clones the Mini Finance repository and synchronizes the website files to the Nginx document root at `/var/www/html/`.

The third play runs from the Ansible controller and verifies that the website returns HTTP status code 200.

## Verification

I verified the deployment using the Ansible `uri` module and `assert` module. I also opened the Azure VM public IP address in a web browser and confirmed that the Mini Finance website loaded successfully.

## Challenge and Solution

One challenge I encountered was ensuring that the controller could securely connect to the Azure VM. I restricted SSH access to my current public IP address and used the SSH key created on my Ansible controller. I verified passwordless SSH connectivity before running the Ansible playbook.

## What I Learned

This project helped me understand the separation between infrastructure provisioning and configuration management. Terraform creates and manages the Azure resources, while Ansible configures the operating system and deploys the application. Using both tools together makes the deployment easier to reproduce, maintain, and troubleshoot.
```

---

# LinkedIn Post Required

## Evidence

#### Screenshot 15 — Published LinkedIn post showing the text and at least one deployment screenshot

![Task 9.B](<screenshots/week 09-assignment 04-screenshot 15.png>).

---

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-devops-teraform-activity-7504322268265644033-LApi?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

### LinkedIn Submission Notes

**One challenge you faced and how you fixed it:**

One challenge I faced was that the Mini Finance repository URL provided in the assignment returned a “Repository not found” error, causing the Ansible playbook to stop during the Git clone task. I tested the repository directly with git ls-remote, identified the correct repository, updated the URL in site.yml, and reran the playbook successfully.

---

**One real-world example where you can use this learning:**

I can apply this approach when deploying company web applications to cloud environments. Terraform can consistently provision the required Azure infrastructure, while Ansible can automatically configure the servers, install dependencies, deploy application files, and verify that the application is available.

---

# Assignment Questions

Answer the following in your own words:

**1. What did you provision using Terraform in this assignment?**

I used Terraform to provision the Azure infrastructure required for the Mini Finance website. This included a Resource Group, Virtual Network, subnet, Network Security Group, static Public IP, Network Interface, NSG-to-NIC association, and an Ubuntu Linux Virtual Machine.

---

**2. What did Ansible configure and deploy in this assignment?**

Ansible configured the Azure VM by installing Nginx, Git, and rsync, starting and enabling Nginx, cloning the Mini Finance repository, synchronizing the website files to /var/www/html/, setting the required ownership, and verifying that the website returned HTTP status code 200.

---

**3. Why is SSH access on port `22` restricted to your public IP address?**

SSH port 22 is restricted to my controller's public IP address to reduce unauthorized access attempts. Only my approved Ansible controller can establish an SSH connection to the Azure VM instead of exposing SSH access to the entire internet.

---

**4. Why is HTTP port `80` open to the internet?**

Port 80 is open to the internet because the Mini Finance website is intended to be publicly accessible through HTTP. This allows users to reach the Nginx web server through the Azure VM's public IP address.

---

**5. What is the purpose of the Ansible inventory file?**

The Ansible inventory identifies the server that Ansible manages and provides the connection information required to reach it. In this assignment, it contains the Mini Finance VM's public IP, SSH username, private-key path, and Python interpreter.

---

**6. Why does the playbook use separate plays for install, deploy, and verify?**

Separate plays make the automation easier to understand, maintain, and troubleshoot. The first play prepares the server, the second deploys the website, and the third independently verifies from the controller that the deployed website is accessible.

---

**7. Why is `rsync` useful when deploying website files?**

rsync efficiently synchronizes files between directories and transfers only the changes that are needed. In this assignment, it helps synchronize the Mini Finance website files from /opt/mini-finance/ to the Nginx document root at /var/www/html/.

---

**8. What does the Ansible `uri` module verify in this assignment?**

The Ansible uri module sends an HTTP request to the deployed Mini Finance website and verifies that it responds with HTTP status code 200, confirming that the website is reachable and the web server is responding successfully.

---

**9. What issue did you face during this assignment, and how did you fix it?**

I encountered two notable issues. First, my original Azure VM size exceeded the available vCPU quota, so I changed the VM size to Standard_D2als_v6 while keeping the South Central US region. Later, the Ansible Git task stalled because the repository URL returned “Repository not found.” I tested the repository manually with git ls-remote, corrected the repository URL in site.yml, and reran the playbook..

---

**10. What did you learn from using Terraform and Ansible together?**

I learned that Terraform and Ansible solve different but complementary problems. Terraform provides repeatable infrastructure provisioning, while Ansible handles server configuration and application deployment. Using them together creates a structured workflow where infrastructure can be provisioned first and then automatically configured, deployed, and verified.

---

# Required Files

Confirm that the following files are included in your assignment folder:

- [-] `.gitignore`
- [-] `README.md`
- [-] `terraform/providers.tf`
- [-] `terraform/main.tf`
- [-] `terraform/variables.tf`
- [-] `terraform/outputs.tf`
- [-] `ansible/inventory.ini`
- [-] `ansible/site.yml`

---

# Submission Instructions

- Add all required screenshots in the correct order.
- Full Name must be visible in required screenshots.
- Add the Azure VM public IP address.
- Add the final Mini Finance website URL.
- Paste `inventory.ini`, `site.yml`, and `README.md` as editable text.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, passwords, Azure credentials, subscription IDs, Terraform state contents, or other sensitive information.
- Submit only one Google Doc link.
- Ensure that anyone with the link can view the document.
- Test the Google Doc link in an incognito or private browser window before submitting.

---

# Completion Checklist

- [-] Task 1: `mini-finance` project structure created
- [-] Task 1: `.gitignore` created
- [-] Task 2: Terraform Azure infrastructure code created
- [-] Task 2: `Allow-SSH` rule configured for port `22`
- [-] Task 2: `Allow-HTTP` rule configured for port `80`
- [-] Task 2: NSG associated with the Network Interface
- [-] Task 3: `terraform fmt` completed
- [-] Task 3: `terraform init` completed
- [-] Task 3: `terraform validate` completed successfully
- [-] Task 3: `terraform apply` completed successfully
- [-] Task 3: `terraform output public_ip` displayed the VM public IP
- [-] Task 4: Passwordless SSH works from the Ansible controller
- [-] Task 5: `inventory.ini` created
- [-] Task 5: Ansible ping returns `SUCCESS` and `pong`
- [-] Task 6: `site.yml` contains three separate plays
- [-] Task 6: Play 1 installs Nginx, Git, and rsync
- [-] Task 6: Play 2 clones and deploys the Mini Finance website
- [-] Task 6: Play 3 verifies HTTP status code `200`
- [-] Task 7: Playbook syntax check passes
- [-] Task 7: Ansible playbook completes successfully
- [-] Task 7: Final recap shows `failed=0` and `unreachable=0`
- [-] Task 8: Mini Finance website loads in the browser
- [-] Task 8: Azure VM public IP is visible in the browser screenshot
- [-] Task 9: `README.md` completed
- [-] Screenshots 1–15 are included
- [-] `inventory.ini`, `site.yml`, and `README.md` are pasted as editable text
- [-] Assignment questions are answered
- [-] LinkedIn post published with Anyone visibility
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