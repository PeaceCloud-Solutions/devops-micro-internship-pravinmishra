# Assignment 6 — AI-Assisted Terraform Drift and Policy Review

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Peace Nwadinachi Offor  
**GitHub Repository/Folder URL:** (https://github.com/PeaceCloud-Solutions/devops-micro-internship-pravinmishra)

---

## Purpose

Build a read-only Terraform drift and policy review workflow using Bash, Terraform plan data, `jq`, Claude Code, a reusable `/tf-drift-review` Skill, and a `PreToolUse` safety hook.

The workflow must follow this pattern:

```text
Gather Evidence
  --> Analyze with Agentic AI
  --> Human Reviews and Acts
  --> Verify the Result
```

The `/tf-drift-review` Skill and `tf-drift-check.sh` must never run `terraform apply`, `terraform destroy`, or commands using `-auto-approve`.

---

# Task 1 — Confirm the Clean Baseline and Create the Workspace

## Goal

Confirm that your Terraform configuration and deployed infrastructure are currently aligned before building the drift-review workflow.

## Evidence

### Screenshot 1 — Clean Terraform Plan

Add a screenshot of `terraform plan` showing no pending changes.

![Task 1.A](<screenshots/week 08-assignment 06-screenshot 1.png>).

---

### Screenshot 2 — Assignment Workspace

Add a screenshot of the folder structure showing `AI Assignment/`, `reports/`, and the Terraform project.

![Task 1.B](<screenshots/week 08-assignment 06-screenshot 2.png>).

## Questions

### 1. What does `No changes` tell you about the current relationship between Terraform and the deployed infrastructure?

No changes means that Terraform's current configuration is aligned with the deployed AWS infrastructure represented by its state. Terraform has compared the desired configuration with the current infrastructure and does not propose creating, modifying, or destroying any managed resources. This provides evidence that the environment is currently in its intended state.

### 2. Why is a clean baseline important before introducing a test change?

starting point for the drift-review exercise. If there are no existing pending changes before the controlled test is introduced, any difference detected afterward can be associated with the intentional test change rather than an unrelated or previously unresolved configuration difference. This makes the evidence easier to interpret and the review more reliable.

---

# Task 2 — Create Project Context and Safety Rules in `CLAUDE.md`

## Goal

Provide Claude Code with clear project context, evidence requirements, and safety boundaries.

## Evidence

### Screenshot 3 — Project Context and Safety Rules

Add a screenshot of `CLAUDE.md` open in VS Code showing the Project Overview, Review Workflow, Safety Rules, and Output Rules.

![Task 2](<screenshots/week 08-assignment 06-screenshot 3.png>).

## Questions

### 1. Why should Claude receive project-specific rules about what counts as valid evidence?

Claude should receive project-specific evidence rules so that its conclusions are based on verifiable information from the actual Terraform project rather than assumptions. These rules define which sources, such as Terraform plan output, plan JSON, and generated drift reports, should be used when assessing the infrastructure. This makes the review more consistent, traceable, and evidence-based.

### 2. Why must the human remain responsible for running `terraform apply`?

The human must remain responsible for terraform apply because the command can make real changes to cloud infrastructure. Those changes could affect security, availability, cost, or even cause resource replacement or deletion. Keeping terraform apply under human control ensures that the Terraform plan, identified risks, and AI recommendations are reviewed before any infrastructure-changing action is authorized.

### 3. Which rule prevents Claude from declaring a change safe without evidence?

The rule that I placed in the Claude.md: Do not declare infrastructure safe without Terraform plan evidence.

---

# Task 3 — Build the Terraform Drift and Policy Check Script

## Goal

The rule in my CLAUDE.md that prevents this is: "Do not declare infrastructure safe without Terraform plan evidence".
This rule requires Claude to base its safety assessment on actual Terraform evidence rather than making an unsupported assumption about the infrastructure.

## Evidence

### Screenshot 4 — Script Variables and Checks Array

Add a screenshot of the top section of `tf-drift-check.sh` showing the variables and `checks` array.

![Task 3.A](<screenshots/week 08-assignment 06-screenshot 4.png>).

---

### Screenshot 5 — Destructive-Action and Open-Ingress Checks

Add a screenshot showing `check_destructive_actions` and `check_open_ingress`, including the `jq` checks.

![Task 3.B](<screenshots/week 08-assignment 06-screenshot 5.png>).

---

### Screenshot 6 — Script Validation and Permissions

Add a screenshot showing successful `bash -n` and `ls -l` output.

![Task 3.C](<screenshots/week 08-assignment 06-screenshot 6.png>).

## Questions

### 1. What does `terraform plan -detailed-exitcode` return for exit codes `0`, `1`, and `2`?

When terraform plan -detailed-exitcode is used, exit code 0 means Terraform completed the plan successfully and detected no pending changes. Exit code 1 means Terraform encountered an error while creating the plan. Exit code 2 means the plan completed successfully but Terraform detected pending infrastructure changes. These distinct exit codes allow the script to determine the result programmatically.

### 2. Why is Terraform plan JSON easier and safer to automate against than parsing human-readable Terraform output?

Terraform plan JSON provides structured, machine-readable data with predictable fields that tools such as jq can query directly. Human-readable Terraform output is primarily designed for people and its formatting may be more difficult or unreliable for scripts to interpret. Using structured JSON therefore makes automated policy checks more precise, repeatable, and less dependent on text formatting.

### 3. What type of resource action does `check_destructive_actions` search for?

The check_destructive_actions function searches the Terraform plan for resource changes containing a delete action. A detected deletion is treated as important evidence because it indicates that applying the plan could remove an existing managed resource.

### 4. Why does finding a `delete` action also help detect replacements?

A Terraform replacement generally requires the existing resource to be destroyed and a new resource to be created. Therefore, a replacement can contain both delete and create actions in the Terraform plan. By checking for delete, the script can identify not only straightforward resource deletions but also potentially destructive replacement operations that require additional human review.

### 5. Why must this script never run `terraform apply`?

The script must never run terraform apply because its purpose is to gather and analyze evidence, not to change infrastructure. Allowing the same automated script to both identify a risk and execute the proposed infrastructure change would remove the separation between analysis and action. Keeping terraform apply outside the script preserves the human approval step, allowing an engineer to review the plan, assess security and operational risks, and decide whether the proposed change should actually be executed..

---

# Task 4 — Run the Script Against the Clean Baseline

## Goal

Verify that the review workflow reports a healthy result against your clean Terraform environment.

## Evidence

### Screenshot 7 — Healthy Baseline Report

Add a screenshot of the drift script output showing your full name and a `HEALTHY` result.

![Task 4.A](<screenshots/week 08-assignment 06-screenshot 7.png>).

---

### Screenshot 8 — Baseline Script Exit Code

Add a screenshot showing the captured script exit code `0`.

![Task 4.B](<screenshots/week 08-assignment 06-screenshot 8.png>).

## Questions

### 1. What is the Overall Status of your baseline?

The overall status of my baseline was HEALTHY. This means the Terraform configuration was aligned with the deployed infrastructure, and the drift-review workflow did not detect any pending, destructive, or unsafe changes.

### 2. Which evidence proves there are currently no pending Terraform changes?

The terraform plan output showed “No changes. Your infrastructure matches the configuration.” In addition, the drift-check script returned Terraform detailed exit code 0 and an overall status of HEALTHY. Together, these results confirm that there were no pending Terraform changes.

### 3. Was `reports/tfplan.json` created? Explain why or why not.

No, reports/tfplan.json was not created. The clean baseline caused terraform plan -detailed-exitcode to return exit code 0, which means Terraform detected no pending changes. The script only generates tfplan.json when Terraform returns exit code 2, indicating that changes are pending and need further analysis.

---

# Task 5 — Create and Run the `/tf-drift-review` Claude Code Skill

## Goal

Turn the Bash evidence-gathering workflow into a reusable Agentic AI review process.

## Evidence

### Screenshot 9 — `/tf-drift-review` Skill Configuration

Add a screenshot of `SKILL.md` showing the frontmatter, allowed tools, and safety rules.

![Task 5.A](<screenshots/week 08-assignment 06-screenshot 9.png>).

---

### Screenshot 10 — Clean Agentic AI Review

Add a screenshot of `/tf-drift-review` showing the clean `HEALTHY` result.

![Task 5.B](<screenshots/week 08-assignment 06-screenshot 10.png>).

## Questions

### 1. Why does this Skill have `Bash`, `Read`, and `Grep`, but not `Write`?

The Skill is intended to gather and analyze evidence, not modify infrastructure or project files. Removing Write helps preserve its read-only review role.

### 2. Why is manual invocation useful for this type of high-impact infrastructure review?

Manual invocation keeps the high-impact infrastructure review intentional and gives me control over when evidence is gathered and analyzed.

### 3. Which part of the workflow is deterministic Bash automation?

Creating the Terraform plan, converting it to JSON, checking defined conditions with jq, and producing status results are deterministic Bash automation.

### 4. Which part requires Claude's reasoning?

Claude interprets the evidence, explains the significance of detected changes, assesses risk, and recommends what the human should investigate or do next.

### 5. Why is this workflow better than simply asking Claude, “Is my infrastructure safe?”

The workflow bases Claude's conclusions on real Terraform evidence and deterministic policy checks instead of asking it to make a general judgement without inspecting the environment.

---

# Task 6 — Introduce a Controlled Difference and Detect It

## Goal

Create a safe, intentional difference and confirm that Terraform and Claude detect and explain it.

## Evidence

### Screenshot 11 — Controlled Difference

Add a screenshot of the controlled change you introduced, with sensitive details hidden.

![Task 6.A](<screenshots/week 08-assignment 06-screenshot 11.png>).

---

### Screenshot 12 — Detected Difference and Risk Assessment

Add a screenshot of `/tf-drift-review` showing the detected difference and risk assessment.

![Task 6.B](<screenshots/week 08-assignment 06-screenshot 12.png>).

---

### Screenshot 13 — Detected Drift Report

Add a screenshot of `drift-detected-report.txt` showing your full name and the `WARN` or `FAIL` result.

![Task 6.C](<screenshots/week 08-assignment 06-screenshot 13.png>).

## Questions

### 1. What change did you introduce?

I intentionally introduced a controlled change to a restricted SSH ingress rule in my Terraform configuration. I temporarily changed the allowed CIDR source from a restricted trusted source to 0.0.0.0/0. This meant that the proposed Terraform configuration would allow SSH access from any IPv4 address on the internet. The change existed only in the Terraform code and was never applied to the deployed AWS infrastructure.

### 2. Was it true infrastructure drift or a Terraform configuration change?

It was a Terraform configuration change, not true infrastructure drift. I manually modified the Terraform code while leaving the existing AWS infrastructure unchanged. Since I did not run terraform apply, the deployed security group in AWS retained its original secure configuration. The difference occurred because the desired configuration in Terraform had changed, rather than because someone had manually modified the AWS resource outside Terraform.

### 3. What Terraform plan evidence proves that a change is pending?

The Terraform plan showed that an update to the affected security-group rule was pending. When I ran terraform plan -detailed-exitcode, Terraform returned exit code 2. In Terraform's detailed exit-code behavior, this indicates that the plan completed successfully but detected changes between the current infrastructure and the proposed Terraform configuration. This provided clear evidence that a change was pending but had not yet been applied.

### 4. Was the action an update, deletion, replacement, or security-rule change?

The proposed action was an in-place update to a security-group ingress rule. Specifically, it was a security-rule change that would have modified the permitted source of SSH traffic. It did not require deleting or replacing the AWS resource.

### 5. What did Claude recommend?

After reviewing the Terraform plan and drift-check evidence, Claude recommended that I not apply the unsafe ingress change. The proposed 0.0.0.0/0 rule would unnecessarily expose SSH access to the public internet. Claude therefore recommended restoring the Terraform configuration to its intended restricted and trusted source before proceeding.

### 6. Why should you review the recommendation before taking action?

AI recommendations should be reviewed because an AI system may not have complete knowledge of the environment, business requirements, security policies, or operational consequences of a proposed action. Human review allows the engineer to verify the evidence, understand the reason for the detected difference, evaluate the potential security and availability impact, and determine whether the recommended action is appropriate. This is especially important with Terraform because actions such as terraform apply can make real changes to cloud infrastructure.

---

# Task 7 — Add a `PreToolUse` Hook to Block Unsafe Apply Attempts

## Goal

Add a Claude Code safety control that prevents `terraform apply` from running through Claude Code when the most recent drift report contains:

```text
Overall Status: FAIL
```

## Evidence

### Screenshot 14 — `PreToolUse` Safety Hook

Add a screenshot of `.claude/settings.json` showing the `PreToolUse` safety hook.

![Task 7.A](<screenshots/week 08-assignment 06-screenshot 14.A.png>).
![Task 7.A](<screenshots/week 08-assignment 06-screenshot 14.B.png>).

---

### Screenshot 15 — Blocked Apply Attempt

Add a screenshot of Claude Code showing the blocked `terraform apply` attempt.

![Task 7.B](<screenshots/week 08-assignment 06-screenshot 15.png>).

## Questions

### 1. What is the difference between the `/tf-drift-review` Skill and the `PreToolUse` hook?

The /tf-drift-review Skill is responsible for gathering and interpreting evidence from the Terraform plan, drift report, and JSON plan data. It helps Claude analyze the proposed infrastructure changes and provide a recommendation. The PreToolUse hook, on the other hand, is an enforcement mechanism. It checks the existing review result before a potentially dangerous command such as terraform apply is allowed to execute. Therefore, the Skill performs review and analysis, while the hook provides an automated safety gate.

### 2. Which component performs analysis?

The /tf-drift-review Skill, together with Claude Code, performs the analysis. It reviews the evidence produced by Terraform and the drift-check script, identifies potential risks such as destructive changes or unsafe ingress rules, and recommends an appropriate human action.

### 3. Which component enforces the safety gate?

The PreToolUse hook enforces the safety gate. It runs before the relevant tool command and checks the latest drift report. If the defined unsafe condition is present, such as Overall Status: FAIL, the hook blocks the attempted terraform apply before Terraform can make infrastructure changes.

### 4. Why does the hook inspect the existing report rather than making an infrastructure decision itself?

The hook inspects the existing report because its purpose is enforcement rather than infrastructure analysis. The drift-review workflow has already gathered and analyzed the evidence. The hook can therefore make a simple, deterministic decision based on a known condition in the report. This separation keeps complex reasoning in the review stage and makes the enforcement mechanism simpler and more predictable.

### 5. Why is a deterministic guard useful for high-impact commands?

A deterministic guard is useful because high-impact commands such as terraform apply can create, modify, or delete real cloud resources. The guard follows a predefined rule and produces the same allow-or-block result whenever the same condition occurs. This reduces the risk of an AI agent making an inconsistent or unsafe decision when executing infrastructure-changing commands.

---

# Task 8 — Resolve the Difference and Verify the Final State

## Goal

Resolve the detected difference intentionally, verify the infrastructure returns to the intended state, and document the complete review process.

## Evidence

### Screenshot 16 — Human-Reviewed Resolution

Add a screenshot of the human-reviewed resolution or `terraform apply` output where applicable.

![Task 8.A](<screenshots/week 08-assignment 06-screenshot 16.png>).

---

### Screenshot 17 — Final Healthy Review

Add a screenshot of the final `/tf-drift-review` showing `HEALTHY`.

![Task 8.B](<screenshots/week 08-assignment 06-screenshot 17.png>).

---

### Screenshot 18 — Saved Reports

Add a screenshot of `ls -lah reports` showing both:

- `drift-detected-report.txt`
- `resolved-report.txt`

![Task 8.C](<screenshots/week 08-assignment 06-screenshot 18.png>).

---

### Screenshot 19 — Drift Review Summary

Add a screenshot of `drift-review-summary.md` showing all required sections and your full name.

![Task 8.D](<screenshots/week 08-assignment 06-screenshot 19.A.png>).
![Task 8.D](<screenshots/week 08-assignment 06-screenshot 19.B.png>).

## Terraform Drift Review Summary

### 1. Change Introduced

Explain the controlled change you introduced.

State whether it was:

- True infrastructure drift, or
- A Terraform configuration change

I intentionally modified a restricted SSH security-group ingress rule in the Terraform configuration so that the proposed CIDR changed from a restricted source to 0.0.0.0/0.

This was a Terraform configuration change rather than true infrastructure drift because I changed only the Terraform code. I did not run terraform apply, so the deployed AWS infrastructure was never modified to allow the unsafe public SSH access.

### 2. Evidence Collected

Describe the Terraform plan evidence and affected resource.

I used terraform plan and the Terraform JSON plan to examine the proposed infrastructure changes. Terraform detected a pending in-place update to the affected security-group configuration. The drift-check Bash script analyzed the plan using jq and identified the proposed unrestricted ingress rule.

The detailed Terraform plan exit code also provided evidence that a change was pending. The affected resource was a security-group ingress configuration, and the proposed change would have allowed SSH access from 0.0.0.0/0.

### 3. Risk Assessment

Explain the risk identified by the Bash check and Claude Code.

The proposed configuration represented a security risk because 0.0.0.0/0 would allow SSH connection attempts from any IPv4 address on the internet. The Bash policy check detected the unsafe ingress condition, and Claude Code reviewed the evidence and recommended that the insecure configuration should not be applied.

This demonstrated that the workflow could identify a potentially unsafe infrastructure change before it reached AWS.

### 4. Human-Approved Action

Explain the action you reviewed and executed manually.

After reviewing the Terraform plan, drift report, and Claude Code recommendation, I decided not to apply the proposed insecure configuration.

I manually restored the Terraform security-group configuration to its original restricted value. Because the insecure change had never been applied to AWS, no infrastructure-changing terraform apply command was necessary to resolve the controlled difference.

### 5. Verification

Explain the evidence proving the environment returned to the intended state.

After restoring the secure Terraform configuration, I ran terraform fmt -recursive and terraform validate to verify that the configuration remained correctly formatted and syntactically valid.

I then generated another Terraform plan and confirmed that the infrastructure matched the intended Terraform configuration with no pending changes. Finally, I reran the drift-check script and /tf-drift-review. The final review returned Overall Status: HEALTHY, providing evidence that the environment had returned to its intended state.

### 6. Safety Decision

Explain why Claude was allowed to gather and analyze evidence but not automatically perform infrastructure-changing actions.

Claude Code was allowed to gather evidence, analyze the Terraform plan, identify security risks, and recommend an appropriate response. However, it was not given unrestricted authority to execute infrastructure-changing actions automatically.

Commands such as terraform apply and terraform destroy can create, modify, or remove real cloud resources and may have security, availability, and cost consequences. Keeping these actions under human control ensures that the evidence and AI recommendation are reviewed before a high-impact change is made.

### 7. Agentic Loop Mapping

Explain how your workflow followed:

```text
Gather --> Analyze --> Human Act --> Verify
```

The workflow followed the Gather --> Analyze --> Human Act --> Verify agentic loop.

Gather: Terraform generated the plan and JSON plan data, while the Bash drift-check script collected policy evidence about pending changes, destructive actions, and unsafe ingress.

Analyze: Claude Code and the /tf-drift-review Skill reviewed the collected evidence, identified the proposed public SSH ingress as unsafe, and recommended that it should not be applied.

Human Act: I reviewed the evidence and recommendation and manually restored the secure Terraform configuration instead of applying the unsafe proposed change.

Verify: I reran Terraform validation, planning, the drift-check script, and the Claude review to confirm that there were no remaining pending changes and that the final status returned to HEALTHY.

## Questions

### 1. What action did you execute to resolve the difference?

I manually restored the intentionally modified security-group ingress rule in the Terraform configuration to its original restricted value. I did not run terraform apply because the unsafe configuration had never been applied to AWS. Restoring the Terraform code was therefore sufficient to resolve the controlled difference.

### 2. Did you review `terraform plan` before taking action?

Yes. I reviewed the Terraform plan before taking action to understand exactly what Terraform intended to change. The plan showed a pending security-group update, which allowed me to confirm that the difference was caused by the intentional Terraform configuration modification rather than an unexpected infrastructure change.

### 3. What evidence proves the environment is now aligned?

The final Terraform plan showed no pending infrastructure changes and indicated that the deployed infrastructure matched the Terraform configuration. I also reran the drift-check workflow, which returned Overall Status: HEALTHY, and saved the final result as resolved-report.txt. Together, these results provide evidence that the Terraform configuration and deployed environment were aligned again.

### 4. Why is a second drift review required after the fix?

A second drift review is required because making a correction does not by itself prove that the problem has been resolved. The final review independently verifies that the unsafe proposed change has disappeared, no additional unexpected differences remain, and the environment has returned to the intended healthy state.

### 5. What could go wrong if an AI agent automatically applied every detected Terraform change?

Automatically applying every detected change could result in insecure configurations, accidental resource deletion or replacement, service outages, unexpected costs, data loss, or unauthorized network exposure. A detected difference does not automatically mean that applying the Terraform plan is the correct solution. Human review is necessary to understand why the difference exists, assess its impact, and decide on the safest corrective action.

### 6. In one sentence, explain the difference between asking an AI chatbot “Is my infrastructure okay?” and using this evidence-based Agentic AI workflow.

Asking an AI chatbot whether infrastructure is okay relies mainly on the information provided in the conversation, whereas this evidence-based Agentic AI workflow gathers real Terraform plan and policy evidence, analyzes that evidence, applies deterministic safety controls, requires human approval for high-impact actions, and verifies the final state.

---

# LinkedIn Post — Mandatory

## Goal

Publish a LinkedIn post in your own words describing:

- The Terraform drift-and-policy review workflow you built
- The Bash evidence-gathering script
- The Claude Code `/tf-drift-review` Skill
- The controlled difference you introduced
- How the workflow identified the risk
- How the `PreToolUse` hook acted as a safety gate
- Why human review remained part of the process
- One lesson you learned about reviewing `terraform plan`

Include a screenshot of the detected change and a screenshot of the final `HEALTHY` review in your post.

Suggested tags:

```text
#DMIByPravinMishra #Terraform #AgenticAI #ClaudeCode #DevOps
```

## LinkedIn Evidence

### LinkedIn Post URL

[Linkedin Post URL](https://lnkd.in/p/eJuYYE9i).

### Published LinkedIn Post Screenshot — Mandatory

![Linkedin Post](<screenshots/week 08-assignment 06-screenshot 20.png>).

---

# Required Assignment Files

Confirm that the following files are included in your GitHub repository:

- `CLAUDE.md`
- `AI Assignment/tf-drift-check.sh`
- `.claude/skills/tf-drift-review/SKILL.md`
- `.claude/settings.json` containing the safety hook
- `reports/drift-detected-report.txt`
- `reports/resolved-report.txt`
- `drift-review-summary.md`

---

# Submission Instructions

- Complete Tasks 1–8 in sequence.
- Include Screenshots 1–19 exactly as specified.
- Answer every question under Tasks 1–8 in your own words.
- Complete all seven sections of the Terraform Drift Review Summary.
- Include the GitHub repository/folder URL containing the assignment files.
- Include your full name in the required reports and screenshots.
- Include the LinkedIn post URL and a screenshot of the published LinkedIn post.
- Do not expose access keys, passwords, tokens, account IDs, private keys, Terraform secrets, or other sensitive information.
- Review all screenshots carefully and hide or redact sensitive details where necessary.

---

# Completion Checklist

- [-] Confirmed a clean Terraform baseline
- [-] Created the required assignment workspace
- [-] Created or updated `CLAUDE.md`
- [-] Added project context and safety rules
- [-] Created `tf-drift-check.sh`
- [-] Added my full name to the report
- [-] Validated the Bash script
- [-] Made the script executable
- [-] Used `terraform plan -detailed-exitcode`
- [-] Used Terraform plan JSON
- [-] Used `jq` to inspect destructive actions
- [-] Used `jq` to inspect unsafe ingress
- [-] Confirmed the baseline returns `HEALTHY`
- [-] Created `/tf-drift-review`
- [-] Restricted the Skill to appropriate tools
- [-] Confirmed the Skill remains read-only
- [-] Confirmed the Skill never runs `terraform apply`
- [-] Confirmed the Skill never runs `terraform destroy`
- [-] Introduced a controlled detectable difference
- [-] Correctly identified whether it was true drift or a configuration change
- [-] Saved `drift-detected-report.txt`
- [-] Added the `PreToolUse` safety hook
- [-] Verified the hook blocks `terraform apply` when the report is `FAIL`
- [-] Reviewed the Terraform evidence before resolving the change
- [-] Performed any infrastructure-changing action manually
- [-] Ran the drift review again after resolution
- [-] Confirmed the final status is `HEALTHY`
- [-] Saved `resolved-report.txt`
- [-] Completed `drift-review-summary.md`
- [-] Mapped the workflow to `Gather --> Analyze --> Human Act --> Verify`
- [-] Included all 19 numbered screenshots
- [-] Answered all required questions
- [-] Published the required LinkedIn post
- [-] Added the LinkedIn post URL and screenshot
- [-] Included the GitHub repository/folder URL
- [-] Confirmed that no sensitive information is exposed

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
