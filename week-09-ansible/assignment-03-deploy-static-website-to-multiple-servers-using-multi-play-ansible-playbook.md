# Assignment 03 — Deploy a Static Website to Multiple Servers Using a Multi-Play Ansible Playbook

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Peace Nwadinachi Offor  
**Cloud Platform Used:** AWS 
**Server 1 URL:** `http://56.228.23.157`  
**Server 2 URL:** `http://16.171.170.255`

---

## Purpose

In this assignment, you will create a multi-play Ansible playbook to install Nginx, deploy a static website to two Ubuntu servers, and verify that the website is accessible from both servers.

You may use either AWS EC2 instances or Azure Virtual Machines as your managed servers.

---

# Task 1 — Create the Project Structure

## Goal

Create the required folders and files for the Ansible project.

## Evidence

### Screenshot 1 — Terminal or VS Code showing the complete `static-web` project structure

![Task 1](<screenshots/week 09-assignment 03-screenshot 1.png>).

---

# Task 2 — Configure the Ansible Inventory

## Goal

Add both Ubuntu servers to the Ansible inventory.

## Evidence

### Screenshot 2 — Output of `ansible-inventory -i inventory.ini --graph` showing `web1` and `web2`

![Task 2](<screenshots/week 09-assignment 03-screenshot 2.png>).

---

## Configuration File

Copy and paste the complete contents of your `inventory.ini` file below:

```ini
[web]
web1 ansible_host=56.228.23.157
web2 ansible_host=16.171.170.255

[web:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/dell_peace/.ssh/id_ed25519
ansible_python_interpreter=/usr/bin/python3
```

---

# Task 3 — Verify Ansible Connectivity

## Goal

Confirm that the Ansible controller can connect to both servers.

## Evidence

### Screenshot 3 — Ansible ping output showing `SUCCESS` and `pong` for both servers

![Task 3](<screenshots/week 09-assignment 03-screenshot 3.png>).

---

# Task 4 — Download and Personalize the Static Website

## Goal

Download `index.html` to the Ansible controller and personalize the website with your full name.

## Evidence

### Screenshot 4 — Edited `files/index.html` showing the footer line with your full name

![Task 4](<screenshots/week 09-assignment 03-screenshot 4.png>).

---

# Task 5 — Create the Multi-Play Ansible Playbook

## Goal

Create a single Ansible playbook containing separate plays for installation, deployment, and verification.

## Configuration File

Copy and paste the complete contents of your `site.yml` file below:

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

    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

- name: Deploy static website
  hosts: web
  become: true

  tasks:
    - name: Copy website to Nginx document root
      ansible.builtin.copy:
        src: files/index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: "0644"
      notify: Reload Nginx

  handlers:
    - name: Reload Nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded

- name: Verify websites from Ansible controller
  hosts: localhost
  connection: local
  gather_facts: false

  tasks:
    - name: Check website HTTP response
      ansible.builtin.uri:
        url: "http://{{ hostvars[item].ansible_host }}"
        method: GET
        status_code: 200
      loop: "{{ groups['web'] }}"
      register: website_checks

    - name: Assert websites returned HTTP 200
      ansible.builtin.assert:
        that:
          - item.status == 200
        success_msg: "{{ item.item }} returned HTTP {{ item.status }}"
        fail_msg: "{{ item.item }} returned HTTP {{ item.status }}"
      loop: "{{ website_checks.results }}"
```

---

# Task 6 — Validate the Playbook Syntax

## Goal

Check the playbook for YAML or Ansible syntax errors before running it.

## Evidence

### Screenshot 5 — Successful syntax-check output showing `playbook: site.yml`

![Task 6](<screenshots/week 09-assignment 03-screenshot 5.png>).

---

# Task 7 — Run the Multi-Play Playbook

## Goal

Install Nginx, deploy the website, and verify both servers in one playbook run.

## Evidence

### Screenshot 6 — Play 3 verification showing HTTP `200` for both servers

![Task 7](<screenshots/week 09-assignment 03-screenshot 6.A.png>)
![Task 7](<screenshots/week 09-assignment 03-screenshot 6.B.png>)
![Task 7](<screenshots/week 09-assignment 03-screenshot 6.C.png>)

---

### Screenshot 7 — Final play recap showing `unreachable=0` and `failed=0` for `web1`, `web2`, and `localhost`

![Task 8](<screenshots/week 09-assignment 03-screenshot 7.png>).

---

# Task 8 — Verify Idempotency

## Goal

Run the playbook again and confirm that it does not make unnecessary changes.

## Evidence

### Screenshot 8 — Second playbook run showing the play recap with `changed=0`, `unreachable=0`, and `failed=0` for both web servers

![Task 8](<screenshots/week 09-assignment 03-screenshot 8.png>).

---

# Task 9 — Test Both Websites Manually

## Goal

Confirm that the static website is accessible from both public IP addresses.

## Evidence

### Screenshot 9 — `curl -I` output showing HTTP `200 OK` from both servers

![Task 9.A](<screenshots/week 09-assignment 03-screenshot 9.png>).

---

### Screenshot 10 — Browser showing the website from Server 1 with the public IP and your full name visible

![Task 9.B](<screenshots/week 09-assignment 03-screenshot 10.png>).

---

### Screenshot 11 — Browser showing the website from Server 2 with the public IP and your full name visible

![Task 9.B](<screenshots/week 09-assignment 03-screenshot 11.png>).

---

## Website URLs

Add both deployed website URLs below:

```text
Server 1: http://56.228.23.157
Server 2: http://16.171.170.255
```

---

# Task 10 — Complete the Project README

## Goal

Document how the project works and record what you learned.

## README Content

Copy and paste the complete contents of your `README.md` file below:

```markdown
# Multi-Play Ansible Static Website Deployment

