# Student Troubleshooting

## Use This Four-Step Method

1. Stop and read the first useful error.
2. Confirm the terminal's current folder.
3. Run `flutter doctor -v` and `flutter devices` when the problem involves setup.
4. Copy the exact error for a teacher, but remove usernames, private paths, and secrets.

## Common Problems

### `flutter` Is Not Recognized or Not Found

Close and reopen the terminal and VS Code. Run `flutter --version` again. If it
still fails, open VS Code's Command Palette and check whether the Flutter SDK
path is configured.

### Cannot Find `pubspec.yaml`

You are probably in the wrong folder. Display the current path and list its
contents. Enter the `volleyball_stats` folder before running Flutter commands.

### Chrome Does Not Appear

Install and open Chrome once. Close and reopen the terminal, then run:

```sh
flutter devices
```

### No Android Device Exists

Start a virtual device in Android Studio's Device Manager, then run
`flutter devices`. See [Android emulator setup](android-emulator.md).

### The App Does Not Show a Change

Save the file. Press `r` in the terminal for hot reload. Some changes require
`R` for hot restart. If necessary, stop with `q` and run the app again.

### Packages Fail to Download at School

Do not disable school security settings. Save the complete error and ask school
IT whether Flutter, Dart, GitHub, and package-hosting sites are allowed.

## Ask for Help With Evidence

Include:

- The lesson and step.
- Your operating system.
- The command you ran.
- The first useful error.
- The output of `flutter doctor -v` when relevant.
- What you already tried.

For more cases, use the
[complete setup troubleshooting section](complete-flutter-environment-setup.md#troubleshooting).

