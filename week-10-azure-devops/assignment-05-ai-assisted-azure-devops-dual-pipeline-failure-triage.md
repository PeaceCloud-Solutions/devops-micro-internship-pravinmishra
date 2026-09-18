# Assignment 5 — AI-Assisted Azure DevOps Dual-Pipeline Failure Triage

Part of the DevOps Micro Internship (DMI) — Agentic AI Track

---

## Student Information

**Full Name:** [Peace Nwadinachi Offor]

**GitHub Repository or Fork URL:** [(https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra)]

**Public LinkedIn Post URL:** [Paste your LinkedIn post URL]

---

## Purpose

In this assignment, I configured an AI-assisted, read-only failure-triage workflow for the EpicBook Infrastructure and Application Pipelines. The workflow uses Bash to gather Azure DevOps pipeline evidence and Claude Code to analyze the evidence and recommend a recovery action while keeping all changes under human control.

---

# Task 0 — Verify Tools, Authentication, and Pipeline Details

## Goal

Verify the required tools, Azure DevOps authentication, organization and project details, and numeric pipeline IDs.

No screenshot is required for this task.

---

# Task 1 — Capture the Healthy Baseline and Prepare the Supplied Files

## Goal

Confirm that both EpicBook pipelines are healthy and place the supplied assignment files in the correct repository locations.

## Evidence

### Screenshot 1 — Healthy Baseline for Both Pipelines

Terminal output showing the latest completed Infrastructure and Application Pipeline runs with successful results.

![Task 1](<screenshots/week 10-assignment 05-screenshot 1.png>).

## Notes

### 1. What proves that both pipelines were healthy before the drill?

[The latest completed runs of both the Infrastructure Pipeline and Application Pipeline showed a completed status with a successful result. This established that the Terraform infrastructure workflow and Ansible application deployment workflow were functioning correctly before I introduced the controlled failure.]

### 2. Why is a healthy baseline necessary before introducing a controlled failure?

[A healthy baseline provides a known working state for comparison. By confirming that both pipelines were successful beforehand, I could clearly associate any subsequent Application Pipeline failure with the deliberate change introduced during the incident drill rather than with a pre-existing problem.]

---

# Task 2 — Configure and Review the Supplied CLAUDE.md

## Goal

Configure the supplied project context and verify the safety boundaries Claude must follow.

## Evidence

### Screenshot 2 — CLAUDE.md Context and Safety Rules

`CLAUDE.md` open in the editor with the Project Overview, Incident Workflow, Safety Rules, and Output Rules visible.

![Task 2](<screenshots/week 10-assignment 05-screenshot 2.A.png>).
![Task 2](<screenshots/week 10-assignment 05-screenshot 2.B.png>)
![Task 2](<screenshots/week 10-assignment 05-screenshot 2.C.png>)
![Task 2](<screenshots/week 10-assignment 05-screenshot 2.D.png>)

## Notes

### 1. Why does Claude need project-specific operational context?

[Claude needs project-specific operational context so that its analysis is based on the actual EpicBook environment rather than generic assumptions. The context identifies the Infrastructure and Application Pipelines, explains the incident workflow, defines the available evidence, and establishes the boundaries within which the analysis must operate.]

### 2. Which rules keep the human responsible for the recovery action?

[The safety rules prevent Claude from editing project files, changing pipeline YAML, triggering or retrying pipelines, approving deployments, running Terraform or Ansible, modifying Azure resources, or applying the recommended fix. Claude is limited to analyzing evidence and recommending an action, while the engineer reviews and performs the recovery manually.]

### 3. Which rules protect pipeline credentials and application secrets?

[The security rules prohibit Claude from reading, printing, modifying, or exposing credentials and secrets. They also prevent it from changing Service Connections or accessing protected credentials such as PATs, SSH private keys, database passwords, authorization headers, and other sensitive values.]

---

# Task 3 — Configure and Validate the Supplied Pipeline Triage Script

## Goal

Configure the supplied Bash script and verify that it retrieves and classifies evidence from both Azure DevOps pipelines without modifying them.

## Evidence

### Screenshot 3 — Pipeline Triage Script Configuration

Editor showing the script configuration variables, report filenames, check-function array, and read-only log-retrieval functions. Ensure that no token is visible.

![Task 3.A](<screenshots/week 10-assignment 05-screenshot 3.png>).


---

### Screenshot 4 — Script Validation

Terminal showing successful Bash syntax validation and executable file permission.

![Task 3.B](<screenshots/week 10-assignment 05-screenshot 4.png>).

## Notes

