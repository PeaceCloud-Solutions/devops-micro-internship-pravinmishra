# Assignment — Deploy EpicBook with Terraform and Ansible Roles

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application using Terraform and Ansible roles.

Terraform provisions the cloud infrastructure, including one Ubuntu VM and one managed MySQL database. Ansible roles configure the VM, install required software, deploy the EpicBook application, configure Nginx, connect the app to the managed MySQL database, and verify the deployment.

---

# Task 1 — Set Up the Project Folder Layout

## Goal

Create the project folder structure for Terraform and Ansible roles.

Terraform will be used to provision the cloud infrastructure. Ansible roles will be used to configure the VM and deploy the EpicBook application.

### Evidence

#### Screenshot 1 — Terminal showing the completed `epicbook-prod` project structure

![Task 1](<screenshots/week 09-assignment 05-screenshot 1.png>).

---

### Notes

Answer the following in your own words:

**1. Which cloud provider did you choose for this assignment?**

I chose Microsoft Azure for this assignment. Terraform will provision the Azure infrastructure, including an Ubuntu VM and Azure Database for MySQL Flexible Server.

---

**2. Why is it useful to keep Terraform files and Ansible files in separate folders?**

Keeping Terraform and Ansible files in separate folders provides a clear separation of responsibilities. Terraform manages infrastructure provisioning, while Ansible manages server configuration and application deployment.

---

**3. What is the purpose of the `roles` directory in Ansible?**

The roles directory organizes Ansible automation into reusable components with specific responsibilities. In this deployment, the common, nginx, and epicbook roles handle different parts of the server and application configuration.

---

# Task 2 — Provision the Infrastructure with Terraform

## Goal

Run Terraform to provision the cloud infrastructure for the EpicBook deployment.

Terraform will create the VM, managed MySQL database, networking, security rules, and required outputs.

### Evidence

#### Screenshot 2 — `terraform apply` completed successfully

![Task 2.A](<screenshots/week 09-assignment 05-screenshot 2.png>).

---

#### Screenshot 3 — Output of `terraform output`

![Task 2.B](<screenshots/week 09-assignment 05-screenshot 3.png>).

---

#### Screenshot 4 — Azure Portal or AWS Console showing the VM running

![Task 2.C](<screenshots/week 09-assignment 05-screenshot 4.png>).

---

#### Screenshot 5 — Azure Portal or AWS Console showing the managed MySQL database created

![Task 2.D](<screenshots/week 09-assignment 05-screenshot 5.png>).

---

### Notes

Answer the following in your own words:

**1. What resources did Terraform create for this assignment?**

Terraform created the Azure networking resources, security rules, public IP, network interface, Ubuntu virtual machine, and Azure Database for MySQL Flexible Server required for the EpicBook deployment.

---

**2. Why should you review `terraform plan` before running `terraform apply`?**

I review terraform plan before applying because it shows the resources Terraform intends to create, modify, or destroy. This allows me to identify unexpected changes before they affect the cloud environment.

---

**3. Why should database passwords not be shown in Terraform output?**

Database passwords should not be displayed in Terraform output because terminal output may be captured in screenshots, logs, or command history and could expose sensitive credentials.

---

# Task 3 — Verify SSH Key-Based Access

## Goal

Verify that the cloud VM can be accessed from the Ansible controller using SSH key-based authentication.

### Evidence

#### Screenshot 6 — Successful SSH hostname check from the Ansible controller

![Task 3](<screenshots/week 09-assignment 05-screenshot 6.png>).

---

### Notes

Answer the following in your own words:

**1. What command did you use to verify SSH access?**

I used ssh azureuser@20.225.251.68 "hostname" from my Ansible controller.

---

**2. What proves that SSH key-based access worked successfully?**

The VM returned its hostname successfully without requesting the remote user's password, confirming that SSH key-based authentication worked..

---

**3. What would you check if SSH returned `Permission denied (publickey)`?**

I would verify the SSH username, private key, corresponding public key installed on the VM, SSH agent, file permissions, VM public IP, and the NSG rule allowing port 22 from my controller's public IP.

---

# Task 4 — Create the Ansible Inventory and Configuration

## Goal

Create the Ansible inventory file and local Ansible configuration for the EpicBook VM.

The inventory tells Ansible which VM to manage and which SSH user to use.

### Evidence

#### Screenshot 7 — `inventory.ini` showing the VM under the `web` group

![Task 4.A](<screenshots/week 09-assignment 05-screenshot 7.png>).

