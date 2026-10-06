# Assignment 7 — Capstone: Deploy a Production-Grade Stack for The EpicBook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook application as a production-oriented Docker Compose stack on a cloud VM. You will use optimized container images, isolated networks, health checks, persistent MySQL storage, a selected reverse proxy, logging, backup and restore testing, and reliability procedures.

---

# Task 0 — App Discovery and Architecture

## Goal

Review the EpicBook repository and design the intended application architecture.

### Evidence

#### Screenshot 1 — EpicBook Project Structure

Add a terminal screenshot showing the EpicBook project structure after cloning the repository.

![Task 0](<screenshots/week 11-assignment 07-screenshot 1.png>).

---

#### Screenshot 2 — Architecture Diagram

Add a screenshot of your architecture diagram showing:

- Public user
- Reverse proxy
- Frontend
- Backend
- Database
- Docker networks
- Public and private ports
- Persistent database storage

Add your full name inside the diagram or as a clear caption below it.

![Task 0.B](<screenshots/week 11-assignment 07-screenshot 2.png>).

---

#### Screenshot 3 — Environment Variables and Ports Document

Add a screenshot showing the contents of:

```text
docs/02-env-and-ports.md
```

It must document environment-variable names, internal ports, persistent-data details, and the health-check method. Do not expose real credentials or values.

![Task 0.C](<screenshots/week 11-assignment 07-screenshot 3.png>).

---

# Task 1 — Create Production Docker Images

## Goal

Create optimized production images for the EpicBook backend and frontend.

### Evidence

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing `backend/Dockerfile`, including:

- Dependency stage
- Minimal runtime stage
- Production startup command
- Internal backend port
- Non-root user configuration

![Task 1.A](<screenshots/week 11-assignment 07-screenshot 4.png>).

---

#### Screenshot 5 — Frontend Dockerfile

Add a screenshot showing `frontend/Dockerfile`, including:

- Nginx runtime image
- Static frontend files copied to the Nginx web root

![Task 1.B](<screenshots/week 11-assignment 07-screenshot 5.png>).

---

#### Screenshot 6 — Docker Ignore Files

Add a screenshot showing both:

```text
backend/.dockerignore
frontend/.dockerignore
```

![Task 1.C](<screenshots/week 11-assignment 07-screenshot 6.png>).

---

#### Screenshot 7 — Docker Image Builds and Size Comparison

Add a terminal screenshot showing successful builds of:

- Baseline backend image
- Optimized backend image
- Frontend image

The screenshot must also show the baseline and optimized backend image-size comparison.

![Task 1.D](<screenshots/week 11-assignment 07-screenshot 7.png>).

---

#### Screenshot 8 — Backend Running as Non-Root User

Add a terminal screenshot showing the optimized backend container running as a non-root user.

![Task 1.E](<screenshots/week 11-assignment 07-screenshot 8.png>).

---

### Notes

Write a short note covering:

- Baseline and optimized backend image sizes
- The image-size reduction achieved
- One Docker layer-caching optimization used
- The security benefit of running the backend as a non-root user

The baseline EpicBook backend image was [397.85 MB], while the optimized multi-stage image was [50.85 MB], representing a [87.21%] reduction. Dependency files are copied before the application source so Docker can reuse the dependency installation layer when application code changes but package.json does not. The final runtime image contains only production dependencies and the files required to run the application. The backend also runs as the non-root node user, reducing the privileges available to the application if the container is compromised.

---

# Task 2 — Create the Docker Compose Stack and Networks

## Goal

Create one Docker Compose stack containing the reverse proxy, frontend, backend, and MySQL database.

### Evidence

#### Screenshot 9 — Docker Compose Services

Add a screenshot showing `docker-compose.yml` with all four services:

```text
reverse-proxy
frontend
backend
database
```

![Task 2.A](<screenshots/week 11-assignment 07-screenshot 9.png>).

---

#### Screenshot 10 — Networks and Named Volume

Add a screenshot showing:

- `front-tier` network
- `back-tier` network
- `db_data` named volume