### 1. Why are pipeline metadata and step console logs handled separately?

[Pipeline metadata provides high-level information such as the pipeline name, run ID, branch, status, result, and completion time. Step console logs contain the detailed execution evidence required to understand why a particular task failed. Handling them separately allows the script to identify the relevant run first and then retrieve the detailed evidence needed for diagnosis.]

### 2. How does the script obtain the actual console logs?

[The script identifies the relevant Azure DevOps pipeline run and its log IDs, then uses an authenticated read-only Azure DevOps Build Logs API method to retrieve the individual console logs as text. This provides the detailed step output required for failure classification.]

### 3. How does the check-function array control the classification loop?

[The check-function array contains the failure-check functions that the script must evaluate. The classification loop iterates through those functions in a controlled order, allowing each function to inspect the collected log evidence for patterns associated with a particular failure category.]

### 4. What prevents a failed but unmatched run from being reported as healthy?

[The script checks the Azure DevOps run result independently of its pattern matches. If Azure DevOps reports that the run failed but none of the known failure patterns match the logs, the script classifies the incident as an Unclassified Pipeline Failure instead of reporting the run as healthy.]

### 5. Why are different exit codes useful to another automation tool?

[Different exit codes provide a machine-readable indication of the triage result. For example, an exit code can distinguish a healthy state from an incomplete or warning state, a detected pipeline failure, or a configuration/API error. This allows another automation tool to respond appropriately without having to interpret the entire report.]

---

# Task 4 — Run and Understand the Healthy-State Report

## Goal

Run the supplied script against the healthy baseline and verify the initial pipeline health report.

## Evidence

### Screenshot 5 — Healthy Pipeline Report

Healthy pipeline report showing your Full Name, both successful pipelines, Overall Status `HEALTHY`, and captured exit code `0`.

![Task 4](<screenshots/week 10-assignment 05-screenshot 5.A.png>).
![Task 4](<screenshots/week 10-assignment 05-screenshot 5.B.png>)

## Notes

### 1. What evidence proves that both pipelines are healthy?

[The generated health report shows that the latest completed Infrastructure and Application Pipeline runs both have successful results, no failure category is detected, and the overall status is reported as HEALTHY. The script also returns exit code 0.]

### 2. Why must the baseline exit code be verified before the incident drill?

[Verifying the baseline exit code confirms that the triage script itself correctly recognizes the known healthy environment. Establishing exit code 0 before introducing the failure provides a reliable reference point for comparing the failed and recovered states later in the exercise.]

---

# Task 5 — Configure and Test the Supplied /pipeline-triage Skill

## Goal

Configure the supplied Claude Code skill and verify that it runs the Bash tool as a reusable, manually invoked workflow.

## Evidence

### Screenshot 6 — Pipeline-Triage Skill Definition

`SKILL.md` showing the frontmatter, manual-invocation setting, narrowly scoped tools, safety rules, and required output structure.

![Task 5](<screenshots/week 10-assignment 05-screenshot 6.png>).

---

### Screenshot 7 — Healthy Skill Result

Healthy `/pipeline-triage` result showing that both pipelines are healthy and no fix is required.

![Task 5](<screenshots/week 10-assignment 05-screenshot 7.A.png>).
![Task 5](<screenshots/week 10-assignment 05-screenshot 7.B.png>)

## Notes

### 1. Why is `disable-model-invocation: true` appropriate for this skill?

[This setting ensures that the pipeline-triage workflow is started intentionally by the user rather than automatically by the model. This is appropriate for an operational workflow that inspects CI/CD systems because the engineer should remain in control of when pipeline evidence is collected and analyzed.]

### 2. Why should the skill avoid broad Bash approval?

[Broad Bash approval could allow commands outside the intended read-only triage workflow to execute without sufficient human oversight. Restricting approval to the exact triage command reduces the risk of unintended file changes, pipeline operations, deployments, or access to sensitive information.]

### 3. What work is performed by Bash, and what work is performed by Claude?

[The Bash script performs the deterministic evidence-gathering work. It retrieves pipeline metadata and logs, checks known failure patterns, classifies the results, and generates the structured report. Claude reads and explains that evidence, identifies a likely cause, recommends one human recovery action, and provides a verification step.]

### 4. Why are permission rules required in addition to written safety instructions?

[Written safety instructions describe how Claude should behave, while permission rules provide an additional technical boundary around what tools and commands can actually be used. Combining both approaches provides stronger protection against unintended actions and helps preserve the read-only design of the triage workflow.]

---

# Task 6 — Introduce a Safe Failure in the Application Pipeline

