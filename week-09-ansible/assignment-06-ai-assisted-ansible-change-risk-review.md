# Assignment 6 — AI-Assisted Ansible Change Risk Review

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build an AI-assisted Ansible risk-review workflow using `ansible-playbook --check --diff`, Bash scripting, and Claude Code.

You will review possible server changes before applying them, classify risky tasks, and keep the final apply decision under human control.

---

# Task 1 — Confirm EpicBook Connectivity and Create the Workspace

## Goal

Confirm that your previous EpicBook Ansible project is working before creating the risk-review automation.

### Evidence

#### Screenshot 1 — Output of `ansible web -i inventory.ini -m ping`

![Task 1.A](<screenshots/week 09-assignment 06-screenshot 1.png>).

---

#### Screenshot 2 — Output of `ansible-playbook -i inventory.ini site.yml --syntax-check`

![Task 1.B](<screenshots/week 09-assignment 06-screenshot 2.png>).

---

#### Screenshot 3 — Output of `pwd` and `find . -maxdepth 4 -type d | sort`

![Task 1.C](<screenshots/week 09-assignment 06-screenshot 3.png>).

---

### Notes

Answer the following in your own words:

**1. What proves that Ansible can reach your EpicBook VM?**

I confirmed that Ansible could reach my EpicBook VM by running the Ansible ping command against the web host group. The command returned SUCCESS and "ping": "pong", which showed that the controller could connect to the VM through SSH and execute an Ansible module successfully. This gave me a working starting point before I began building the risk-review workflow.

---

**2. Why should you confirm playbook syntax before building a risk-review script?**

