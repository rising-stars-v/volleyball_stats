# Lesson 9: Copilot Setup and Safety

**Time:** 40 minutes

**Goal:** Connect an approved GitHub account to Copilot in VS Code, keep safe
approval settings, and practice explanation and planning without editing files.

Copilot is optional. Follow school policy and parent or guardian requirements.
Students without an approved account can observe a teacher demonstration or
pair with an approved student without sharing passwords.

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–5 min | Review why AI comes after HCI research and design |
| 5–15 min | Confirm account access and sign in through VS Code |
| 15–22 min | Review privacy and Default Approvals |
| 22–30 min | Ask for a beginner-friendly explanation |
| 30–37 min | Request a plan that does not edit files |
| 37–40 min | Verify settings and complete the checkpoint |

## Why This Comes After HCI

AI can help write code, but it does not automatically know what a coach needs.
Your observation, problem statement, sketch, and test evidence provide the
direction. AI is an implementation assistant—not the designer or decision
maker.

## Before You Begin

You need:

- Your own school- and family-approved GitHub account.
- Access to Copilot Free, Copilot Student, or another approved Copilot plan.
- VS Code with the `volleyball_stats` folder open.
- Your Lesson 8 design decision.

Verified students must activate Copilot Student separately from their GitHub
Education approval. Students who need account, eligibility, activation, or
privacy help should use the
[complete Copilot setup guide](reference/complete-copilot-setup.md).

Official references:

- [Access Copilot as a verified student](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/enable-copilot/set-up-for-students)
- [Set up Copilot in VS Code](https://code.visualstudio.com/docs/setup/copilot)

Never choose a paid plan or enter payment information during class unless a
parent, guardian, or authorized school administrator explicitly directs it.

## Connect Copilot to VS Code — 10 Minutes

1. Confirm that VS Code has the `volleyball_stats` folder open.
2. Find the **Copilot** icon in the VS Code Status Bar.
3. Select **Use AI Features**.
4. Choose the approved GitHub sign-in option.
5. Complete the browser authorization using your own account.
6. Return to VS Code and open the Chat view.

If VS Code offers Copilot Free and your account does not already have access,
stop and confirm the plan with your teacher before activating it. If the icon
or sign-in option is missing, use the complete setup guide rather than
installing unrelated extensions.

## Privacy and Approval Rules — 7 Minutes

Never give an AI assistant:

- Passwords, security codes, recovery codes, or access tokens.
- `.env` contents or private configuration.
- Private student records, contact details, or personal messages.
- Photos or recordings without permission.
- Permission to publish, deploy, purchase, or share work automatically.

In the Chat input area, open the permissions control and keep
**Default Approvals**. Do not select **Bypass Approvals** or **Autopilot** for
this course. Default Approvals asks before potentially risky actions such as
editing files, running commands, or accessing external resources.

Read the tool name, command, file, and URL before approving anything. Approval
for one safe action is not approval for every future action.

Official reference:
[Manage VS Code approvals and permissions](https://code.visualstudio.com/docs/agents/approvals).

## Three AI Workflows

| Workflow | What the student requests | Allowed in this lesson? |
| --- | --- | --- |
| **Explain** | Answer a question without changing anything | Yes |
| **Plan** | Inspect and describe a proposed approach | Yes, read-only |
| **Act** | Edit files or run implementation commands | No; wait for Lesson 10 and teacher approval |

The VS Code labels can change over time. The important distinction is whether
the assistant is only explaining, planning, or taking actions.

## Practice 1: Ask for an Explanation — 8 Minutes

Paste this into Copilot Chat:

```text
Explain the purpose of lib/features/scoring in beginner-friendly language.
Name the files you inspected. Do not edit files or run commands.
```

Check the answer:

- Do the named files actually exist in VS Code's Explorer?
- Does the explanation distinguish interface code from stored data or logic?
- Did Copilot follow the instruction not to edit or run commands?

AI can sound confident while being wrong. Verify its claims against the actual
project.

## Practice 2: Request a Read-Only Plan — 7 Minutes

Paste this prompt:

```text
Create a short plan for investigating how Coach Score shows the selected
player. Do not edit files or run commands. Name the files you would inspect,
the HCI questions you would answer, and the existing behavior you would protect.
```

Compare the plan with your Lesson 7 observation and Lesson 8 design. Reject a
plan that ignores the user evidence or expands into unrelated features.

## Checkpoint — 3 Minutes

- [ ] My account and classroom use are approved.
- [ ] Copilot Chat is connected to my own GitHub account.
- [ ] The permission level is Default Approvals.
- [ ] I know what information must remain private.
- [ ] I verified an explanation against real project files.
- [ ] I requested a read-only plan and no files changed.

## What Comes Next

Continue to
[Lesson 10: Your First AI-Assisted Change](10-first-ai-assisted-change.md).
