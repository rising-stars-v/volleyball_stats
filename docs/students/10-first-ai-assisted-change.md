# Lesson 10: Your First AI-Assisted Change

**Time:** 75–90 minutes

**Goal:** Implement one small, evidence-based HCI improvement while keeping the
student and teacher in control of planning, edits, commands, review, and tests.

**Before starting:** Complete Lessons 7–9 and obtain teacher approval for the
Lesson 8 design decision. Students not using AI can follow the same gates with
a teacher or student developer implementing the approved design.

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–10 min | Gather evidence and confirm a clean starting point |
| 10–20 min | Write a constrained implementation request |
| 20–30 min | Review the AI plan without allowing edits |
| 30–45 min | Approve and implement one small change |
| 45–55 min | Review every changed file and reject extra scope |
| 55–65 min | Format changed files, analyze, and test |
| 65–77 min | Repeat the usability scenario with a person |
| 77–90 min | Write the contribution note and complete the checkpoint |

## Four Required Gates

The work cannot skip these gates:

```text
1. Evidence and design
        ↓ teacher reviews
2. Read-only implementation plan
        ↓ student and teacher approve
3. Small file change
        ↓ student reviews the diff
4. Automated and human testing
```

Passing a code test does not replace testing the interaction with a person.

## Gate 1: Prepare the Evidence — 10 Minutes

Collect:

- User and context from Lesson 7
- Observed usability problem
- Target task and screen
- Tested paper design from Lesson 8
- Measurable success condition
- Existing behavior that must remain

From the `volleyball_stats` folder, run this read-only command:

```sh
git status --short
```

If it displays changes that existed before this lesson, stop and ask the
teacher. Do not delete, discard, overwrite, or reset someone else's work.

## Gate 2: Request and Review a Plan — 20 Minutes

Use this prompt template:

```text
User and context:
Observed problem:
Target screen or workflow:
Tested design:
Behavior to preserve:
Acceptance criteria:

First inspect the relevant files and explain a small implementation plan.
Do not edit files or run commands. Name the files you expect to change, the
test you expect to update, and any assumptions or risks.
```

Example:

```text
During a usability test, students were unsure which player was selected before
recording an action. On the live scoring screen, make the selected player easier
to recognize without relying only on color. Preserve the current scoring and
selection behavior. Success means a participant can identify the selected
player without help. First provide a read-only plan and name the expected files
and focused widget test.
```

Review the plan with the teacher:

- Does it address the observed problem?
- Does it match the tested paper design?
- Does it change only one screen or short workflow?
- Does it preserve scoring, data, navigation, and recovery behavior?
- Are the proposed files related to the task?
- Is the acceptance criterion observable?

Revise the plan before allowing edits if any answer is no or uncertain.

## Gate 3: Implement One Small Change — 15 Minutes

After the teacher approves the plan, tell the assistant:

```text
Proceed with only the approved change. Keep Default Approvals enabled. Ask
before running commands. Do not add packages, change permissions, publish,
deploy, commit, or push. Add or update only the focused test from the plan, then
show every changed file as a diff.
```

Read every approval request. Confirm that the command and file belong to the
approved plan. Do not approve a broad or unexplained action merely because the
assistant recommends it.

## Review the Diff — 10 Minutes

Open VS Code's **Source Control** view. Select every changed file to see the
before-and-after diff.

For each file, ask:

- Why did this file need to change?
- Can I explain the important changed lines?
- Did the change preserve current behavior?
- Does the design work without relying only on color?
- Is useful feedback visible?
- Can a mistaken action be recovered?
- Did the assistant add packages, permissions, secrets, or unrelated changes?

Reject extra scope. If you are unsure how to undo an AI edit safely, stop and
ask the teacher; do not run `git reset`, delete files, or blindly accept all.

Run `git status --short` again and compare the file list with the approved plan.

## Gate 4A: Automated Checks — 10 Minutes

Format only the changed Dart files. Replace the example path with each real
file reported by the diff:

```sh
dart format lib/path/to/changed_file.dart
```

Do not type `path/to/changed_file.dart` literally. Then run:

```sh
flutter analyze
flutter test
```

Record the result of each command. If a check fails, capture the first useful
error and investigate it. Do not weaken or remove a test simply to make the
check green.

## Gate 4B: Human Check — 12 Minutes

Run the app:

```sh
flutter run -d chrome
```

Ask a participant to repeat the Lesson 7 scenario. Do not teach the new
interface while measuring it. Compare the result with the Lesson 8 success
condition:

| Evidence | Before | After |
| --- | --- | --- |
| Pause, error, or question being studied |  |  |
| Did the participant complete the task without help? |  |  |
| Did feedback communicate what happened? |  |  |
| New difficulty observed |  |  |

One successful participant is encouraging evidence, not proof that the design
works for everyone.

Press `q` to stop the app.

## Prepare the Contribution Note — 8–13 Minutes

```text
User and context:
Observed problem:
Paper design and test evidence:
Implemented change:
Files changed:
Automated-check results:
Before-and-after usability result:
Behavior preserved:
Remaining concern or next question:
```

Do not commit, push, publish, or deploy until the teacher reviews the diff,
test results, and contribution note.

## Final Checkpoint

- [ ] The change addresses an observed user problem.
- [ ] The teacher approved the plan before edits began.
- [ ] The scope stayed small and no unrelated files changed.
- [ ] I reviewed and can explain every changed file.
- [ ] Formatting, analysis, and tests passed—or I documented the exact failure.
- [ ] A person tested the updated interaction.
- [ ] I compared the result with a measurable success condition.
- [ ] I can explain my contribution without saying only “AI made it.”

You have completed the beginner learning path. Continue improving the design by
repeating observe → define → sketch → test → implement → review.