## Project Overview

I deployed a static website to two Ubuntu EC2 instances on AWS using a multi-play Ansible playbook. The playbook installs and configures Nginx, deploys the same website to both servers, and verifies that both servers return HTTP status code 200.

## Environment

- Cloud platform: AWS
- Operating system: Ubuntu
- Number of managed servers: 2
- Web server: Nginx
- Configuration management tool: Ansible

## How to Run the Playbook

ansible-playbook -i inventory.ini site.yml

## Issue Faced and Solution

One issue I encountered was Ansible failing to connect when incorrect host addresses were used in the inventory. I corrected the inventory to use the EC2 public IP addresses and verified SSH connectivity before continuing with the deployment.

## What I Learned

I learned how to structure an Ansible playbook using multiple plays for different responsibilities. I also learned how to install and manage Nginx, copy website files from the Ansible controller to multiple servers, use handlers, verify HTTP responses, and test playbook idempotency.

## Why Installation and Deployment Are Separate

Separating Nginx installation from website deployment makes the automation easier to understand, maintain, test, and reuse. The server configuration can remain unchanged while website content can be updated independently.

## Benefit of the Ansible Copy Module

The Ansible copy module provides a controlled and repeatable way to deploy an approved file from the Ansible controller to managed servers. It also detects whether the destination file has changed, which helps prevent unnecessary file transfers.
```

---

# LinkedIn Post Required

## Evidence

### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_ansible-aws-linux-activity-7504231401513451521-h7sj?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

### Screenshot — Published LinkedIn post

![Task 10](<screenshots/week 09-assignment 03-screenshot 12.png>).

---

# Assignment Questions

Answer the following in your own words:

**1. What issue did you face while completing this assignment, and how did you fix it?**

One issue I faced was Ansible being unable to connect when incorrect host IP addresses were used in my inventory. I corrected inventory.ini to use the current EC2 public IP addresses and verified SSH connectivity before running the playbook again.

---

**2. What did you learn from this assignment?**

I learned how to use a multi-play Ansible playbook to manage multiple servers from one controller. I also learned how to install Nginx, deploy website files, use handlers, verify HTTP responses, and test idempotency.

---

**3. Why is it useful to split installation, deployment, and verification into separate plays?**

Separating the responsibilities makes the playbook easier to understand, troubleshoot, maintain, and reuse. Each play has a specific purpose instead of combining every operation into one section.

---

**4. What is one benefit of using the Ansible `copy` module instead of cloning the website directly from Git on every managed server?**

The copy module allows the controller to distribute the same approved website file consistently to every managed server. Ansible also detects whether the destination file has changed before copying it again.

---

**5. What does idempotency mean in this assignment?**

Idempotency means that running the same playbook repeatedly produces the required state without making unnecessary changes. On the second run, the web servers should normally show changed=0.

---

**6. What does the Ansible `uri` module verify in Play 3?**

The uri module sends HTTP requests from the Ansible controller to both web servers and verifies that each website responds with the expected HTTP status code 200.

---

# Required Files

Confirm that the following files are included in your assignment folder:

- [-] `inventory.ini`
- [-] `site.yml`
- [-] `files/index.html`
- [-] `README.md`

---

# Submission Instructions

- Add all required screenshots in the correct order.
- Full Name must be visible in required screenshots.
- Include both deployed website URLs.
- Paste `inventory.ini`, `site.yml`, and `README.md` as editable text.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, passwords, cloud account IDs, or other sensitive information.

---

# Completion Checklist

- [-] Task 1: `static-web` folder structure is complete
- [-] Task 2: Both servers are listed under the `[web]` group in `inventory.ini`
- [-] Task 2: Inventory graph shows `web1` and `web2`
- [-] Task 3: Ansible ping returns `SUCCESS` and `pong` for both servers
- [-] Task 4: `files/index.html` contains your full name
- [-] Task 5: `site.yml` contains three separate plays
- [-] Task 5: Play 1 installs, starts, and enables Nginx
- [-] Task 5: Play 2 deploys `index.html` using the `copy` module
- [-] Task 5: Nginx reload handler is included
- [-] Task 5: Play 3 verifies both web servers from the controller
- [-] Task 6: Playbook syntax check passes
- [-] Task 7: First playbook run completes with `unreachable=0` and `failed=0`
- [-] Task 7: URI verification returns HTTP `200` for both servers
- [-] Task 8: Second playbook run demonstrates idempotency
- [-] Task 8: Second run shows `changed=0` for both web servers
- [-] Task 9: Both `curl -I` commands return HTTP `200 OK`
- [-] Task 9: Website loads from Server 1
- [-] Task 9: Website loads from Server 2
- [-] Task 9: Full name is visible on both deployed websites
- [-] Task 10: `README.md` contains all required explanations
- [-] Screenshots 1–11 are included
- [-] `inventory.ini`, `site.yml`, and `README.md` are pasted as editable text
- [-] Both website URLs are included
- [-] Assignment questions are answered
- [-] LinkedIn post published
- [-] LinkedIn post URL added
- [-] No sensitive information is exposed

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