![Task 2.B](<screenshots/week 11-assignment 07-screenshot 10.png>).

---

#### Screenshot 11 — Docker Compose Validation

Add a terminal screenshot showing successful Docker Compose validation without exposing environment-variable values or secrets.

![Task 2.C](<screenshots/week 11-assignment 07-screenshot 11.png>).

---

# Task 3 — Configure Health Checks and Startup Dependencies

## Goal

Configure health checks and ensure services start only after their dependencies are healthy.

### Evidence

#### Screenshot 12 — Backend Health Endpoint

Add a screenshot showing the backend application configuration for the `/health` endpoint.

![Task 3.A](<screenshots/week 11-assignment 07-screenshot 12.png>).

---

#### Screenshot 13 — MySQL and Backend Health Checks

Add a screenshot showing `docker-compose.yml` with health checks for MySQL and the backend.

![Task 3.B](<screenshots/week 11-assignment 07-screenshot 13.png>).

---

#### Screenshot 14 — Frontend and Reverse-Proxy Health Checks

Add a screenshot showing:

- Frontend health check
- Reverse-proxy health check
- `depends_on` conditions using `service_healthy`

![Task 3.C](<screenshots/week 11-assignment 07-screenshot 14.png>).

---

#### Screenshot 15 — Running Healthy Services

Add a terminal screenshot showing Docker Compose service status. The database, backend, frontend, and reverse proxy must be running successfully.

![Task 3.D](<screenshots/week 11-assignment 07-screenshot 15.png>).

---

#### Screenshot 16 — Public Health Endpoint

Add a terminal screenshot showing a successful response from the public application health endpoint through the reverse proxy.

![Task 3.E](<screenshots/week 11-assignment 07-screenshot 16.png>).

---

#### Screenshot 17 — Health-Check and Startup-Order Document

Add a screenshot showing the contents of:

```text
docs/03-healthchecks-and-depends-on.md
```

Explain the health-check method for each service and the startup dependency order.

![Task 3.F](<screenshots/week 11-assignment 07-screenshot 17.png>).

---

# Task 4 — Configure the Reverse Proxy and Same-Origin Routing

## Goal

Use either Nginx or Traefik as the only public entry point for the EpicBook application.

### Evidence

#### Screenshot 18 — Selected Reverse-Proxy Configuration

Add a screenshot showing the configuration for your selected reverse proxy.

It must show routes for:

- Static frontend assets
- Application pages
- API requests
- Health endpoint

![Task 4.A](<screenshots/week 11-assignment 07-screenshot 18.png>).

---

#### Screenshot 19 — Only Reverse Proxy Publishes Port 80

Add a screenshot of `docker-compose.yml` showing that only the `reverse-proxy` service publishes port 80.

![Task 4.B](<screenshots/week 11-assignment 07-screenshot 19.png>).

---

#### Screenshot 20 — Reverse-Proxy Route Testing

Add a terminal screenshot showing successful requests through the selected reverse proxy to:

- Application page
- One API endpoint
- One static asset
- Health endpoint

![Task 4.C](<screenshots/week 11-assignment 07-screenshot 20.png>).

---

#### Screenshot 21 — EpicBook Application Through Public IP

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Task 4.D](<screenshots/week 11-assignment 07-screenshot 21.png>).

---

#### Screenshot 22 — Proxy Routing and CORS Document

Add a screenshot showing the contents of:

```text
docs/04-proxy-routing-and-cors.md
```

Explain the proxy routes and state whether CORS was required and why.

![Task 4.E](<screenshots/week 11-assignment 07-screenshot 22.A.png>)
![Task 4.E](<screenshots/week 11-assignment 07-screenshot 22.B.png>).

---

# Task 5 — Prove Data Persistence, Backup, and Restore

## Goal

Verify MySQL persistence and perform a controlled backup and restore drill.

### Evidence

#### Screenshot 23 — MySQL Volume Configuration

Add a terminal screenshot showing the `db_data` named volume and its MySQL mount configuration.

