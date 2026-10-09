# Assignment 02 — ReplicaSets: Keeping Your Pods Alive

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create three NGINX Pods using a ReplicaSet, test auto-healing by deleting one Pod, and scale the ReplicaSet from three to five Pods.

---

# Task 0 — Pre-check: Remove the Pod from Assignment 01

## Goal

Confirm that you are connected to your learning cluster and remove the previous standalone Pod to prevent the ReplicaSet from adopting it.

### Evidence

No screenshots required.

---

# Task 1 — Set Up Your Working Directory

## Goal

Create and enter a dedicated directory for this ReplicaSet lab.

### Evidence

#### Screenshot 01 — Output of `pwd` showing the working directory ending in `/k8s-labs/replicasets`

![Task 1](<screenshots/week 12-assignment 02-screenshot -01-replicaset-lab-folder.png>).

---

### Notes

**1. Why is it useful to keep Kubernetes manifests in organized directories?**

Organized directories help me find the correct manifest, separate different labs and avoid applying the wrong file. They also make the files easier to review and maintain in Git.

---

**2. What file will you create in this directory for this assignment?**

I will create nginx-replicaset.yaml to define the NGINX ReplicaSet and its Pod template.

---

# Task 2 — Create and Apply the NGINX ReplicaSet

## Goal

Create a ReplicaSet that maintains three NGINX Pods.

### Evidence

#### Screenshot 02 — Completed `nginx-replicaset.yaml` manifest showing `replicas: 3`

![Task 2.A](<screenshots/week 12-assignment 02-screenshot -02-replicaset-manifest-three.png>).

---

#### Screenshot 03 — Output of `kubectl apply -f nginx-replicaset.yaml`

![Task 2.B](<screenshots/week 12-assignment 02-screenshot -03-replicaset-applied.png>).

---

#### Screenshot 04 — Output of `kubectl get pods` showing three NGINX Pods with `1/1` under `READY` and `Running` under `STATUS`

![Task 2.C](<screenshots/week 12-assignment 02-screenshot -04-three-pods-running.png>).

---

### Notes

**1. What does `replicas: 3` mean in this manifest?**

It sets the desired number of Pod replicas to three. The ReplicaSet controller creates or removes Pods as needed to maintain that count.

---

**2. Why must `selector.matchLabels` match `template.metadata.labels`?**

The selector identifies the Pods that belong to this ReplicaSet. Matching template labels ensure that the Pods it creates satisfy that selector.

---

**3. What image and image tag are used for the NGINX container?**

The container uses the official nginx image with the tag 1.21.1, written as nginx:1.21.1.

---

# Task 3 — Test ReplicaSet Auto-Healing

## Goal

Delete one Pod managed by the ReplicaSet and observe Kubernetes automatically create a replacement.

### Evidence

#### Screenshot 05 — Output of the command deleting one ReplicaSet-managed Pod

![Task 3.A](<screenshots/week 12-assignment 02-screenshot -05-pod-deleted.png>).

---

#### Screenshot 06 — Output of `kubectl get pods` showing the replacement Pod with a different name from the deleted Pod

![Task 3.B](<screenshots/week 12-assignment 02-screenshot -06-replacement-pod.png>).

---

#### Screenshot 07 — Output showing three NGINX Pods with `1/1` under `READY` and `Running` under `STATUS` again

![Task 3.C](<screenshots/week 12-assignment 02-screenshot -07-auto-healing-complete.png>).

---

### Notes

**1. What happened after you deleted one Pod?**

A replacement Pod appeared with a different name, restoring the count to three.

---

**2. How does the ReplicaSet know that a replacement Pod is needed?**

The controller detected fewer managed Pods than the desired count and created another from the template.

---

**3. What proves that auto-healing worked successfully?**

The deleted name disappeared, a new name appeared, and three Pods became Ready and Running again.

---

# Task 4 — Manually Scale the ReplicaSet

## Goal

Scale the ReplicaSet from three NGINX Pods to five NGINX Pods by changing the YAML manifest.

### Evidence

#### Screenshot 08 — Updated `nginx-replicaset.yaml` showing `replicas: 5`

![Task 4.A](<screenshots/week 12-assignment 02-screenshot -08-manifest-five-replicas.png>).

---

#### Screenshot 09 — Output of `kubectl get pods` showing five NGINX Pods with `1/1` under `READY` and `Running` under `STATUS`

![Task 4.B](<screenshots/week 12-assignment 02-screenshot -9A-five-pods-running.png>)
![Task 4.B](<screenshots/week 12-assignment 02-screenshot -9B-five-pods-running.png>).

---

### Notes

**1. What change did you make to scale the ReplicaSet?**

I changed spec.replicas from 3 to 5, saved the file and reapplied it.

---

**2. Did you manually create the additional Pods? Explain why or why not.**

No. The ReplicaSet controller created them to match the updated desired count.

---

**3. What would happen if you changed the replica count from five back to three?**

After applying the change, the ReplicaSet would remove two excess Pods.

---

# LinkedIn Requirement

Create a LinkedIn post that includes:

- A short explanation of what a Kubernetes ReplicaSet does.
- What happened when you deleted one NGINX Pod.
- How Kubernetes automatically created a replacement Pod to maintain the desired replica count.
- What you learned by changing the replica count from three to five.
- One screenshot showing either:
  - Three Pods running after the auto-healing test, or
  - Five Pods running after scaling the ReplicaSet.

Do not share sensitive information, cluster credentials, tokens, or kubeconfig details in your post.

### Evidence

#### Screenshot 10 — Published LinkedIn post showing your name, the required explanation, and the attached Pod screenshot

![LinkedIn Post](<screenshots/week 12-assignment 02-screenshot -10-LinkedInPost.png>).

---

### Post Link

[LinkedIn Post](https://lnkd.in/p/eb6E88CC).

---

# Submission Instructions

- Add all required screenshots, numbered 01–10, to this template.
- Full Name must be visible in required screenshots.
- Ensure screenshots are clear and readable.
- Submit the final `nginx-replicaset.yaml` file showing `replicas: 5`. Screenshot 02 provides evidence of the initial manifest with `replicas: 3`.
- Complete the Notes sections in Tasks 1–4 in your own words.
- Include the published LinkedIn post URL.
- Do not expose tokens, passwords, private keys, kubeconfig files, or account IDs.

---

# Completion Checklist

- [-] Completed Task 0 and confirmed that the previous `nginx-pod` is no longer listed
- [-] Created and entered the ReplicaSet working directory (Screenshot 01)
- [-] Created `nginx-replicaset.yaml` with an initial replica count of three (Screenshot 02)
- [-] Applied the ReplicaSet manifest successfully (Screenshot 03)
- [-] Confirmed three NGINX Pods are running (Screenshot 04)
- [-] Deleted one ReplicaSet-managed Pod (Screenshot 05)
- [-] Observed the automatically created replacement Pod (Screenshot 06)
- [-] Confirmed three NGINX Pods are running again (Screenshot 07)
- [-] Changed the replica count from three to five (Screenshot 08)
- [-] Confirmed five NGINX Pods are running (Screenshot 09)
- [-] Submitted the final `nginx-replicaset.yaml` file with `replicas: 5`
- [-] Completed the Notes sections in Tasks 1–4
- [-] Published the LinkedIn post with the required explanation and Pod screenshot (Screenshot 10)
- [-] Included the published LinkedIn post URL
- [-] Included all required screenshots
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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
