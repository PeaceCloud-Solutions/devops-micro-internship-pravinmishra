# Assignment 5 — AI-Assisted Sprint Health Report via Jira MCP

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will connect Claude Code to your Jira board through an MCP server, the same way you connected it to GitHub in Week 2, and build a read-only `/sprint-health` skill. The skill reads your current sprint through Jira's API and reports sprint velocity, stories at risk of missing the sprint, and items missing an estimate — but it must never create, edit, comment on, or transition a single ticket itself. You will prove that boundary holds by making a real change on the board yourself and confirming the skill only ever reports, never acts.

---

# Task 1 — Create a Jira API Token

## Goal

Generate an API token from your Atlassian account that the MCP server will use to authenticate with your Jira site. Do not screenshot the token value itself.

### Evidence

#### Screenshot 1 — Jira API token creation confirmation page showing the token name, with the token value not visible

![Task 1](<screenshots/week 05-assignment 05-screenshot 1.png>).

### Notes You Must Write (Very Important):

Why does the MCP server need your site URL and account email in addition to the token?

The Jira MCP server needs the site URL to know which Jira Cloud instance it should connect to, while the account email identifies the Atlassian user making the request. The API token acts as the authentication credential instead of the account password. Together, the site URL, email, and API token allow the MCP server to authenticate securely and access the Jira data that the account is permitted to view.

---

# Task 2 — Create .mcp.json at the Project Root

## Goal

Create or update `.mcp.json` at your project root with a Jira MCP server block, following the same shape as the GitHub MCP server you configured in Week 2.

### Evidence

#### Screenshot 2 — `.mcp.json` open in VS Code showing the Jira server configuration

![Task 2](<screenshots/week 05-assignment 05-screenshot 2.png>).

### Notes You Must Write (Very Important):

Compare this jira block to the github block from Week 2 Assignment 5. The GitHub server ran via npx (a Node.js package); this one runs via uvx (a Python package) — what stays exactly the same shape despite that difference, and why doesn't Claude Code care which language a given MCP server is written in?

Add your answer here

---

# Task 3 — Add Your Credentials to settings.local.json

## Goal

Add your Jira site URL, account email, and API token to `.claude/settings.local.json`, and confirm that file is listed in `.gitignore` so it is never committed.

### Evidence

#### Screenshot 3 — `settings.local.json` open in VS Code showing the `env` section, with the actual token value blurred or covered

![Task 3](<screenshots/week 05-assignment 05-screenshot 3.png>).

### Notes You Must Write (Very Important):

Why must JIRA_API_TOKEN live in settings.local.json and never in .mcp.json?

JIRA_API_TOKEN is a sensitive credential that can authenticate API requests to my Jira account. It belongs in settings.local.json because that file is local to my development environment and is excluded from Git. Keeping the token out of .mcp.json prevents it from being accidentally committed and exposed through GitHub. The MCP configuration should describe how the Jira server runs, while sensitive authentication values remain in a private local configuration file.

---

# Task 4 — Verify the Connection with /mcp

## Goal

Restart Claude Code and confirm the Jira MCP server shows as connected.

### Evidence

#### Screenshot 4 — `/mcp` output showing `jira: connected`

![Task 4](<screenshots/week 05-assignment 05-screenshot 4.png>).

---

# Task 5 — Run a Live Query to Prove Real Board Data

## Goal

Ask Claude to list the issues in your current active sprint through the Jira MCP connection, and confirm the result matches what you see on your live board in the browser.

### Evidence

#### Screenshot 5 — Claude's response showing the live sprint issue list retrieved via Jira MCP

![Task 5](<screenshots/week 05-assignment 05-screenshot 5.png>).

### Notes You Must Write (Very Important):

How did you confirm this was real board data and not something Claude guessed?

I confirmed that the results were real board data by comparing Claude's Jira MCP response with the active sprint displayed directly in Jira. I checked the sprint name, issue keys, story summaries, statuses, and estimates against the live board. The values matched the current Jira state. Claude retrieved the information through the connected Jira MCP tools rather than relying on previously supplied issue information or guessing the board contents.