![Task 5.A](<screenshots/week 11-assignment 07-screenshot 23.png>).

---

#### Screenshot 24 — Test Data Before Backup

Add a terminal screenshot showing the selected test data before the backup and restore drill.

![Task 5.B](<screenshots/week 11-assignment 07-screenshot 24.png>).

---

#### Screenshot 25 — Successful Backup Creation

Add a terminal screenshot showing successful backup creation and the backup file stored in the host backup directory.

![Task 5.C](<screenshots/week 11-assignment 07-screenshot 25.png>).

---

#### Screenshot 26 — Controlled Data-Loss Test

Add a terminal screenshot showing that the selected test record was removed during the controlled data-loss test.

![Task 5.D](<screenshots/week 11-assignment 07-screenshot 26.png>).

---

#### Screenshot 27 — Restore Verification

Add a terminal screenshot showing successful restore and verification that the deleted test record is available again.

![Task 5.E](<screenshots/week 11-assignment 07-screenshot 27.png>).

---

#### Screenshot 28 — Persistence After Down/Up Cycle

Add a terminal screenshot showing that database data remains available after a non-destructive Docker Compose down/up cycle.

Do not use `docker compose down -v`.

![Task 5.F](<screenshots/week 11-assignment 07-screenshot 28.png>).

---

#### Screenshot 29 — Persistence and Backup Document

Add a screenshot showing the contents of:

```text
docs/05-persistence-and-backup.md
```

Include the backup plan and restore procedure.

![Task 5.G](<screenshots/week 11-assignment 07-screenshot 29.A.png>)
![Task 5.G](<screenshots/week 11-assignment 07-screenshot 29.B.png>).

---

# Task 6 — Configure Logging and Observability

## Goal

Configure useful reverse-proxy and backend logs without exposing sensitive information.

### Evidence

#### Screenshot 30 — Logging Configuration

Add a screenshot showing:

- Configuration for the selected reverse proxy
- Proxy log format
- Docker Compose host log-directory bind mount

![Task 6.A](<screenshots/week 11-assignment 07-screenshot 30.png>).

---

#### Screenshot 31 — Persistent Proxy Logs and Backend Logs

Add a terminal screenshot showing:

- Selected reverse-proxy logs available from the host directory after a proxy restart
- Backend logs displayed through Docker Compose

![Task 6.B](<screenshots/week 11-assignment 07-screenshot 31.png>).

---

### Notes

Write a short note covering:

- The selected reverse proxy
- Host path used for reverse-proxy logs
- How backend logs are viewed
- Whether JSON or standard text logs were used
- Why passwords, tokens, headers, and database connection strings must not appear in logs

For this deployment, I used **Nginx as the reverse proxy**. The reverse proxy handles incoming HTTP traffic and routes requests to the appropriate frontend and backend services.

Reverse-proxy logs are configured so that they can be made available through a host log directory, allowing logs to remain accessible outside the container and making troubleshooting easier after a proxy restart. Nginx access and error logs provide information about incoming requests and proxy-related errors.

Backend application logs are viewed using **Docker Compose**, for example with `docker compose logs backend`. This allows backend activity and errors to be inspected without exposing the backend directly to the public network.

I used standard Nginx access/error logging together with Docker container logging. Where Docker's `json-file` logging driver is used, log rotation is configured to prevent container log files from growing indefinitely.

Sensitive information must never be written to logs. Passwords, authentication tokens, authorization headers, database connection strings, and other secrets could give an unauthorized person access to the application or its infrastructure if the logs were exposed. Logs should therefore contain enough information for troubleshooting without recording credentials or other sensitive values.


---

# Task 7 — Deploy and Verify the Stack on a Cloud VM

## Goal

Deploy the completed Docker Compose stack on an AWS or Azure VM and verify public access.

### Evidence

#### Screenshot 32 — VM Public IP and Inbound Rules

Add a cloud-console screenshot showing:

- VM public IP address
- SSH port 22 restricted to your IP address
- HTTP port 80 allowed from Anywhere

