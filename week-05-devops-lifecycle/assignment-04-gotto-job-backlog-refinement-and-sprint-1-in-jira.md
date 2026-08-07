# Assignment 4 — Gotto Job: Backlog Refinement & Sprint 1 in Jira

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this 90-minute, time-boxed exercise, you will act as a Scrum team — or run in Solo Mode, playing every role yourself — to turn the Gotto Job template into a value-ordered backlog, estimate the work in story points, plan Sprint 1, open the burndown chart, and ship one small UI-only increment (text, color, spacing, a label, or a CTA — no backend changes).

---

# Task 1 — Roles & Mode Setup (Team vs Solo)

## Goal

Choose Team Mode or Solo Mode, and document how each Scrum role (Product Owner, Scrum Master, Dev Lead, DevOps Lead) was handled.

### Evidence

#### Screenshot 1 — Jira "Create project" screen, or the project sidebar after creation

![Task 1](<screenshots/week 05-assignment 04-screenshot 1.png>).

---

### Notes

Write one line for each role: PO (what you prioritized), SM (how you ensured process), Dev Lead (what you built), DevOps Lead (how you shipped).


Product Owner (PO): Prioritized the highest-value UI improvements that would improve usability, readability, and user trust.

Scrum Master (SM): Planned Sprint 1, created the Sprint Goal, monitored progress through Jira, and ensured each Story moved through the workflow.

Dev Lead: Implemented the selected UI improvements, committed the code with Git, and verified the changes locally before deployment.

DevOps Lead: Deployed the updated website to AWS EC2, verified the live deployment, and ensured the UI increment was successfully delivered.

---

# Task 2 — Create the Jira Project (Team-managed → Scrum)

## Goal

Create a Team-managed Scrum project named `Gotto Job – Team <#>` (Team Mode) or `Gotto Job – <YourName>` (Solo Mode).

### Evidence

#### Screenshot 2 — Project created page showing the project name and key

![Task 2](<screenshots/week 05-assignment 04-screenshot 2.png>).

---

# Task 3 — Create the Epic

## Goal

Create the Epic `Improve Gotto Job UI discoverability & trust` to group the UI improvement initiative.

### Evidence

#### Screenshot 3 — Backlog showing the Epic panel with the Epic visible

![Task 3](<screenshots/week 05-assignment 04-screenshot 3.png>).

---

# Task 4 — Seed the Product Backlog (6–8 Stories + Fibonacci Points + Ranking)

## Goal

Create at least six Stories under the Epic, estimate each with 1, 2, or 3 story points, and rank them by value.

### Evidence

#### Screenshot 4 — Backlog showing the Epic and at least six Stories under it

![Task 4.A](<screenshots/week 05-assignment 04-screenshot 4.png>).

---

#### Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in

![Task 4.B](<screenshots/week 05-assignment 04-screenshot 5.png>).

---

# Task 5 — Planning Poker (Estimate + Debate Notes)

## Goal

Confirm the Story Points (1, 2, or 3) for each Story and record brief reasoning for each estimate.

### Evidence

#### Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points

![Task 5.A](<screenshots/week 05-assignment 04-screenshot 6.png>).

---

### Notes

For each story, explain in one or two lines why it is a 1, 2, or 3 (mention any debate, even in Solo Mode).

Story 1 — Improve homepage hero tagline clarity

Story Points: 1

Reason:
This is a simple text update with minimal effort and low implementation risk.

Solo Mode Debate:
I initially considered 2 points, but after reviewing the scope, I concluded that only the homepage text needed to change, so 1 point was appropriate.

Story 2 — Improve primary Call-to-Action button styling

Story Points: 1

Reason:
Only CSS styling changes were required without affecting functionality.

Solo Mode Debate:
There was little complexity, so I kept the estimate at 1 point.

Story 3 — Improve job card spacing and typography

Story Points: 2

Reason:
This required updates to multiple UI elements and validation across different screen sizes.

Solo Mode Debate:
I debated between 2 and 3 points but selected 2 because the work remained UI-only.

Story 4 — Add "Remote" badge styling to job listings

Story Points: 2

Reason:
Adding and styling the badge required layout adjustments and visual verification.

Solo Mode Debate:
Although straightforward, testing across multiple job cards increased the effort.

Story 5 — Improve "Apply Now" button visibility

Story Points: 1

Reason:
This involved minor UI adjustments with minimal implementation effort.

