# Lesson 9: Copilot Setup and Safety

## Why This Comes After HCI

AI can help write code, but it does not automatically know what a coach needs.
Your observation, problem statement, sketch, and test evidence provide the
direction. AI is an implementation assistant—not the designer or decision
maker.

Copilot is optional. Follow your school policy and parent or guardian
requirements. Students who cannot or do not want to use it can pair with a
teacher or implement a change without AI.

## Before You Begin

You need:

- An individually approved GitHub account.
- VS Code with the Coach Score folder open.
- The GitHub Copilot extension enabled.
- Permission to use an AI service for class.

Account eligibility, GitHub Education, Copilot Student, Copilot Free, and
detailed activation steps are in the
[complete Copilot setup guide](reference/complete-copilot-setup.md).

## Safety Rules

Never give an AI assistant:

- Passwords, security codes, recovery codes, or access tokens.
- `.env` contents or private configuration.
- Private student records, contact details, or personal messages.
- Photos or recordings without permission.
- Permission to publish or deploy work automatically.

Keep command approvals enabled. Read each requested command and review each
file change. Do not use settings or instructions that bypass approvals.

## Understand the Three Modes

| Mode | Use it for | Student responsibility |
| --- | --- | --- |
| **Ask** | Explanations and questions | Check the answer against the project |
| **Plan** | Describing steps before editing | Confirm the scope is small and relevant |
| **Agent** | Making an approved change | Review the diff and every command |

Start with Ask and Plan. Use Agent only after your teacher approves the design
statement from Lesson 8.

## Safe Practice

Ask Copilot:

```text
Explain the purpose of lib/features/scoring in beginner-friendly language.
Do not edit files or run commands.
```

Then ask:

```text
Create a short plan for investigating how Coach Score shows the selected
player. Do not edit files. Name the files you would inspect and the questions
you would answer.
```

Check whether the response follows the instruction and refers to real project
files. AI can be confidently wrong.

## Checkpoint

- [ ] My account and classroom use are approved.
- [ ] I can explain the difference between Ask, Plan, and Agent.
- [ ] Command approvals remain enabled.
- [ ] I know what information must remain private.
- [ ] I completed an explanation and a read-only plan before requesting edits.

## What Comes Next

Continue to
[Lesson 10: Your First AI-Assisted Change](10-first-ai-assisted-change.md).