![Task 7.A](<screenshots/week 11-assignment 07-screenshot 32.png>).

---

#### Screenshot 33 — Cloud VM Stack Verification

Add a VM terminal screenshot showing:

- Docker Compose service status
- Successful public health or API response
- No published database, frontend, or backend ports

![Task 7.B](<screenshots/week 11-assignment 07-screenshot 33.png>).

---

#### Screenshot 34 — EpicBook Application on Cloud VM

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Task 7.C](<screenshots/week 11-assignment 07-screenshot 34.A.png>).

---

### Notes

Write a short note covering:

- Cloud provider used
- VM operating system
- Public port exposed
- Security rules configured
- Confirmation that the application and backend API worked through the reverse proxy

I deployed the completed EpicBook Docker Compose stack on an AWS EC2 Ubuntu VM.

The public-facing service is the **Nginx reverse proxy on port 80**. The frontend, backend, and MySQL database are not directly published to the internet. Requests enter through the reverse proxy and are routed internally to the appropriate service using the Docker networks.

The AWS Security Group allows **HTTP traffic on port 80 from Anywhere** so that the EpicBook application can be accessed through the VM's public IP address. **SSH on port 22 is restricted to my IP address** to reduce unnecessary administrative exposure.

After deployment, I verified the Docker Compose service status and confirmed that the containers were running and healthy. I also tested the application through the VM's public IP address. The frontend loaded successfully, and backend/API requests worked through the Nginx reverse proxy. The database remained accessible only through the internal Docker network and was not exposed through a public host port.


---

# Task 8 — Automate Deployment with CI/CD (Optional)

## Goal

Optionally automate image build, image push, and deployment through GitHub Actions or Azure Pipelines.

### Optional Evidence

#### Optional Screenshot — Successful CI/CD Pipeline Run

Add a screenshot showing a successful pipeline run with build, image push, deployment, and verification stages.

![Task 7.D](<screenshots/week 11-assignment 07-screenshot 34.B.png>).

---

### Optional Notes

Write a short note covering:

- CI/CD platform used
- Image-tagging method
- Registry used
- Deployment trigger
- Manual approval or secret-handling approach

CI/CD automation was not implemented as part of this assignment. The optional task was left for future improvement. A future implementation could use GitHub Actions or Azure Pipelines to build and tag the application images, push them to a container registry, deploy the updated Docker Compose stack to the cloud VM, and perform post-deployment health checks. Deployment credentials and registry secrets would be stored using the CI/CD platform's secure secret-management mechanism rather than committed to the repository.


---

# Task 9 — Perform Reliability Tests and Create an Operations Runbook

## Goal

Test controlled service failures and document safe operating procedures.

### Evidence

#### Screenshot 35 — Backend Failure and Recovery

Add a terminal screenshot showing:

- Backend failure test
- Expected unavailable response through the reverse proxy
- Backend restart
- Successful health-check recovery

![Task 9.A](<screenshots/week 11-assignment 07-screenshot 35.png>).

---

#### Screenshot 36 — Database Failure and Recovery

Add a terminal screenshot showing:

- Database outage test
- Failed database-dependent request
- Database restart
- Successful application recovery

![Task 9.B](<screenshots/week 11-assignment 07-screenshot 36.png>).

---

### Notes

Write a short operations runbook covering:

- Safe restart procedure for reverse proxy, frontend, backend, and database
- Backup and restore procedure
- Secret-rotation approach
- Database recovery procedure
- What to check when the application returns an error
- Results of backend and database reliability tests

## Safe Restart Procedure

The EpicBook stack consists of the reverse proxy, frontend, backend, and database services. Service status should first be checked with `docker compose ps`.

Individual services can be restarted with `docker compose restart <service>`. When restarting the complete stack, `docker compose down` followed by `docker compose up -d` can be used. The `-v` option must not be added to `docker compose down` during a normal restart because it can remove the persistent database volume.

After a restart, `docker compose ps` should be used to confirm that the services have returned to a running and healthy state.

## Backup and Restore Procedure