Solo Mode Debate:
No significant debate; the task was small and low risk..

Story 6 — Improve footer trust links and contact section

Story Points: 1

Reason:
Multiple footer elements required updating and testing for responsiveness.

Solo Mode Debate:
I considered 3 points but determined that no backend work was required.

Story 7 — Improve advanced search labels and placeholders

Story Points: 2

Reason:
This Story involves updating the search labels and placeholder text to make the job search feature clearer and more intuitive. It also requires checking the layout after the text changes.

Solo Mode Debate:
I initially considered 1 point because it is mostly text updates. However, I assigned 2 points since I needed to verify the UI alignment and ensure the changes remained responsive across different screen sizes.

Story 8 — Add "Posted on" date label to job listings

Story Points: 1

Reason:
This is a small UI enhancement that adds a visible "Posted on" label to improve job information clarity. It requires minimal implementation and testing.

Solo Mode Debate:
I briefly considered 2 points, but since it only adds a simple UI element without changing functionality, I estimated it as 1 point.

---

# Task 6 — Sprint Planning: Create Sprint 1 + Sprint Goal + Scope

## Goal

Create Sprint 1, move three or four Stories into it (approximately 3–6 points), set the Sprint Goal, and break each selected Story into Build, Verify, Deploy, and Screenshot Sub-tasks.

### Evidence

#### Screenshot 7 — Sprint 1 with the selected Stories inside it

![Task 6.A](<screenshots/week 05-assignment 04-screenshot 7.png>).

---

#### Screenshot 8 — One Story showing the Sub-tasks created

![Task 6.C](<screenshots/week 05-assignment 04-screenshot 8.png>).

---

# Task 7 — Reports: Open Burndown Chart

## Goal

Open the Burndown Chart and confirm it exists for Sprint 1. It is acceptable if the chart is not yet populated.

### Evidence

#### Screenshot 9 — Burndown Chart page opened, even if empty

![Task 7](<screenshots/week 05-assignment 04-screenshot 9.png>).

---

# Task 8 — Ship One Small Increment (Build + Deploy + Proof)

## Goal

Implement one small UI-only Story from Sprint 1, commit it, deploy it live, and move the Story and its Sub-tasks to Done in Jira.

### Evidence

#### Screenshot 10 — Jira board showing the Story moved to Done

![Task 8.A](<screenshots/week 05-assignment 04-screenshot 10.png>).

---

#### Screenshot 11 — Git commit output

![Task 8.B](<screenshots/week 05-assignment 04-screenshot 11.png>).

---

#### Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible

Add your screenshot here.

---

# Task 9 — Retro Notes (Scrum Pillar + Value)

## Goal

Add a retro comment covering what went well, what to improve, one Scrum pillar observed (Transparency, Inspection, or Adaptation), and one Scrum value (Openness, Focus, Commitment, Courage, or Respect).

### Evidence

#### Screenshot 13 — Jira retro comment visible

Add your screenshot here.

---

# Task 10 — LinkedIn Post (Mandatory)

## Goal

Publish a LinkedIn post about what you delivered, including your live URL, three to five lines on what you did and learned, and one screenshot (Burndown Chart, Sprint board, or the live UI change).

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

#### Screenshot 14 — Published LinkedIn post

Add your screenshot here.

---

# Submission Instructions

- Add all 14 required screenshots
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [-] Task 1: Team Mode or Solo Mode selected and all four roles documented (Screenshot 1 & Notes)
- [-] Task 2: Team-managed Scrum project created with the required name (Screenshot 2)
- [-] Task 3: UI improvement Epic created (Screenshot 3)
- [-] Task 4: 6–8 Stories added under the Epic and ranked by value (Screenshots 4 & 5)
- [-] Task 5: Story Points set (1, 2, or 3) with reasoning recorded (Screenshot 6 & Notes)
- [-] Task 6: Sprint 1 created with Sprint Goal, 3–4 Stories, and Sub-tasks (Screenshots 7 & 8)
- [-] Task 7: Burndown Chart opened (Screenshot 9)
- [-] Task 8: One UI-only increment implemented, committed, deployed, and verified (Screenshots 10–12)
- [-] Task 9: Retro comment with one Scrum pillar and one Scrum value (Screenshot 13)
- [-] Task 10: Mandatory LinkedIn post published with the live URL, backlog refinement, Sprint planning, one shipped increment, proof, and Screenshot 14
- [-] Full Name visible in required screenshots
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