## Goal

Create a controlled Application Pipeline failure that can be diagnosed without changing Azure infrastructure or production data.

## Evidence

### Screenshot 8 — Controlled Application Pipeline Failure

Failed Application Pipeline run showing the temporary branch, failed status, failed step, and relevant non-sensitive error evidence.

![Task 6](<screenshots/week 10-assignment 05-screenshot 8.A.png>)
![Task 6](<screenshots/week 10-assignment 05-screenshot 8.B.png>)
![Task 6](<screenshots/week 10-assignment 05-screenshot 8.C.png>)
![Task 6](<screenshots/week 10-assignment 05-screenshot 8.D.png>).


## Notes

### 1. What exact failure did you introduce?

[I introduced a controlled dependency-installation failure on the temporary drill/pipeline-failure branch by deliberately specifying an invalid application dependency. This caused the Application Pipeline to fail during dependency installation before any deployment changes were applied.]

### 2. Which category should detect it?

[The triage workflow should classify the incident as a Dependency Installation Failure because the relevant pipeline step failed while attempting to resolve or install the deliberately invalid dependency.]

### 3. Why is the failure safe and easily reversible?

[The failure is safe because it occurs before the deployment stage and does not modify Azure infrastructure, credentials, networking, database data, or the currently deployed application. It is easily reversible by restoring the dependency configuration to its previous valid value.]

### 4. How did you prevent the deliberate failure from reaching `main` or changing the deployed application?

[I created the failure on the temporary drill/pipeline-failure branch and did not merge the deliberate change into main. The failure was designed to occur during an early pipeline stage, preventing the workflow from reaching the deployment steps that could change the running EpicBook application.]

---

# Task 7 — Diagnose and Save the Incident Evidence

## Goal

Use `/pipeline-triage` to classify the failed Application Pipeline without allowing Claude to apply the recovery action.

## Evidence

### Screenshot 9 — Failed-State Diagnosis and Incident Report

`/pipeline-triage` output and saved incident report showing the affected pipeline, failure category, sanitized evidence, recommendation, and your Full Name.

![Task 7](<screenshots/week 10-assignment 05-screenshot 9.A.png>)
![Task 7](<screenshots/week 10-assignment 05-screenshot 9.B.png>).

## Notes

### 1. Which failure category was identified?

[Configuration/Validation Failure (Ansible/YAML syntax error). The Application Pipeline failed during the Validate Ansible stage because the controlled failure introduced invalid YAML syntax into the Ansible playbook. This prevented the validation step from completing and stopped the pipeline before the deployment stage could run.]

### 2. What exact evidence supported the diagnosis?