Before destructive database operations, a MySQL backup should be created using `mysqldump`. For this assignment, the backup was stored as `backups/epicbook-before-delete.sql`.

A restore can be performed by passing the SQL backup into the MySQL container. After restoration, the database should be queried to confirm that the expected records have been recovered.

I tested this process by creating a `BACKUP_RESTORE_TEST` record, backing up the database, deleting the record, restoring the backup, and confirming that the record returned successfully.

## Secret Rotation

Application and database secrets should not be hard-coded into the Docker Compose file or committed to Git. Secrets should be stored in an environment file or an appropriate secret-management service.

When rotating a password or other credential, the value should be changed at its source, the corresponding application configuration should be updated, and affected containers should be recreated or restarted. The application should then be tested to confirm that it can reconnect successfully. Old credentials should be invalidated after the new credentials have been verified.

## Database Recovery

If the database becomes unavailable, I would first check its status with `docker compose ps` and inspect its logs with `docker compose logs database`. The database can then be restarted with `docker compose restart database`.

After the database becomes healthy, I would verify that the backend reconnects successfully and test a database-dependent application request. If data corruption or loss occurs, the most recent verified backup should be restored before application functionality is tested again.

## Application Error Troubleshooting

If the application returns an error, I would check the Docker Compose service status and health checks first. I would then inspect the reverse-proxy and backend logs, verify that the required containers are running, confirm Docker network connectivity, and check whether the database is healthy.

I would also verify the Nginx routing configuration, environment variables, internal service names and ports, and the application's HTTP health endpoints. Sensitive values such as passwords and tokens should not be printed while troubleshooting.

## Reliability Test Results

During the backend reliability test, the backend service was deliberately made unavailable to confirm how the reverse proxy behaved during a controlled service failure. After the backend was restarted and became healthy again, the application/API response recovered successfully.

During the database reliability test, the database service was deliberately made unavailable and a database-dependent request was tested. The request failed as expected while the database was unavailable. After restarting the database and allowing it to become healthy, the application recovered and database-dependent functionality became available again.

These tests confirmed that the individual services can be restarted and recovered without rebuilding the entire environment or losing the persistent database data.


---

# Final Public Application URL

**EpicBook URL:** `http://16.170.240.216`

Replace the placeholder with your working public URL.

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/PeaceCloud-Solutions/theepicbook.git`

---

# LinkedIn Requirement

## Goal

Create a professional LinkedIn post of 6–10 lines about your EpicBook capstone deployment.

Your post must include:

- The architectural decision that most improved reliability
- Your biggest image-size reduction, with numbers
- Key production-hardening lessons
- A deployment verification image

### Evidence

**LinkedIn Post URL:** `Add your LinkedIn post URL here`

#### LinkedIn Post Screenshot

Add a screenshot of the published LinkedIn post showing the text body and deployment verification image.

---

# Submission Checklist

- [-] EpicBook repository reviewed and architecture diagram created
- [-] Environment variables, ports, persistence, and health-check details documented
- [-] Backend and frontend production Dockerfiles created
- [-] Backend runs as a non-root user
- [-] Docker image-size comparison completed
- [-] Docker Compose stack includes reverse proxy, frontend, backend, and database
- [-] `front-tier` and `back-tier` networks configured
- [-] `db_data` named volume configured
- [-] MySQL, backend, frontend, and reverse-proxy health checks configured
- [-] Startup dependencies use `service_healthy`
- [-] Nginx or Traefik selected as the only public reverse proxy
- [-] Only reverse-proxy port 80 is publicly published
- [-] Same-origin routing configured and CORS used only when required
- [-] Backup, restore, and persistence testing completed
- [-] Reverse-proxy and backend logs verified
- [-] Cloud VM deployment verified through the public IP
- [-] Backend and database reliability tests completed
- [-] Screenshots 1–36 included
- [-] Required notes completed
- [-] LinkedIn post URL and screenshot included
- [-] Full name visible in required screenshots or captions
- [-] No passwords, tokens, private keys, account IDs, or other sensitive information exposed

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
