# Lesson 5: Run and Explore Coach Score

**Time:** 45 minutes

**Goal:** Download and run Coach Score, complete its main workflow, and record
first impressions without changing the code.

**Before starting:** Complete [Lesson 4](04-build-your-first-flutter-app.md) and
confirm that Flutter can run an app in Chrome.

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–8 min | Navigate to the projects folder and download Coach Score |
| 8–15 min | Inspect the project and install packages |
| 15–25 min | Run Coach Score in Chrome |
| 25–37 min | Complete the main user workflow |
| 37–42 min | Record easy and confusing moments |
| 42–45 min | Stop the app and complete the checkpoint |

## Download the Project — 8 Minutes

Open PowerShell or Terminal and navigate to the folder created in Lesson 4.

Windows PowerShell:

```powershell
cd "$HOME\Documents\student-projects"
Get-ChildItem
```

macOS Terminal:

```sh
cd ~/Documents/student-projects
ls
```

If Windows uses a different Documents location, use the copied path from
Lessons 2 and 4.

Look for a folder named `volleyball_stats`.

- If it is **not** listed, download it:

  ```sh
  git clone https://github.com/rising-stars-v/volleyball_stats.git
  ```

- If it **is** listed, do not clone a second copy.

Enter and open the project:

```sh
cd volleyball_stats
code .
```

If Git says the repository cannot be found or asks for access, record the exact
message and ask your teacher. Do not enter someone else's password or token.

## Inspect and Prepare the Project — 7 Minutes

In VS Code, confirm that the top-level folder contains:

```text
pubspec.yaml
lib/
test/
```

This is a different project from `hello_flutter`. Check the VS Code title and
Explorer before running commands.

In the terminal, confirm that the current folder is `volleyball_stats`, then
download the packages named by the project:

```sh
flutter pub get
```

Do not edit project files in this lesson.

## Run Coach Score — 10 Minutes

```sh
flutter run -d chrome
```

The first run may take several minutes. Keep the terminal open. If Flutter says
it cannot find `pubspec.yaml`, stop and return to the `volleyball_stats` folder.

## Explore the Main Workflow — 12 Minutes

Use only fictional practice data:

1. Open the roster and notice how players are represented.
2. Start or resume a match.
3. Select player #7.
4. Record **Serve ace**.
5. Record another action.
6. Undo the most recent action.
7. Open the match summary.

Do not only ask, “Does it work?” Also ask, “Was it easy to understand?”

## Record First Impressions — 5 Minutes

| Moment | What happened? | Why did it feel easy or confusing? |
| --- | --- | --- |
| One easy moment |  |  |
| One confusing or uncertain moment |  |  |
| One useful piece of feedback |  |  |

Record what you saw rather than proposing code. For example, “I paused before
finding Undo” is an observation; “move Undo to the top” is already a solution.

## Stop and Check — 3 Minutes

Press `q` in the running terminal. If time permits, establish a baseline by
running:

```sh
flutter analyze
flutter test
```

These commands may continue after the 45-minute lesson. Record the first useful
error rather than changing code to hide an unexplained failure.

## Checkpoint

- [ ] I opened the correct `volleyball_stats` folder.
- [ ] Coach Score runs in Chrome.
- [ ] I completed the main workflow using fictional data.
- [ ] I recorded an easy moment, a confusing moment, and useful feedback.
- [ ] I stopped the Flutter process with `q`.

## What Comes Next

Continue to [Lesson 6: HCI With Everyday Apps](06-hci-with-everyday-apps.md).