I checked the playbook syntax first because there was no point analyzing the risk of a playbook that could not be parsed correctly. A syntax error could cause the dry-run process to fail before any useful change information was collected. Running --syntax-check helped me separate basic YAML or Ansible errors from the actual change-risk analysis I wanted the script to perform.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` file that tells Claude Code how this project must behave.

### Evidence

#### Screenshot 4 — `CLAUDE.md` open in VS Code or terminal showing the safety rules

![Task 2](<screenshots/week 09-assignment 06-screenshot 4.png>).

---

### Notes

Answer the following in your own words:

**1. Why should Claude Code have project-specific safety rules?**

I gave Claude Code project-specific safety rules because this workflow interacts with a real Ansible-managed VM. Without clear boundaries, an AI assistant could potentially move from analyzing a change to executing it. The rules in CLAUDE.md established what Claude could inspect and what it must not do, especially applying playbooks, editing infrastructure files, or making state-changing operations.

---

**2. Why should the human run the real Ansible playbook manually?**

The human should run the real playbook manually because the final deployment decision should remain under human control. The dry-run report and Claude Code analysis provide useful evidence, but I am responsible for deciding whether the identified changes are acceptable. This separation allowed AI to support my decision without giving it authority to change the server automatically.

---

**3. Which rule prevents Claude Code from applying changes automatically?**

The main rule is that Claude Code must never run ansible-playbook without --check. The project instructions also explicitly state that it must never apply, converge, or automatically fix the environment. Together, these rules keep Claude Code in a read-only review role while the real playbook execution remains a human action.

---

# Task 3 — Ask Claude Code to Plan the Risk Review

## Goal

Use Claude Code to produce a read-only plan before writing the Bash script.

### Evidence

#### Screenshot 5 — Claude Code showing the four-category risk-classification plan

![Task 3](<screenshots/week 09-assignment 06-screenshot 5.A.png>).
![Task 3](<screenshots/week 09-assignment 06-screenshot 5.B.png>).
---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

The Gather phase involved giving Claude Code the project context and asking it to inspect the requirements in CLAUDE.md. This provided the information needed to understand what the risk-review workflow should examine while keeping the activity read-only.

---

**2. Which part represents the Analyze phase?**

The Analyze phase was Claude Code reasoning about the proposed Ansible changes and organizing them into the four required categories: service restarts or handlers, firewall changes, user or sudo changes, and package or file removal. It also explained the possible real-world impact of each category.

---

**3. How did you verify Claude Code did not create or edit files?**

I explicitly instructed Claude Code not to create or edit any files. Its response remained a proposed plan rather than an implementation, and it also confirmed that it had not created or modified a file. This showed that the planning stage remained separate from implementation.

---

# Task 4 — Build the Ansible Risk Review Script

## Goal

Create a Bash script that runs an Ansible dry run and classifies risky changes.

### Evidence

#### Screenshot 6 — Top section of `ansible-check-review.sh` showing `full_name`, `playbook_path`, `inventory_path`, and the `checks` array

![Task 4.A](<screenshots/week 09-assignment 06-screenshot 6.png>).

---

#### Screenshot 7 — Middle section showing `extract_changed_tasks` and `check_tasks_matching_pattern`

![Task 4.B](<screenshots/week 09-assignment 06-screenshot 7.A.png>).
![Task 4.B](<screenshots/week 09-assignment 06-screenshot 7.B.png>).

---

#### Screenshot 8 — Bottom section showing the loop, summary, and exit behavior

![Task 4.C](<screenshots/week 09-assignment 06-screenshot 8.png>).

---

#### Screenshot 9 — Output of `bash -n ansible-check-review.sh` and `ls -l ansible-check-review.sh`

![Task 4.D](<screenshots/week 09-assignment 06-screenshot 9.png>).

---

### Notes

Answer the following in your own words:

**1. What is stored in the `changed_tasks` array?**

The changed_tasks array stores the Ansible tasks that the dry run reports as tasks that would change the managed system. Instead of treating every playbook task as a risk, the script focuses its classification on tasks for which Ansible predicts an actual state change.

---

**2. Which function finds changed tasks from the Ansible output?**

The extract_changed_tasks function finds the changed tasks. It processes the Ansible dry-run output and extracts the task names associated with changes so they can be checked against the risk patterns.

---

**3. Why does the script use `--check --diff`?**

I used --check --diff because I wanted to see the expected effect of the playbook without intentionally applying the proposed changes. Check mode performs a dry run, while diff mode provides additional information about differences Ansible expects to make. This creates useful evidence for reviewing a change before deployment.

---

**4. Why does the script use different exit codes for healthy, warning, and failed results?**

Different exit codes make the result useful to both a human and other automation. An exit code of 0 represents a healthy result, 1 indicates that changes were detected and should be reviewed, and 2 represents risky or failed conditions. This makes the final risk state easier to identify programmatically instead of relying only on terminal text.

---

# Task 5 — Run the Baseline Dry-Run Review

## Goal

Run the script against your current EpicBook playbook and confirm the baseline risk status.

### Evidence

#### Screenshot 10 — Output of `./ansible-check-review.sh`

![Task 5.A](<screenshots/week 09-assignment 06-screenshot 10.png>).

---

#### Screenshot 11 — Output of `echo "Captured Exit Code: $script_exit_code"` and `cat reports/ansible-risk-report.txt`

![Task 5.B](<screenshots/week 09-assignment 06-screenshot 11.png>).

---

### Notes

Answer the following in your own words:

**1. What was the overall status of your baseline run?**

My baseline run returned an overall status of WARN. The playbook itself was reachable and did not report failed or unreachable hosts, but the dry run found tasks that would make changes. The warning therefore told me that the playbook needed review rather than indicating that the environment had failed.

---

**2. Did any tasks report `changed`?**

Yes. Four tasks were identified as changes during my baseline review: updating the apt package cache, starting and enabling Nginx, setting ownership of the EpicBook application directory, and installing the EpicBook Node.js dependencies.

---

**3. Were any changed tasks flagged as risky?**

No task in my baseline run matched the script's four formal risky categories. The script reported no service-restart, firewall, user/sudo, or removal task among the detected changes. The baseline therefore remained a warning rather than a failure.

---

**4. What does the script exit code mean?**

The baseline returned exit code 1. In my script, this means that changes were detected and human review was recommended, but the formal risk checks had not produced a failure. An exit code of 2 is reserved for a failed or risky result, while 0 represents a healthy result.

---

# Task 6 — Create and Run the Claude Code Skill

## Goal

Turn the Bash script into a reusable Claude Code skill called `/ansible-risk-review`.

### Evidence

#### Screenshot 12 — `SKILL.md` showing the frontmatter, allowed tools, and safety rules

![Task 6.A](<screenshots/week 09-assignment 06-screenshot 12.png>).

---

#### Screenshot 13 — Claude Code output after running `/ansible-risk-review`

![Task 6.B](<screenshots/week 09-assignment 06-screenshot 13.A.png>).
![Task 6.B](<screenshots/week 09-assignment 06-screenshot 13.B.png>).

---

### Notes

Answer the following in your own words:

**1. Why does this skill allow `Bash`, `Read`, and `Grep`?**

The skill allows Bash, Read, and Grep because these tools are enough to execute the controlled review script, read its generated reports, and search the evidence for relevant findings. This gives Claude Code the tools it needs for analysis without giving it unnecessary write capabilities.

---

**2. Why does this skill not allow file editing?**

I deliberately excluded file-editing capability because the skill is intended to review changes, not create them. Allowing editing would weaken the separation between analysis and implementation and could let an AI-generated recommendation directly alter the playbook being reviewed.

---

**3. What part is handled by Bash?**

Bash handles the deterministic part of the workflow. The script executes the Ansible dry run, extracts changed tasks, checks them against the defined patterns, produces the risk report, calculates the summary, and returns an appropriate exit code.

---

**4. What part is handled by Claude Code?**

Claude Code handles the interpretation of the evidence. It reads the generated report, explains why particular changes could matter, describes their potential impact, and recommends whether human review is needed. It does not make the final deployment decision.

---

**5. Why is this better than asking Claude Code if the playbook is safe without giving it evidence?**

It is better because the analysis is based on actual output from ansible-playbook --check --diff rather than assumptions about what the playbook might do. The Bash script provides repeatable evidence from the environment, while Claude Code helps interpret that evidence. This makes the recommendation more grounded and auditable.

---

# Task 7 — Introduce a Controlled Risky Change and Let the Skill Catch It

## Goal

Add a small controlled risky change in your lab playbook and confirm the script and Claude Code catch it before applying.

### Evidence

#### Screenshot 14 — The added risky task inside the role file

![Task 7.A](<screenshots/week 09-assignment 06-screenshot 14.png>).

---

#### Screenshot 15 — Output of `./ansible-check-review.sh`

![Task 7.B](<screenshots/week 09-assignment 06-screenshot 15.png>).

---

#### Screenshot 16 — Claude Code `/ansible-risk-review` output showing the risky finding

![Task 7.C](<screenshots/week 09-assignment 06-screenshot 16.A.png>).
![Task 7.C](<screenshots/week 09-assignment 06-screenshot 16.B.png>).

---

#### Screenshot 17 — Output of `cat reports/risky-change-report.txt`

![Task 7.D](<screenshots/week 09-assignment 06-screenshot 17.png>).

---

### Notes

Answer the following in your own words:

**1. Which risk category did the added task fall into?**

The controlled task fell into the package or file removal category. I deliberately added a task named Remove temporary EpicBook risk test file, which set the temporary test file to state: absent. This allowed me to test the risk-review workflow with a harmless lab example.

---

**2. What evidence proves the task would change something?**

The Ansible dry-run evidence showed would change: common : Remove temporary EpicBook risk test file. The script then reported [FAIL] 1 removal task(s) found in the changed set. This proved that the proposed removal had been identified before I executed the real playbook.

---

**3. Did Claude Code apply the playbook?**

No. Claude Code only analyzed the report produced by the read-only workflow. The real ansible-playbook command was not executed by Claude Code.

---

**4. Why is it important that Claude Code only analyzed the risk?**

Keeping Claude Code in an analysis role prevented an AI recommendation from immediately becoming a production action. Even when the AI correctly identifies a change, there may be business, security, availability, or operational information that requires human judgement. I therefore kept the final decision and execution under my control.

---

**5. Which phase of the Agentic Loop is represented by the Bash report?**

The Bash report primarily represents the Gather phase because it collects concrete evidence from the Ansible dry run. That evidence is then passed into the Analyze phase, where the risk categories and possible impact can be interpreted.

---

# Task 8 — Apply as the Human, Verify, and Write the Change Summary

## Goal

Review the risky-change report, apply the playbook manually as the human operator, and verify the result.

### Evidence

#### Screenshot 18 — Output of the real playbook run showing the final recap with `failed=0`

![Task 8.A](<screenshots/week 09-assignment 06-screenshot 18.png>).

---

#### Screenshot 19 — Output of `ansible web -i inventory.ini -m ping`

![Task 8.B](<screenshots/week 09-assignment 06-screenshot 19.png>)..

---

#### Screenshot 20 — Second `/ansible-risk-review` output after applying the change

![Task 8.C](<screenshots/week 09-assignment 06-screenshot 20.A.png>).
![Task 8.C](<screenshots/week 09-assignment 06-screenshot 20.B.png>).

---

#### Screenshot 21 — Output of `ls -lah reports`

![Task 8.D](<screenshots/week 09-assignment 06-screenshot 21.png>).

---

#### Screenshot 22 — `change-summary.md` showing all required sections and your Full Name

![Task 8.E](<screenshots/week 09-assignment 06-screenshot 22.png>).

---

### Notes

Answer the following in your own words:

**1. What command did you run to apply the change for real?**

After reviewing the risk evidence, I manually applied the playbook using:ansible-playbook -i inventory.ini site.yml 
This was deliberately different from the earlier dry-run commands because this was the point where I, as the human operator, decided to allow the change to reach the VM.

---

**2. Who made the final decision to apply the playbook?**

I made the final decision as the human operator. The Bash script gathered the evidence and Claude Code helped analyze the possible risk, but neither was given authority to approve and execute the real change.

---

**3. What evidence proves the VM is still reachable?**

After applying the playbook, I ran the Ansible ping command again. The VM returned SUCCESS and "ping": "pong". The real playbook also completed with unreachable=0 and failed=0, giving me additional evidence that the deployment completed successfully and the VM remained accessible.

---

**4. Why should the risk review be run again after applying?**

I ran the risk review again so that I could compare the environment after the approved change with the state I reviewed beforehand. Post-change verification is important because a successful apply does not automatically prove that everything is in the expected state. Running the review again also created post-apply evidence for the audit trail.

---

**5. What could go wrong if an AI agent applied Ansible changes automatically?**

An AI agent applying changes automatically could misinterpret a task, remove an important file, restart a critical service, change access permissions, or modify firewall rules without considering the wider operational impact. Even technically valid automation can have unintended consequences. For that reason, I used AI to support the review process while keeping approval and execution with the human operator.

---

# LinkedIn Post Required

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/peace-offor-aa736a147_ansible-devops-claudecode-activity-7504670473696239616-89GM?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ`