---

# Task 6 — Build the /sprint-health Skill

## Goal

Create a `/sprint-health` skill restricted to read-only Jira tools plus `Read`, with no issue-mutating tools and no `Write`. Run it and confirm it produces a report covering sprint velocity, at-risk stories, and items missing an estimate.

### Evidence

#### Screenshot 6 — `SKILL.md` frontmatter showing `allowed-tools` limited to read-only Jira tools plus `Read`, with `disable-model-invocation: true`

![Task 6.A](<screenshots/week 05-assignment 05-screenshot 6.png>).

#### Screenshot 7 — `/sprint-health` output showing the full triage report against your real sprint

![Task 6.B](<screenshots/week 05-assignment 05-screenshot 7.png>).

### Notes You Must Write (Very Important):

1. Which Jira MCP tools does this skill's allowed-tools list include, and which mutating tools (create issue, update issue, transition issue, add comment) does it deliberately exclude?

The `/sprint-health` skill allows only `Read` and the Jira MCP tools required to retrieve sprint, board, and issue information. It deliberately excludes all Jira tools capable of changing board state, including create issue, update issue, transition issue, and add comment operations. It also excludes the `Write` tool. This ensures that `/sprint-health` can gather and analyze Jira information but cannot modify either the Jira board or local project files.


2. Why does a Scrum Master need this restriction more than almost any other role in this course?

A Scrum Master needs this restriction because sprint-health analysis should provide visibility without silently changing the team's source of truth. The Scrum Master's role is to facilitate the process, identify risks, expose blockers, and help the team make informed decisions. An AI assistant that can automatically transition tickets, change estimates, create issues, or add comments during analysis could alter sprint data without the team's agreement. Restricting the skill to read-only tools preserves transparency and keeps board-changing decisions under human control.

---

# Task 7 — Prove the Skill Never Mutates the Board

## Goal

Manually update one ticket on your board in the browser (for example, move a story to "Done" or add a missing estimate), then run `/sprint-health` again and confirm the new report reflects your change — proving the skill only ever reads live state and never wrote to the board itself.

### Evidence

#### Screenshot 8 — Second `/sprint-health` run showing the report now reflects your manual board change

![Task 7](<screenshots/week 05-assignment 05-screenshot 8.png>).

### Notes You Must Write (Very Important):

Map this assignment to Gather → Analyze → Human Act → Verify from Week 3 Assignment 6. Which step did you perform manually in the browser, and why must that step stay human?

It is important to know that this assignment follows the Gather - Analyze - Human Act - Verify pattern.

Gather: /sprint-health used the read-only Jira MCP tools to retrieve the current sprint and issue data.

Analyze: Claude analyzed the retrieved information to report sprint progress, at-risk stories, and issues with missing estimates.

Human Act: I manually changed a ticket on the live Jira board in the browser. This step remained human because changing issue status or estimates modifies the team's shared source of truth and should require deliberate human judgement and accountability.

Verify: I ran /sprint-health again. The new report retrieved the updated Jira state and reflected my manual change, demonstrating that the skill reads live board data but does not mutate the board itself.

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 8 required screenshots
- All the required notes

---

# Completion Checklist

- [-] Task 1: Jira API token created, value never screenshotted (Screenshot 1)
- [-] Task 2: `.mcp.json` has the Jira server block (Screenshot 2)
- [-] Task 3: Credentials stored in `settings.local.json`, token blurred, file gitignored (Screenshot 3)
- [-] Task 4: `/mcp` shows the Jira server connected (Screenshot 4)
- [-] Task 5: Live query returned real sprint data, verified against the browser (Screenshot 5)
- [-] Task 6: `/sprint-health` skill created with correct read-only `allowed-tools`, and produced a full report (Screenshots 6–7)
- [-] Task 7: A manual board change was reflected in a second `/sprint-health` run (Screenshot 8)
- [-] Skill never created, edited, transitioned, or commented on any issue
- [-] Reflection answered (Notes)
- [-] No API token value exposed

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
