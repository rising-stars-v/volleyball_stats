# Lesson 4: Build Your First Flutter App

**Time:** 60 minutes

**Goal:** Create Flutter's example app, run it in Chrome, understand its basic
parts, and make one small visible change.

**Before starting:** Complete the [Lesson 3 checkpoint](03-install-flutter.md#checkpoint).

## Lesson Plan

| Time | Activity |
| ---: | --- |
| 0–5 min | Connect SDK, project, source file, app, and target device |
| 5–12 min | Create the project folders and Flutter app |
| 12–18 min | Inspect the generated project |
| 18–30 min | Run the app in Chrome for the first time |
| 30–38 min | Explore the counter interaction as an HCI system |
| 38–48 min | Change the app title and use hot reload |
| 48–53 min | Compare hot reload and hot restart |
| 53–58 min | Format, analyze, and test the project |
| 58–60 min | Exit checkpoint |

The first Flutter build may take longer than expected. The teacher can continue
the explanation while students wait.

## Five Parts of the Development Story — 5 Minutes

| Part | Meaning in this lesson |
| --- | --- |
| **Flutter SDK** | The tools that create, run, and check the app |
| **Project** | The `hello_flutter` folder and everything inside it |
| **Source file** | `lib/main.dart`, which describes the app's interface and behavior |
| **Application** | The running counter app |
| **Target device** | Chrome, where Flutter displays the app |

The source file is not the running application. Flutter reads the project files
and builds an application that Chrome can run.

## Create the Project — 7 Minutes

Open PowerShell on Windows or Terminal on macOS.

Go to Documents using the same method as Lesson 2:

Windows PowerShell:

```powershell
cd "$HOME\Documents"
```

macOS Terminal:

```sh
cd ~/Documents
```

If the Windows path does not exist, copy the Documents path from File
Explorer's address bar and use `cd "copied-path"`.

Create a folder for student projects:

```sh
mkdir student-projects
cd student-projects
```

If the terminal says `student-projects` already exists, that is okay. Do not
create another copy; enter it with `cd student-projects`.

Create the Flutter project:

```sh
flutter create hello_flutter
cd hello_flutter
```

Wait until Flutter reports that the project was created. If `hello_flutter`
already exists, stop and ask your teacher before replacing or recreating it.

Open the current project folder in VS Code:

```sh
code .
```

The dot means “the current folder.” If `code` is not found, open VS Code, select
**File → Open Folder**, and choose `Documents/student-projects/hello_flutter`.

## Inspect Before Editing — 6 Minutes

In VS Code's Explorer, find:

```text
hello_flutter/
  lib/
    main.dart
  test/
    widget_test.dart
  pubspec.yaml
```

| Item | Purpose for now |
| --- | --- |
| `lib/main.dart` | Main source file for the generated app |
| `test/widget_test.dart` | Automated check created by Flutter |
| `pubspec.yaml` | Project name, version, packages, and assets |

Open `lib/main.dart`, but do not replace it. Find these ideas:

- `main()` is where the Dart program begins.
- `runApp(...)` tells Flutter which widget starts the interface.
- A **widget** describes part of a Flutter interface.
- `Text(...)` displays a representation made of words.

You do not need to understand every line yet.

## Run the Generated App — 12 Minutes

Return to the terminal. Confirm that its current folder is `hello_flutter` and
that the folder contains `pubspec.yaml`. Then run:

```sh
flutter run -d chrome
```

The first build may take several minutes while Flutter prepares files. Keep the
terminal open. Chrome should display Flutter's generated counter app.

If Flutter cannot find `pubspec.yaml`, the terminal is in the wrong folder. Use
`cd` to return to `hello_flutter` before trying again.

## Explore the Counter as an HCI System — 8 Minutes

Select the floating **+** button three times, then discuss:

| HCI idea | Counter-app example |
| --- | --- |
| **User goal** | Increase the displayed count |
| **Interface** | Text, number, app bar, and + button |
| **Representation** | The number represents the current count |
| **Action** | Select the + button |
| **Application process** | Flutter increases the stored counter state |
| **Feedback** | The visible number changes immediately |
| **State** | The counter's current value |

Ask: would a first-time user understand what the + button changes? What
additional label or feedback might make the goal clearer?

## Make One Small Change — 10 Minutes

In `lib/main.dart`, find this text:

```dart
home: const MyHomePage(title: 'Flutter Demo Home Page'),
```

Change only the words inside the quotation marks:

```dart
home: const MyHomePage(title: 'My First Flutter App'),
```

Save the file. Return to the terminal where Flutter is still running and press:

```text
r
```

The lowercase `r` requests **hot reload**. The app bar should display the new
title without rebuilding the entire app.

If your generated template looks different and the exact line is missing, do
not replace the whole file. Ask your teacher to help identify one visible text
string that can be changed safely.

## Hot Reload and Hot Restart — 5 Minutes

Select the + button until the counter is greater than zero.

1. Press lowercase `r`. Hot reload normally preserves the counter state.
2. Press uppercase `R`. Hot restart starts the Dart application again, so the
   counter normally returns to zero.

| Action | What it does |
| --- | --- |
| Save a file | Stores the source-code change |
| Hot reload (`r`) | Applies many code changes while preserving app state |
| Hot restart (`R`) | Restarts the Dart app and resets temporary state |
| Stop (`q`) | Stops the running Flutter process |

This is another HCI loop: you change the source, request reload, observe
feedback, and decide whether the result matches your goal.

Press `q` when you are ready to stop the app.

## Check the Project — 5 Minutes

Run one command at a time:

```sh
dart format .
flutter analyze
flutter test
```

- Formatting makes Dart code presentation consistent.
- Analysis looks for likely code problems.
- The generated widget test checks the counter behavior.

Changing only the title should preserve the generated counter test. Do not edit
the test merely to hide an unexplained failure; read the first useful error and
ask for help.

## Exit Checkpoint — 2 Minutes

- [ ] The generated app opens in Chrome.
- [ ] The + button changes the counter.
- [ ] The app bar says `My First Flutter App`.
- [ ] I can explain source file, application, and target device.
- [ ] I can explain hot reload versus hot restart.
- [ ] `flutter analyze` and `flutter test` pass.
- [ ] I stopped the process with `q`.

## What Comes Next

Continue to [Lesson 5: Run Coach Score](05-run-coach-score.md).