---

#### Screenshot — Published LinkedIn post

![LinkedIn Post](<screenshots/week 09-assignment 06-screenshot 23.png>).

---

# Required Files

Confirm that the following files are included in your GitHub repository or assignment folder:

- [-] `CLAUDE.md`
- [-] `ansible-check-review.sh`
- [-] `.claude/skills/ansible-risk-review/SKILL.md`
- [-] `reports/risky-change-report.txt`
- [-] `reports/post-apply-report.txt`
- [-] `change-summary.md`

---

# Submission Instructions

- Add all required screenshots in your submission.
- Full Name must be visible in required screenshots and reports.
- All required notes must be answered clearly.
- Do not expose SSH private keys, passwords, cloud credentials, database credentials, or secret environment variables.
- Add your GitHub repository or folder URL inside this document.
- Submit only your Google Doc link.

---

# Completion Checklist

- [-] Task 1: EpicBook connectivity confirmed and workspace created
- [-] Task 2: `CLAUDE.md` created with safety rules
- [-] Task 3: Claude Code produced a read-only risk-review plan
- [-] Task 4: `ansible-check-review.sh` created and syntax checked
- [-] Task 5: Baseline dry-run review completed
- [-] Task 6: Claude Code `/ansible-risk-review` skill created and tested
- [-] Task 7: Controlled risky change introduced and detected
- [-] Task 8: Human applied the change and verified the result
- [-] Risky-change report saved
- [-] Post-apply report saved
- [-] Change summary completed
- [-] All screenshots added
- [-] All notes answered
- [-] LinkedIn post published
- [-] LinkedIn post URL added
- [-] No sensitive information exposed
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