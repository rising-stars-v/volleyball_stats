# Lesson 10: Your First AI-Assisted Change

## Goal

Implement one small, evidence-based HCI improvement. You remain responsible for
the design decision, code review, testing, and final explanation.

## Prepare the Request

Collect these items from Lessons 7 and 8:

- User and context
- Observed usability problem
- Target task and screen
- Tested design idea
- Success condition
- Existing behavior that must remain

## Write a Constrained Prompt

Use this template:

```text
User and context:
Observed problem:
Target screen or workflow:
Requested interaction:
Constraints and behavior to preserve:
Acceptance criteria:

First inspect the relevant files and explain a small plan. Do not edit until I
review the plan. Change only the files needed for this interaction. Add or
update a focused test. Show the diff for review.
```

Example:

```text
During a usability test, students were unsure which player was selected before
recording an action. On the live scoring screen, make the selected player easier
to recognize without relying only on color. Preserve the current scoring and
selection behavior. First explain a small plan. After approval, make the focused
change, update a widget test, and show the diff.
```

## Review Before Accepting

For every changed file, ask:

- Is this file related to the approved design?
- Did the change preserve current behavior?
- Are names and labels understandable?
- Does the design work without relying only on color?
- Is useful feedback visible?
- Can a mistaken action be recovered?
- Did the AI add packages, permissions, or unrelated changes?

Reject or revise changes that exceed the agreed scope.

## Run Project Checks

From the `volleyball_stats` folder:

```sh
dart format .
flutter analyze
flutter test
```

Then run the app:

```sh
flutter run -d chrome
```

Repeat the Lesson 7 scenario. Compare the result with your measurable success
condition. Passing automated tests does not prove that the interaction helps a
person.

## Prepare a Contribution Note

```text
User and context:
Observed problem:
Design change:
Evidence from the paper test:
Files changed:
Automated checks:
Manual usability result:
Remaining concern or next question:
```

Do not commit or publish until your teacher reviews the diff and contribution
note.

## Final Checkpoint

- [ ] The change addresses an observed user problem.
- [ ] The scope stayed small.
- [ ] I reviewed every changed line.
- [ ] Formatting, analysis, and tests passed—or I documented the exact failure.
- [ ] A person tested the updated interaction.
- [ ] I can explain the change without saying only “AI made it.”

You have completed the beginner learning path. Continue improving the design by
repeating observe → define → sketch → test → implement → review.

