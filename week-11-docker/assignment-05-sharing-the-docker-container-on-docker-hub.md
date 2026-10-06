# Assignment 5 — Sharing the Docker Container on Docker Hub

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will publish a Dockerized React application to Docker Hub, remove the local image tags, pull the image again from Docker Hub, and run it to verify that it can be downloaded and deployed from a container registry.

---

# Task 1 — Publish a Docker Image to Docker Hub

## Goal

Tag a locally built React image, publish it to Docker Hub, remove the local copy, pull it again from Docker Hub, and run it successfully.

### Evidence

#### Screenshot 1 — Public Docker Hub Repository

Add a screenshot of Docker Hub showing your newly created public repository:

```text
my-react-app
```

![Task 1.A](<screenshots/week 11-assignment 05-screenshot 1.A.png>)
![Task 1.A](<screenshots/week 11-assignment 05-screenshot 1.B.png>).

---

#### Screenshot 2 — Successful Docker Login

Add a screenshot of the terminal showing:

```text
Login Succeeded
```

Ensure that your full name is visible and that no password, Personal Access Token, or device code is exposed.

![Task 1.B](<screenshots/week 11-assignment 05-screenshot 2.png>).

---

#### Screenshot 3 — Correctly Tagged Image

Add a screenshot of the terminal showing:

```bash
docker image ls <YOUR_DOCKERHUB_USERNAME>/my-react-app
```

The output must show the `latest` tag.

![Task 1.C](<screenshots/week 11-assignment 05-screenshot 3.png>).

---

#### Screenshot 4 — Successful Docker Push

Add a screenshot of the terminal showing successful completion of:

```bash
docker push <YOUR_DOCKERHUB_USERNAME>/my-react-app:latest
```

The output must include a pushed status or image digest.

![Task 1.D](<screenshots/week 11-assignment 05-screenshot 4.png>).

---

#### Screenshot 5 — Published `latest` Tag in Docker Hub

Add a screenshot of your Docker Hub repository showing the uploaded `latest` image tag.

![task 1.E](<screesnhots/week 11-assignment 05-screenshot 5.png>).

---

#### Screenshot 6 — Local Image Removed and Pulled Again

Add a screenshot of the terminal showing:

- The targeted local image tags removed
- Successful `docker pull` output
- `docker image ls` showing the pulled image

![Task 1.F](<screenshots/week 11-assignment 05-screenshot 6.png>).

---

#### Screenshot 7 — Running Pulled Image

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show the running `react-container` with:

```text
0.0.0.0:80->80/tcp
```

![Task 1.G](<screenshots/week 11-assignment 05-screenshot 7.png>).

---

#### Screenshot 8 — React Application in Browser

Add a browser screenshot showing the React application at:

```text
http://<YOUR-VM-PUBLIC-IP>
```

Ensure that the VM public IP is visible in the address bar. Add your full name as a clear caption directly below the screenshot.

![Task 1.H](<screenshots/week 11-assignment 05-screenshot 8.png>).

---

# Docker Hub Repository URL

**Repository URL:** `http://16.170.240.216`

---

# Registry and Image Tagging Notes

Write a short explanation covering:

- Why image tagging is required before pushing to Docker Hub
- Why a container registry is useful in DevOps workflows
- Why production deployments should use versioned image tags instead of relying only on `latest`

Image tagging is required before pushing an image to Docker Hub because the tag identifies the repository, image name, and version associated with the image. In this assignment, I tagged my local react-multistage:latest image as peacecloudsolutions/my-react-app:latest, allowing Docker to identify the correct Docker Hub repository when the image was pushed.

A container registry such as Docker Hub provides a centralized location for storing, managing, and distributing container images. This allows the same tested image to be pulled and deployed across different environments without rebuilding the application each time. In this assignment, I verified this by removing the local image and successfully pulling it again from Docker Hub before running it on my EC2 instance.

Although the latest tag is convenient for learning and simple deployments, production environments should use versioned or immutable tags, such as v1.0.0, build-125, or a commit-based tag. Versioned tags make it easier to identify exactly which application version is deployed, maintain deployment consistency, troubleshoot issues, and roll back to a previous version when necessary.

---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about publishing a Docker container image to Docker Hub.

Include:

- Assignment title: **Publish a Docker Container Image to Docker Hub**
- Your Docker Hub repository URL
- What you published
- How you verified the remote image by pulling and running it
- Key learning outcomes

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://lnkd.in/p/e8wwPjnf`

---

#### LinkedIn Post Screenshot

![Linkedin Post](<screenshots/week 11-assignment 05-screenshot 9.png>).

---

# Submission Instructions

- Complete all steps in sequence.
- Include Screenshots 1–8 exactly as specified.
- Include your Docker Hub repository URL.
- Include the Registry and Image Tagging Notes.
- Include the LinkedIn post URL and screenshot.
- Ensure that your full name is visible in all terminal screenshots.
- Add your full name as a clear caption below the browser screenshot.
- Do not expose passwords, Personal Access Tokens, device codes, credentials, or other sensitive information.

---

# Completion Checklist

- [-] Public `my-react-app` repository created
- [-] Docker login completed successfully
- [-] `react-multistage:latest` tagged correctly
- [-] Image pushed to Docker Hub
- [-] `latest` tag verified in Docker Hub
- [-] Targeted local image tags removed
- [-] Image pulled again from Docker Hub
- [-] Pulled image runs successfully
- [-] React application is accessible through the VM public IP
- [-] Docker Hub repository URL included
- [-] Registry and image-tagging notes completed
- [-] LinkedIn post URL and screenshot included
- [-] All required screenshots included
- [-] Full name visible in terminal screenshots
- [-] Browser screenshot has a full-name caption
- [-] No passwords, tokens, or credentials exposed
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
