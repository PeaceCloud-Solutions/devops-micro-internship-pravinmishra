---
name: pr-ready
description: Review staged Git changes for PR readiness and draft a Pull Request title and description.
allowed-tools: Bash, Read, Grep
disable-model-invocation: true
---

# PR Ready Review

Review only the currently staged Git changes.

## Safety boundaries

- Do not edit, create, or delete files.
- Do not run `git add`.
- Do not run `git commit`.
- Do not run `git push`.
- Do not open or modify a Pull Request.
- Do not change branches, remotes, Git history, or the staging area.
- Use tools only to inspect the repository.

## Gather

Inspect the staged work using commands such as:

```bash
git branch --show-current
git status --short
git diff --cached --stat
git diff --cached
git diff --cached --check
```

Read staged files when additional context is necessary.

## Analyze

Review the staged changes for:

- Secret-like values or credentials
- Debug statements such as `console.log`
- Unexpected or oversized files
- Unrelated changes mixed into one commit
- Unclear intent or missing context
- Formatting, syntax, or documentation problems
- Anything requiring human review before a Pull Request

## Required output

### PR Readiness

Return one status:

- READY
- REVIEW NEEDED
- BLOCKED

### Risk Report

For every concern, state:

- File
- Issue
- Why it matters
- Recommended human action

Clearly state when no risks are found.

### Draft Pull Request Title

Provide one concise title.

### Draft Pull Request Description

Include:

- Summary
- Changes made
- Validation performed
- Risks or reviewer notes

### Human Next Steps

Remind the user to review the report and personally perform all file changes, commits, pushes, and Pull Request actions.