---
name: sprint-health
description: Analyze the current active Jira sprint and produce a read-only sprint health report.
allowed-tools: Read, mcp__jira__jira_get_agile_boards, mcp__jira__jira_get_sprints_from_board, mcp__jira__jira_get_sprint_issues, mcp__jira__jira_get_board_issues, mcp__jira__jira_get_issue, mcp__jira__jira_get_issue_dates, mcp__jira__jira_get_project_issues, mcp__jira__jira_search, mcp__jira__jira_get_project_fields, mcp__jira__jira_search_fields
disable-model-invocation: true
---

name: sprint-health
description: Analyze the current active Jira sprint and produce a read-only sprint health report.
allowed-tools: Read, mcp__jira__jira_get_agile_boards, mcp__jira__jira_get_sprints_from_board, mcp__jira__jira_get_sprint_issues, mcp__jira__jira_get_board_issues, mcp__jira__jira_get_issue, mcp__jira__jira_get_issue_dates, mcp__jira__jira_get_project_issues, mcp__jira__jira_search, mcp__jira__jira_get_project_fields, mcp__jira__jira_search_fields
disable-model-invocation: true
---

# Sprint Health Report

Produce a read-only health report for the current active Jira sprint.

This skill must only read Jira data. Never create, update, transition, delete, or comment on an issue.

## Steps

1. Find the current active sprint using the available read-only Jira tools.
2. Retrieve the issues in the active sprint.
3. For each relevant issue, examine:
   - Issue key
   - Summary
   - Issue type
   - Status
   - Story point estimate

## Analyze Sprint Health

Produce a report containing:

### Sprint Velocity / Progress
Report:
- Total estimated story points
- Completed story points
- Remaining story points

### At-Risk Stories
Identify incomplete stories that may put the sprint goal at risk.
Explain why each is considered at risk using only information available from Jira.

### Missing Estimates
List stories that do not have a story point estimate.

### Recommended Human Actions
Recommend actions the Scrum Master or team may consider.

Do not make any Jira changes. All board-changing actions must remain human-controlled.