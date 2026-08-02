# Lesson 3: Install Flutter

**Time:** 45–90 minutes

**Goal:** Install the tools needed to create and run a Flutter application in
Chrome.

Installation time varies because downloads, computer speed, and school
permissions are different. This is a setup lab, so pausing for school IT is not
a student failure.

## Choose Your Operating System

- [Windows setup](03-flutter-setup/windows.md)
- [macOS setup](03-flutter-setup/macos.md)

Complete only the setup page for your computer, then return here for the shared
checkpoint.

## Understand the Tools First

| Word | Beginner-friendly meaning | Tool in this course |
| --- | --- | --- |
| **IDE or code editor** | An application for reading and changing project files | Visual Studio Code |
| **SDK** | A kit containing commands and libraries for building apps | Flutter SDK |
| **Extension** | An add-on that gives an application new abilities | Flutter extension for VS Code |
| **PATH** | The operating system's list of places to search for commands | Lets the terminal find `flutter` and `code` |
| **Target device** | The place where an app will run | Chrome for the first lessons |

Git downloads projects and tracks their history. Flutter creates and runs the
app. VS Code edits the files. Chrome displays the running web app.

![Five-stage journey from computer basics through Flutter verification](../images/flutter_setup_journey.svg)

Android Studio and Xcode are optional. Android and iOS setup can happen later;
the required beginner lessons use Chrome.

## Shared Verification

After completing the Windows or macOS instructions, close every old terminal
window and open a new one. Run one command at a time:

```sh
git --version
code --version
flutter --version
flutter doctor -v
flutter devices
```

What each command checks:

| Command | Successful evidence |
| --- | --- |
| `git --version` | Displays a Git version number |
| `code --version` | Displays a VS Code version number |
| `flutter --version` | Displays Flutter and Dart version information |
| `flutter doctor -v` | Recognizes Flutter, Chrome, and VS Code |
| `flutter devices` | Lists Chrome as a web device |

Android Studio, Android licenses, Xcode, or CocoaPods warnings do not block the
Chrome lessons.

## Setup Decision Guide

```text
Does flutter --version work?
├── No → close and reopen VS Code and the terminal, then try again
└── Yes
    └── Does flutter devices list Chrome?
        ├── No → install or open Chrome, then check again
        └── Yes → the required setup is ready
```

If restarting does not help, use the
[student troubleshooting guide](reference/troubleshooting.md). Do not bypass
school security controls or enter an administrator password without approval.

## Checkpoint

- [ ] Git, VS Code, and Flutter display version information.
- [ ] `flutter doctor -v` recognizes the required tools.
- [ ] `flutter devices` lists Chrome.
- [ ] I can explain the difference between VS Code, an extension, and the Flutter SDK.
- [ ] I understand that mobile-device warnings are optional for now.

For unusual configurations, use the
[complete Flutter environment guide](reference/complete-flutter-environment-setup.md).

## What Comes Next

Continue to
[Lesson 4: Build Your First Flutter App](04-build-your-first-flutter-app.md).

