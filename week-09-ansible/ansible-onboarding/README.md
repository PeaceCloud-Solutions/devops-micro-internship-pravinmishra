# Ansible Development Workstation

**Name:** Peace Nwadinachi Offor

## Project Summary

This project documents the setup of my team-ready Ansible development workstation for the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI.

The workstation uses a Python virtual environment to isolate Ansible and its supporting tools from the system Python environment. It also includes VS Code configuration, SSH key authentication, Git configuration, YAML and Ansible linting, and pre-commit hooks.

## Tools Installed

- Ansible
- ansible-lint
- yamllint
- pre-commit
- Python virtual environment
- Visual Studio Code
- Git
- OpenSSH

## Project Structure

- `.venv/` — isolated Python virtual environment
- `.vscode/` — VS Code workspace configuration
- `inventories/` — Ansible inventory files
- `roles/` — reusable Ansible roles
- `ansible.cfg` — project Ansible configuration
- `.editorconfig` — consistent editor formatting
- `.gitignore` — excludes local and sensitive files
- `requirements.txt` — Python package requirements

## New Machine? Do This

1. Clone or copy the Ansible workspace.
2. Open the project in WSL.
3. Create a Python virtual environment:
   `python3 -m venv .venv`
4. Activate the virtual environment:
   `source .venv/bin/activate`
5. Install the required packages:
   `python -m pip install -r requirements.txt`
6. Install the required VS Code extensions.
7. Configure your SSH ED25519 key.
8. Start the SSH agent and add your private key.
9. Configure your Git name and email.
10. Install the pre-commit hook:
    `pre-commit install`
11. Run:
    `pre-commit run --all-files`
12. Verify Ansible with:
    `ansible --version`

## Verification

The workstation is ready when:

- Ansible uses the project's `.venv`.
- `ansible.cfg` is detected from the project directory.
- The ED25519 SSH key is loaded into the SSH agent.
- YAML and Ansible linting are available.
- Pre-commit checks complete successfully.
- Sensitive files and `.venv/` are excluded from Git.