[The Azure DevOps console log and the generated pipeline triage report showed that the Application Pipeline had failed during the Validate Inventory and Playbook step. The Ansible syntax check reported an error caused by the intentionally invalid YAML line added to ansible/site.yml. The Infrastructure Pipeline remained successful, while the latest Application Pipeline run was reported as failed. This evidence isolated the incident to the Application Pipeline's Ansible validation stage and confirmed that the failure occurred before deployment.]

### 3. Did Claude apply the fix or rerun the pipeline? Why is that important?

[No. Claude diagnosed the incident and recommended a recovery action, but it did not edit the project, apply the fix, or rerun the pipeline. This preserves human control over production-facing CI/CD operations and ensures that the engineer reviews the evidence before making a change.]

### 4. Which part represents Gather, and which part represents Analyze?

[The Bash triage script represents the Gather stage because it retrieves the Azure DevOps pipeline metadata and console logs, checks the evidence, and produces the structured report. Claude represents the Analyze stage because it interprets the collected evidence, explains the likely cause, recommends a human action, and provides a verification step.]

---

# Task 8 — Apply the Human-Reviewed Fix and Verify Recovery

## Goal

Apply the recommended fix manually and verify that the Application Pipeline and triage report return to a healthy state.

## Evidence

### Screenshot 10 — Corrected Application Pipeline Run

Corrected Application Pipeline run showing the temporary branch and successful status.

![Task 8.A](<screenshots/week 10-assignment 05-screenshot 10.png>).

---

### Screenshot 11 — Recovery Triage Result

Recovery `/pipeline-triage` output showing Overall Status `HEALTHY`, exit code `0`, your Full Name, and both saved report filenames.

![Task 8.B](<screenshots/week 10-assignment 05-screenshot 11.A.png>)
![Task 8.B](<screenshots/week 10-assignment 05-screenshot 11.B.png>).

## Notes

### 1. What exact fix did you apply?

[I manually reversed the controlled dependency change on the temporary branch by restoring the correct application dependency configuration. I then committed and pushed the corrected version and ran the Application Pipeline again.]

### 2. Did the fix match Claude’s recommendation? Explain briefly.

[Yes. Claude's recommendation matched the evidence gathered from the failed pipeline. The failure was associated with the deliberately invalid dependency, so restoring the correct dependency configuration addressed the identified cause without requiring infrastructure or credential changes..]

### 3. What evidence proves that the pipeline recovered?

[The corrected Application Pipeline completed successfully on the temporary branch. Afterward, I ran /pipeline-triage again, and the generated report showed both pipelines as healthy, an Overall Status of HEALTHY, and exit code 0.]

### 4. Why is a second triage run required after the pipeline becomes green?

[A successful pipeline run provides evidence that execution completed, but the second triage run independently verifies that the monitored dual-pipeline environment has returned to the expected healthy state. It completes the Verify stage of the Gather → Analyze → Human Act → Verify workflow.]

### 5. What risk would be created if Claude could automatically edit, push, approve, and rerun the pipeline?

[Giving Claude all of those permissions would combine diagnosis and recovery authority in a single automated workflow. An incorrect diagnosis could therefore lead directly to an unintended code change or deployment without human review. Keeping triage read-only allows AI to assist with analysis while leaving consequential recovery decisions and actions under engineer control.]

---

# LinkedIn Post — Mandatory

## LinkedIn Post URL

[Paste your public LinkedIn post URL here.]

## Evidence

### Screenshot 12 — Published LinkedIn Post

Published LinkedIn post showing its text and at least one image or link.

![LinkedIn Post](<screenshots/week 10-assignment 05-screenshot 12.png>).

---

# Required Repository Files

Confirm that the following files are available in your repository:

* [-] `CLAUDE.md`
* [-] `pipeline-triage.sh`
* [-] `.claude/skills/pipeline-triage/SKILL.md`
* [-] `reports/incident-failure-report.txt`
* [-] `reports/recovery-report.txt`

---

# Submission Instructions

* Complete all tasks in sequence.
* Include all 12 required screenshots.
* Answer every Notes question in your own words.
* Include your GitHub repository or fork URL.
* Include your public LinkedIn post URL.
* Ensure your Full Name appears in the required reports.
* Do not include raw logs containing sensitive information.
* Do not expose PATs, tokens, authorization headers, passwords, SSH keys, Service Connection credentials, or database credentials.

---

# Completion Checklist

* [-] Both Azure DevOps pipelines were healthy before the drill.
* [-] The supplied files were copied to the correct repository locations.
* [-] Only the required student-specific placeholders were updated.
* [-] `CLAUDE.md` contains the required context and safety rules.
* [-] `pipeline-triage.sh` passed Bash syntax validation.
* [-] The script has executable permission.
* [-] The script uses read-only Azure DevOps operations.
* [-] The script retrieves pipeline metadata and console logs.
* [-] No token or password is stored in the script.
* [-] The healthy baseline reported `HEALTHY` with exit code `0`.
* [-] `/pipeline-triage` was invoked manually.
* [-] The skill does not have broad Bash approval.
* [-] The controlled failure affected only the Application Pipeline.
* [-] The failure occurred before deployment changes were applied.
* [-] The deliberate failure was not merged into `main`.
* [-] The failed-state report was saved before applying the fix.
* [-] Claude diagnosed the failure but did not apply the fix.
* [-] The fix was reviewed and applied manually.
* [-] The corrected Application Pipeline completed successfully.
* [-] The recovery triage reported `HEALTHY` with exit code `0`.
* [-] `incident-failure-report.txt` exists.
* [-] `recovery-report.txt` exists.
* [-] All Notes questions have been answered.
* [-] All 12 screenshots have been added.
* [-] The GitHub repository or fork URL has been included.
* [-] The LinkedIn post is public.
* [-] The LinkedIn post URL has been included.
* [-] No sensitive information is exposed.

---

# Final Submission

**Full Name:** [Peace Nwadinachi Offor]

**GitHub Repository or Fork URL:** [(https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra)]

**LinkedIn Post URL:** [(https://www.linkedin.com/posts/peace-offor-aa736a147_dmibypravinmishra-agenticai-claudecode-activity-7506502979869401089-AiDp?utm_source=share&utm_medium=member_desktop&rcm=ACoAACN4g58BM2OoiPOU_M6YmR_9gplw4hlL_RQ)]

---

*This submission is part of the DevOps Micro Internship (DMI) — Agentic AI Track.*
