# Lesson 3: Install Flutter

Choose the instructions for your computer:

- [Windows setup](windows.md)
- [macOS setup](macos.md)

Both paths install the same core tools:

1. Google Chrome
2. Git
3. Visual Studio Code
4. VS Code's Flutter extension
5. The Flutter SDK

![Five-stage journey from computer basics through Flutter verification](../../images/flutter_setup_journey.svg)

Android Studio and Xcode are optional. The first class uses Chrome so students
can begin learning without configuring a mobile-device simulator.

## Shared Checkpoint

Open a new terminal after installation and run:

```sh
flutter doctor -v
flutter devices
```

You are ready when:

- The `flutter` command works.
- Flutter recognizes Chrome and VS Code.
- `flutter devices` lists Chrome.

Android or Xcode warnings do not block the Chrome lessons.

For more explanation or unusual computer configurations, use the
[complete Flutter environment guide](../reference/complete-flutter-environment-setup.md).

After the checkpoint passes, continue to
[Lesson 4: Build Your First Flutter App](../04-build-your-first-flutter-app.md).