---

#### Screenshot 8 — Output of `ansible-inventory -i inventory.ini --graph`

![Task 4.B](<screenshots/week 09-assignment 05-screenshot 8.png>).

---

#### Screenshot 9 — Output of `ansible web -i inventory.ini -m ping`

![Task 4.C](<screenshots/week 09-assignment 05-screenshot 9.png>).

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `inventory.ini`?**

It defines the managed hosts that Ansible connects to and provides the connection information required to manage them.

---

**2. What does `ansible_host` store?**

ansible_host stores the IP address or hostname Ansible uses to connect to the managed server.

---

**3. What does `ansible_ssh_private_key_file` tell Ansible?**

It tells Ansible which SSH private key file to use when authenticating to the VM.

---

**4. Why is `host_key_checking = False` used only for this temporary lab?**

It prevents first-time SSH fingerprint prompts from interrupting this temporary lab. In production, host-key checking should remain enabled so the identity of remote servers can be verified.

---

# Task 5 — Create the Main Ansible Playbook

## Goal

Create the main Ansible playbook that runs the required roles in the correct order.

The `site.yml` file will call the `common`, `nginx`, and `epicbook` roles.

### Evidence

#### Screenshot 10 — `site.yml` showing the roles in the correct order

![Task 5.A](<screenshots/week 09-assignment 05-screenshot 10.png>).

---

#### Screenshot 11 — Output of `ansible-playbook -i inventory.ini site.yml --syntax-check`

![Task 5.B](<screenshots/week 09-assignment 05-screenshot 11.png>).

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `site.yml`?**

site.yml is the main Ansible playbook that targets the EpicBook VM and executes the required roles.

---

**2. Why should the roles run in the order `common`, `nginx`, and `epicbook`?**

The common role first prepares the operating system, the nginx role configures the web proxy, and the epicbook role then deploys and starts the application.

---

**3. What does `become: true` allow Ansible to do?**

become: true allows Ansible tasks to execute with elevated privileges when administrative access is required.

---

# Task 6 — Create the `common` Role

## Goal

Create the `common` role to prepare the Ubuntu VM with the basic packages required for the EpicBook deployment.

This role handles the common server setup before Nginx and the application are configured.

### Evidence

#### Screenshot 12 — `roles/common/tasks/main.yml` showing the common setup tasks

![Task 6](<screenshots/week 09-assignment 05-screenshot 12.png>).

---

### Notes

Answer the following in your own words:

**1. What is the responsibility of the `common` role?**

The common role prepares the Ubuntu server for the EpicBook deployment by updating the package cache and installing shared prerequisite packages such as Git, Curl, Unzip, software-properties-common, and the MySQL client. These packages provide the basic tools required by the other roles during application deployment and configuration.

---

**2. Why should Nginx installation not be placed inside the `common` role?**

Nginx should not be installed in the common role because the common role is intended only for general packages and configuration that may be shared by different server roles. Nginx has a specific responsibility as the web server and reverse proxy, so placing it in a separate nginx role keeps the Ansible configuration modular, easier to maintain, and reusable.

---

**3. Why is `mysql-client` useful in this deployment?**

The mysql-client package provides command-line tools that allow the application server to connect to and communicate with the managed MySQL database. It is also useful for testing database connectivity and performing database administration or troubleshooting from the VM.

---

# Task 7 — Create the `nginx` Role

## Goal

Create the `nginx` role to install Nginx and configure it as a reverse proxy for the EpicBook application.

Nginx will receive browser traffic on port `80` and forward it to the EpicBook Node.js application running on the VM.

### Evidence

#### Screenshot 13 — `roles/nginx/tasks/main.yml` showing Nginx installation and site configuration tasks

![Task 7.A](<screenshots/week 09-assignment 05-screenshot 13.png>).

---

#### Screenshot 14 — `roles/nginx/templates/epicbook.conf.j2` showing the reverse proxy configuration

![Task 7.B](<screenshots/week 09-assignment 05-screenshot 14.png>).

---

### Notes

Answer the following in your own words:

**1. What is the responsibility of the `nginx` role?**

The nginx role is responsible for installing Nginx, creating the EpicBook site configuration, enabling the site, disabling the default Nginx configuration, and starting the Nginx service. It provides the public-facing web entry point for the EpicBook application.

---

**2. Why is Nginx configured as a reverse proxy in this deployment?**

