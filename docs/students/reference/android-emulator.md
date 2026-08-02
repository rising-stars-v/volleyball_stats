# Optional: Android Emulator Setup

You do not need Android for the first lessons. Use Chrome unless your teacher
specifically asks for Android testing.

## Install and Configure

1. Install [Android Studio](https://developer.android.com/studio).
2. Open Android Studio and complete its Setup Wizard.
3. Open **SDK Manager** and confirm that an Android SDK platform, Android SDK
   Command-line Tools, Platform-Tools, and Emulator are installed.
4. In a terminal, run:

   ```sh
   flutter doctor --android-licenses
   ```

5. Read and accept the licenses.
6. In Android Studio, open **Device Manager**.
7. Select **Create Device**, choose a phone profile, and download a recommended
   system image for your computer.
8. Start the virtual device with its Play button.

## Run Coach Score

```sh
flutter devices
flutter run -d <device-id>
```

Use the exact ID displayed by `flutter devices`, often something similar to
`emulator-5554`. The word `android` is normally a platform description, not a
specific device ID, so `flutter run -d android` may fail.

The complete instructions and additional diagnostics are in the
[complete Flutter environment guide](complete-flutter-environment-setup.md#optional-part-5-set-up-android).

