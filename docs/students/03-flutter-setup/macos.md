# Lesson 3B: Flutter Setup on macOS

Ask a teacher, parent, guardian, or school IT team before installing software
on a managed computer.

## Install the Tools

1. Install [Google Chrome](https://www.google.com/chrome/).
2. Open Terminal and run Apple's Command Line Tools installer:

   ```sh
   xcode-select --install
   ```

3. Complete the Apple installation window.
4. Install [Visual Studio Code](https://code.visualstudio.com/).
5. Move Visual Studio Code into the **Applications** folder and open it.
6. Select **Extensions** from the left side.
7. Search for `Flutter` and install the extension published by **Dart Code**.
8. Open the Command Palette with **Command+Shift+P**.
9. Run **Flutter: New Project**.
10. When asked for the Flutter SDK, select **Download SDK** and choose a folder
    you can find again.
11. Allow VS Code to add Flutter to `PATH` when offered.
12. Close and reopen VS Code and Terminal.

## Verify the Installation

In a new Terminal window, run:

```sh
git --version
code --version
flutter --version
flutter doctor -v
flutter devices
```

Chrome should appear as a device. Xcode and Android warnings are acceptable for
the first lessons.

## If Something Goes Wrong

- If `code` is missing, open VS Code's Command Palette and run
  **Shell Command: Install 'code' command in PATH**.
- If `flutter` is missing, restart Terminal and VS Code first.
- If Chrome is missing, open Chrome once and run `flutter devices` again.
- Use the [troubleshooting guide](../reference/troubleshooting.md) for more help.

## Checkpoint

Show your teacher the Flutter, VS Code, and Chrome sections of
`flutter doctor -v`. Do not share usernames or unrelated paths in public posts.

Return to the [Lesson 3 shared checkpoint](README.md#shared-checkpoint).

