# Lesson 2: Terminal and Development Tools

## Why This Matters

Developers use several applications together. The terminal provides a text
interface for giving commands, while VS Code provides a visual interface for
reading and changing project files.

## What You Will Learn

- Understand terminal, shell, command, argument, and current folder.
- Recognize the role of VS Code, Git, Flutter, and Chrome.
- Run safe read-only commands.
- Stop and ask before running risky commands.

## Your Development Tools

| Tool | Its job |
| --- | --- |
| **Terminal** | Displays a prompt and the results of commands |
| **Shell** | Reads commands and asks the operating system to run them |
| **VS Code** | Edits project files and provides development tools |
| **Git** | Downloads projects and tracks versions of files |
| **Flutter SDK** | Creates, runs, checks, and builds Flutter applications |
| **Chrome** | Runs the web version of Coach Score |

![A terminal command divided into command, subcommand, option, and value](../images/terminal_command_anatomy.svg)

In this command, `flutter` names the program, `run` names the requested work,
and `-d chrome` selects the target device:

```sh
flutter run -d chrome
```

## Open a Terminal

On Windows, open **PowerShell**. On macOS, open **Terminal**.

Run a command that only reports your current location:

Windows PowerShell:

```powershell
Get-Location
```

macOS:

```sh
pwd
```

List the current folder's contents:

Windows PowerShell:

```powershell
Get-ChildItem
```

macOS:

```sh
ls
```

## Change Folders Safely

The `cd` command means **change directory**. A directory is another word for a
folder.

```sh
cd Documents
```

Return to the parent folder:

```sh
cd ..
```

Paths containing spaces must be quoted:

```sh
cd "Student Projects"
```

## Safety Rules

- Read the full command before pressing Enter.
- Confirm the current folder before running a project command.
- Do not paste commands that request passwords, tokens, or private information.
- Stop before commands containing delete, remove, publish, deploy, or payment steps.
- A terminal error is information. Read it before trying random commands.

## Checkpoint

Show your teacher or partner that you can:

1. Open the terminal.
2. Display the current folder.
3. List its contents.
4. Enter one known folder.
5. Return to the parent folder.

## Think Like an HCI Designer

The terminal and Finder/File Explorer can both navigate folders, but they use
different representations and actions. Which interface gives a beginner more
feedback? Which is faster for repeated work?

## What Comes Next

Continue to [Lesson 3: Install Flutter](03-flutter-setup/README.md).

