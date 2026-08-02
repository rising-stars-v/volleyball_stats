# Lesson 3A: Flutter Setup on Windows

Ask a teacher, parent, guardian, or school IT team before installing software
on a managed computer.

## Install the Tools

1. Install [Google Chrome](https://www.google.com/chrome/).
2. Install [Git for Windows](https://git-scm.com/download/win).
3. Install [Visual Studio Code](https://code.visualstudio.com/).
4. Open VS Code and select **Extensions** from the left side.
5. Search for `Flutter` and install the extension published by **Dart Code**.
   The Dart extension is installed with it.
6. Open the VS Code Command Palette with **Ctrl+Shift+P**.
7. Run **Flutter: New Project**.
8. When asked for the Flutter SDK, select **Download SDK**.
9. Choose a simple location you can find again. Avoid a protected system folder
   and avoid spaces or special characters in the Flutter SDK path.
10. Allow VS Code to add Flutter to `PATH` when offered.
11. Close and reopen VS Code and PowerShell.

## Verify the Installation

In a new PowerShell window, run:

```powershell
git --version
code --version
flutter --version
flutter doctor -v
flutter devices
```

Chrome should appear as a device. Android warnings are acceptable for now.

## If Something Goes Wrong

- If `flutter` is not recognized, restart VS Code and PowerShell first.
- If Chrome is missing, open Chrome once and run `flutter devices` again.
- On a school computer, ask IT rather than bypassing installation restrictions.
- Use the [troubleshooting guide](../reference/troubleshooting.md) for more help.

## Checkpoint

Show your teacher the Flutter, VS Code, and Chrome sections of
`flutter doctor -v`. Do not share usernames or unrelated paths in public posts.

Return to the [Lesson 3 shared checkpoint](README.md#shared-checkpoint).