Nginx is configured as a reverse proxy so that users can access EpicBook through the standard HTTP port 80 while the Node.js application runs internally on port 8080. Nginx receives incoming browser requests and forwards them to the EpicBook application without requiring users to connect directly to port 8080.

---

**3. Why should the application port come from `group_vars/web.yml` instead of being hard-coded?**

Keeping the application port in group_vars/web.yml separates configuration values from the role logic. This makes the role easier to reuse and maintain because the application port can be changed in one location without editing the Nginx template or other role files..

---

# Task 8 — Create the `epicbook` Role

## Goal

Create the `epicbook` role to deploy the EpicBook application, connect it to the managed MySQL database, and run the application on port `8080` using PM2.

### Evidence

#### Screenshot 15 — `roles/epicbook/tasks/main.yml` showing application deployment tasks

![Task 8.A](<screenshots/week 09-assignment 05-screenshot 15.png>).

---

#### Screenshot 16 — Task or file showing how the database connection is configured, with secrets hidden

![Task 8.B](<screenshots/week 09-assignment 05-screenshot 16.png>).

---

#### Screenshot 17 — Task or output showing the EpicBook application managed by PM2

![Task 8.C](<screenshots/week 09-assignment 05-screenshot 17.A.png>)
![Task 8.C](<screenshots/week 09-assignment 05-screenshot 17.B.png>).

---

### Notes

Answer the following in your own words:

**1. What is the responsibility of the `epicbook` role?**

The epicbook role is responsible for deploying and configuring the EpicBook Node.js application. It installs the required application runtime, clones the EpicBook source code, installs application dependencies, configures the MySQL database connection, and uses PM2 to run and manage the application on port 8080.

---

**2. Why is PM2 used for the EpicBook Node.js application?**

PM2 is used as a process manager for the Node.js application. It allows EpicBook to run as a managed background process instead of depending on an open terminal session. PM2 also provides process monitoring and makes it easier to restart and manage the application.

---

**3. Why should database passwords not be hard-coded in public files?**

Database passwords should not be hard-coded in public files because anyone with access to the repository could obtain the credentials and potentially gain unauthorized access to the database. Keeping secrets outside source-controlled files reduces the risk of credential exposure and improves the security of the deployment.

---

**4. What does it mean for the application to run on port `8080` while Nginx listens on port `80`?**

It means that Nginx is the public-facing service that accepts HTTP requests on port 80, while the EpicBook Node.js application runs internally on port 8080. Nginx forwards incoming requests to the application through the reverse-proxy configuration, so users do not need to access port 8080 directly.

---

# Task 9 — Create Group Variables

## Goal

Create reusable variables for the EpicBook deployment.

The `group_vars/web.yml` file stores values that can be reused across the Ansible roles.

### Evidence

#### Screenshot 18 — `group_vars/web.yml` showing the application, PM2, and database variables, with passwords hidden or masked

![Task 9](<screenshots/week 09-assignment 01-screenshot 18.png>).

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `group_vars/web.yml`?**

group_vars/web.yml provides a central location for variables that are shared by the web hosts and reused across different Ansible roles. This makes the playbook easier to maintain because values such as the application path, port, database host, and PM2 application name do not need to be repeated in multiple role files.

---

**2. Which values did you store in `group_vars/web.yml`?**

I stored reusable application and database configuration values, including the EpicBook Git repository, application directory, application user, application port, PM2 application name, Nginx server name, MySQL hostname, database name, and database username.

---

**3. How did you handle the database password securely?**

I did not hard-code the database password in group_vars/web.yml. Instead, I used the EPICBOOK_DB_PASSWORD environment variable and referenced it from Ansible using an environment lookup. This prevents the actual password from being committed to GitHub.

---

# Task 10 — Run the Ansible Playbook

## Goal

Run the Ansible playbook to configure the VM and deploy the EpicBook application.

The playbook should run the roles in this order:

1. `common`
2. `nginx`
3. `epicbook`

### Evidence

#### Screenshot 19 — Ansible playbook output showing the roles running

![Task 10.A](<screenshots/week 09-assignment 05-screenshot 19.png>).

---

#### Screenshot 20 — Final Ansible recap showing `failed=0`

![Task 10.B](<screenshots/week 09-assignment 05-screenshot 20.png>).

---

#### Screenshot 21 — Output of `ansible web -i inventory.ini -m command -a "systemctl is-active nginx" --become`

![Task 10.C](<screenshots/week 09-assignment 05-screenshot 21.png>).

---

#### Screenshot 22 — Output of `ansible web -i inventory.ini -m command -a "pm2 status"`

