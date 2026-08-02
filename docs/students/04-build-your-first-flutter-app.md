# Lesson 4: Build Your First Flutter App

## Why This Matters

Before changing Coach Score, create a tiny app and learn the development loop:
edit → run → observe → improve.

## Create the Project

Open PowerShell on Windows or Terminal on macOS. Go to a folder where you keep
projects, then run:

```sh
flutter create hello_flutter
cd hello_flutter
code .
```

The dot in `code .` means “open the current folder.” In VS Code, confirm that
the Explorer shows `pubspec.yaml` and the `lib` folder.

## Replace the Example App

Open `lib/main.dart`, select all of its contents, and replace them with:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const HelloApp());
}

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello, Flutter!'),
        ),
      ),
    );
  }
}
```

Save the file.

## Run and Change It

From the project folder, run:

```sh
flutter run -d chrome
```

Keep the terminal open. Change the message to your own classroom-safe greeting,
save it, and press `r` in the terminal to hot reload.

Press `q` when you are ready to stop the app.

## Update the Generated Test

The test created by `flutter create` expects Flutter's original counter screen.
Because you replaced that screen, open `test/widget_test.dart` and replace it
with this focused test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/main.dart';

void main() {
  testWidgets('shows the greeting', (tester) async {
    await tester.pumpWidget(const HelloApp());

    expect(find.text('Hello, Flutter!'), findsOneWidget);
  });
}
```

If you changed the greeting, use the same text in the test. The test describes
an expected result, so the application and test must agree.

## Check the Code

Run:

```sh
dart format .
flutter analyze
flutter test
```

Formatting changes presentation. Analysis looks for code problems. Tests check
expected behavior.

## Checkpoint

- [ ] The app opens in Chrome.
- [ ] It displays your greeting.
- [ ] Hot reload shows a saved change.
- [ ] You can explain what `lib/main.dart` contains.
- [ ] `flutter analyze` and `flutter test` pass.
- [ ] You stopped the process with `q`.

## Think Like an HCI Designer

The text is a representation of the application's state. What feedback tells
you that hot reload succeeded? What would a user need besides a greeting to
complete a useful task?

## What Comes Next

Continue to [Lesson 5: Run Coach Score](05-run-coach-score.md).
