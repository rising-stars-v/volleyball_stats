# Lesson 3A: Flutter Setup on Windows

Ask a teacher, parent, guardian, or school IT team before installing software
on a managed computer.

## 1. Install Chrome

1. Download [Google Chrome](https://www.google.com/chrome/).
2. Open the installer and follow its instructions.
3. Open Chrome once, then close it.

Chrome will be the first Flutter target device.

## 2. Install Git

1. Download [Git for Windows](https://git-scm.com/download/win).
2. Open the installer.
3. Keep the recommended options unless your teacher or school IT says otherwise.
4. Finish the installation.

Git will later download Coach Score and track project versions.

## 3. Install Visual Studio Code

1. Download [Visual Studio Code](https://code.visualstudio.com/).
2. Open the installer.
3. Keep **Add to PATH** enabled when the installer offers it.
4. Finish the installation and open VS Code.

Adding VS Code to `PATH` lets the terminal find the `code` command.

## 4. Confirm VS Code's Built-In Git Extension

VS Code already includes its official Git extension. Do not install a random
third-party extension named “Git.” The built-in extension uses the Git for
Windows application installed in Step 2.

1. In VS Code, open **Extensions** with **Ctrl+Shift+X**.
2. Enter `@builtin git` in the Extensions search field.
3. Select the built-in extension named **Git**.
4. If its button says **Enable**, select it. If it says **Disable**, it is
   already enabled—leave it enabled.
5. Open VS Code's terminal with **Terminal → New Terminal**.
6. Run:

   ```powershell
   git --version
   ```

7. Confirm that Git displays a version number.
8. Select the **Source Control** icon in the Activity Bar. VS Code may show
   **Open Folder** or **Clone Repository** because a project repository is not
   open yet; that is expected.

The Source Control view will automatically recognize Git after students open a
Git repository in Lesson 4 or Lesson 5.

Official reference:
[Source Control in VS Code](https://code.visualstudio.com/docs/sourcecontrol/overview/).

## 5. Install the Flutter Extension and SDK

1. Select **Extensions** on the left side of VS Code.
2. Search for `Flutter`.
3. Install **Flutter**, published by **Dart Code**. Its Dart extension is
   installed automatically.
4. Open the Command Palette with **Ctrl+Shift+P**.
5. Run **Flutter: New Project**.
6. When VS Code asks for the Flutter SDK, select **Download SDK**.
7. Choose a folder you can find again. Avoid protected system folders, spaces,
   and special characters in the SDK path.
8. Allow VS Code to add the SDK to `PATH` when offered.
9. When the SDK download and PATH setup finish, cancel the new-project flow.
   Lesson 4 creates the class project in the correct location.

The extension helps VS Code understand Flutter projects. The SDK contains the
actual Flutter commands and libraries.

## 6. Restart the Applications

Close all VS Code and PowerShell windows. Reopen VS Code and PowerShell so they
receive the updated `PATH`.

Return to [Lesson 3 Shared Verification](../03-install-flutter.md#shared-verification).

## If Installation Is Blocked

Do not bypass school controls. Record which installer or step was blocked and
ask school IT or your teacher for help. See the
[troubleshooting guide](../reference/troubleshooting.md).