![Task 10.D](<screenshots/week 09-assignment 05-screenshot 22.png>).

---

#### Screenshot 23 — Output of `ansible web -i inventory.ini -m command -a "curl -I http://localhost:8080"`

![Task 10.E](<screenshots/week 09-assignment 05-screenshot 23.png>).

---

### Notes

Answer the following in your own words:

**1. What command did you run to execute the Ansible playbook?**

I executed the deployment using:ansible-playbook -i inventory.ini site.yml
This applied the common, nginx, and epicbook roles to the VM defined in my inventory.


---

**2. How do you know all roles completed successfully?**

I confirmed this from the final Ansible PLAY RECAP. The deployment was successful when the target host showed unreachable=0 and failed=0, meaning Ansible completed the required tasks without failures.

---

**3. What proves that Nginx is active?**

I verified Nginx using:ansible web -i inventory.ini -m command -a "systemctl is-active nginx" --become
The command returned active, confirming that the Nginx service was running.

---

**4. What proves that PM2 is managing the EpicBook application?**

I verified this by running pm2 status on the EpicBook VM. PM2 displayed the epicbook process with an online status, a valid process ID, and an active uptime. This confirmed that PM2 was successfully running and managing the EpicBook Node.js application.

---

**5. What proves that the EpicBook application responds on port `8080`?**

I verified the application directly using curl -I http://localhost:8080 through Ansible. The command returned a successful HTTP response, confirming that the EpicBook application was running, listening, and responding to requests on port 8080.

---

# Task 11 — Verify the EpicBook Deployment

## Goal

Verify that the EpicBook application is running, accessible in the browser, and connected to the managed MySQL database.

### Evidence

#### Screenshot 24 — Output of `curl -I http://<public_ip>`

![Task 11.A](<screenshots/week 09-assignment 05-screenshot 24.png>).

---

#### Screenshot 25 — Output of the cart API test command

![Task 11.B](<screenshots/week 09-assignment 05-screenshot 25.png>).

---

#### Screenshot 26 — Output of the `/cart` HTTP status check

![Task 11.C](<screenshots/week 09-assignment 05-screenshot 26.png>).

---

#### Screenshot 27 — Browser showing the EpicBook application loaded from `http://<public_ip>`

![Task 11.D](<screenshots/week 09-assignment 05-screenshot 27.png>).

---

### Notes

Answer the following in your own words:

**1. What HTTP response did you receive from the public application URL?**

I received a successful HTTP response from the public IP address, confirming that Nginx was accepting HTTP traffic and forwarding requests to the EpicBook application.

---

**2. What did the cart API test prove?**

The cart API test proved that the EpicBook backend API was functioning and able to process a cart request. It also helped verify that the application could interact with the database-backed functionality required by the application.

---

**3. What did the `/cart` status check return?**

The /cart status check returned HTTP status code 200, confirming that the cart route was available and responding successfully.

---

**4. What issue did you face during verification, and how did you fix it?**

During verification, the EpicBook application initially failed to remain online in PM2, which also meant that nothing was listening on port 8080. I worked through the problem by checking the PM2 logs and testing the database connection. I discovered several database configuration issues, including private database connectivity, the requirement for a secure TLS connection, and eventually an Unknown database 'epicbook' error. I corrected the MySQL networking and application database configuration, ensured the connection used SSL, and created the required EpicBook database. I then restarted the application with PM2 and repeated the verification tests.

---

# LinkedIn Post Required

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-devops-terraform-activity-7504587729830342656-n_mR?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

#### Screenshot — Published LinkedIn post

![Task 11.E](<screenshots/week 09-assignment 05-screenshot 28.png>).

---

# Assignment Questions

Answer the following in your own words:

**1. Why is Terraform used for infrastructure provisioning?**

Terraform is used to define and provision infrastructure as code. Instead of manually creating cloud resources through the Azure Portal, the infrastructure can be described in configuration files and deployed consistently. This makes the infrastructure repeatable, easier to maintain, and easier to track through version control.

---

**2. Why are Ansible roles useful for production-style deployments?**

Ansible roles separate configuration tasks into reusable components with specific responsibilities. In this deployment, I used separate common, nginx, and epicbook roles. This made the configuration more organized, reusable, and easier to troubleshoot than placing every task inside one large playbook.

---

**3. What is the purpose of `group_vars/web.yml`?**

The group_vars/web.yml file provides centralized variables for hosts in the web group. It allows values such as the application repository, installation directory, application port, PM2 name, and database configuration to be reused by different Ansible roles without duplicating them.

