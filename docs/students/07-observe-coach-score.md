# Lesson 7: Observe Coach Score

**Time:** 45 minutes

**Goal:** Conduct one safe usability observation and turn the evidence into a
focused problem statement.

**Materials:** Coach Score running in Chrome, one observation sheet per group,
and a pencil or shared classroom document.

Before the lesson begins, open the `volleyball_stats` project and run:

```sh
flutter run -d chrome
```

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–5 min | Review observation versus opinion |
| 5–10 min | Assign roles and read the scenario |
| 10–22 min | Participant completes the workflow |
| 22–30 min | Ask neutral follow-up questions |
| 30–40 min | Review evidence and write a problem statement |
| 40–45 min | Share and complete the checkpoint |

## Why This Matters

Designers can guess what users need, but observation provides better evidence.
In this lesson, you will watch another person complete a Coach Score task
without teaching them where to tap.

## What You Will Learn

- Describe a user, goal, task, context, action, and feedback.
- Facilitate a small usability test safely.
- Record what happened instead of judging the participant.
- Turn an observation into a focused problem statement.

## The Scenario

Imagine an assistant coach beside a noisy volleyball court. They may be
standing, have one hand free, and need to look back at the game quickly.

Give the participant this task:

> Start or resume a match. Record **Serve ace** for player #7. Pretend you
> accidentally recorded one extra action, correct that mistake, and find the
> player's result in the match summary.

Do not tell the participant which controls to select.

## Roles

Work in groups of three:

- **Participant:** attempts the task.
- **Facilitator:** reads the scenario and asks neutral questions.
- **Observer:** records actions, pauses, comments, errors, and recovery.

With two students, the facilitator can also take notes. With one student, ask a
teacher to act as the participant. The designer should not test their own memory
of the interface as if it were a new user's experience.

Use fictional data. Do not record a person's face, voice, or identifying
information without explicit classroom permission.

Before starting, remind the participant: the interface is being tested, not
the person. They can stop at any time.

## Observation Sheet

| Step or moment | What the person did or said | Visible feedback | Evidence of ease or difficulty |
| --- | --- | --- | --- |
| Started the task |  |  |  |
| Selected a player |  |  |  |
| Recorded an action |  |  |  |
| Corrected a mistake |  |  |  |
| Opened the summary |  |  |  |

Write observations such as “looked across the screen for eight seconds” or
“selected two players before choosing #7.” Avoid labels such as “bad user.”

## Ask After the Task

1. What did you expect to happen?
2. What felt easiest?
3. What felt uncertain or risky?
4. How did you know the action was recorded?
5. What would you change first?

Use neutral prompts such as “What are you looking for?” Avoid “Why didn't you
tap Undo?” because it reveals the expected answer and can sound judgmental.

## Create a Problem Statement

Use evidence, not a preferred solution:

```text
[User] needs a clearer way to [goal or task]
because [observation and context].
```

Example:

```text
An assistant coach needs a clearer way to confirm the selected player because
the participant paused and rechecked the roster before three scoring actions in
a fast match scenario.
```

“Make the button blue” is not a problem statement. It is one possible solution
that still needs to be evaluated.

## Checkpoint

- [ ] I recorded behavior rather than judging the person.
- [ ] I did not teach the participant where to tap.
- [ ] I identified the goal, task, actions, and feedback.
- [ ] My problem statement includes a user and observation evidence.
- [ ] I selected one small problem to investigate.
- [ ] I thanked the participant and stopped the app with `q` when finished.

## What Comes Next

Continue to
[Lesson 8: Design and Test an Improvement](08-design-and-test-an-improvement.md).