---

**4. Why should database passwords not be committed to GitHub?**

Database passwords should not be committed to GitHub because Git repositories preserve file history and could expose credentials to unauthorized users. In this deployment, I kept the password outside the repository and supplied it through an environment variable instead.

---

**5. What is the purpose of Nginx in this deployment?**

Nginx acts as the public-facing web server and reverse proxy. It receives HTTP requests on port 80 and forwards the requests to the EpicBook Node.js application running internally on port 8080.

---

**6. Why should the managed MySQL database not be publicly accessible?**

The MySQL database should not be publicly accessible because exposing port 3306 to the Internet increases the attack surface. The application VM should communicate with the database through private networking so that database traffic remains within authorized network paths.

---

**7. Why is PM2 used for the EpicBook Node.js application?**

PM2 is used as a process manager for the Node.js application. It allows the EpicBook process to run in the background and provides commands for monitoring, restarting, and managing the application's running state.

---

**8. What does idempotency mean in Ansible?**

Idempotency means that an Ansible playbook can be executed repeatedly without unnecessarily changing resources that are already in the required state. Ansible checks the current configuration and only makes changes where they are needed.

---

**9. What issue did you face during the deployment, and how did you fix it?**

One major issue I faced was getting the EpicBook application to communicate successfully with Azure Database for MySQL. The application initially failed because of database connectivity and configuration problems. I used DNS resolution tests, port 3306 connectivity tests, PM2 logs, and Sequelize error messages to troubleshoot the problem. I configured private networking for the MySQL Flexible Server, enabled the required SSL connection in the application configuration, corrected the production database settings, and addressed the missing EpicBook database. This troubleshooting helped me isolate each problem instead of making unrelated infrastructure changes.

---

**10. What security improvement would you make before using this setup in production?**

Before using this deployment in production, I would store database credentials in a dedicated secrets-management service instead of environment variables, configure strict TLS certificate verification, enable HTTPS for the public application, restrict network access further, and use secure SSH host-key verification. These improvements would strengthen the security of both the application and its infrastructure.

---

# Required Files

Confirm that the following files are included in your GitHub repository or assignment folder:

- [-] `README.md`
- [-] Terraform files under either `terraform/azure/` or `terraform/aws/`
- [-] `ansible/ansible.cfg`
- [-] `ansible/inventory.ini`
- [-] `ansible/site.yml`
- [-] `ansible/group_vars/web.yml`
- [-] `ansible/roles/common/tasks/main.yml`
- [-] `ansible/roles/nginx/tasks/main.yml`
- [-] `ansible/roles/nginx/templates/epicbook.conf.j2`
- [-] `ansible/roles/epicbook/tasks/main.yml`

---

# Submission Instructions

- Add all required screenshots in your submission.
- Full Name must be visible in required screenshots.
- Mention the cloud provider used: Azure or AWS.
- Add the VM public IP address.
- Add the final application URL.
- Add Terraform output proof.
- Add Ansible role tree proof.
- Add all required notes and assignment question answers.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, passwords, cloud credentials, database credentials, Terraform state files, subscription IDs, or account IDs.
- Submit only your Google Doc link.

---

# Completion Checklist

- [-] Task 1: Project folder layout created
- [-] Task 2: Terraform infrastructure provisioned
- [-] Task 3: SSH key-based access verified
- [-] Task 4: Ansible inventory and configuration created
- [-] Task 5: Main Ansible playbook created
- [-] Task 6: `common` role created
- [-] Task 7: `nginx` role created
- [-] Task 8: `epicbook` role created
- [-] Task 9: Group variables created
- [-] Task 10: Ansible playbook run completed
- [-] Task 11: EpicBook deployment verified
- [-] Terraform files created under only one cloud provider folder
- [-] One Ubuntu VM was created
- [-] One managed MySQL database was created
- [-] SSH port `22` is restricted to the controller public IP
- [-] HTTP port `80` is accessible
- [-] MySQL port `3306` is not publicly open
- [-] `ansible web -i inventory.ini -m ping` returns `SUCCESS`
- [-] `site.yml` calls the roles in the correct order
- [-] Database secrets are hidden or handled securely
- [-] Nginx is active
- [-] PM2 shows the EpicBook application running
- [-] EpicBook responds on port `8080`
- [-] Public URL loads in the browser
- [-] Cart API verification works
- [-] Playbook completes with `failed=0`
- [-] Screenshots 1–27 are included
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