# Optional: iOS Simulator Setup on macOS

iOS development requires macOS and Xcode. It is optional for the beginner
course; Chrome is sufficient for the required lessons.

## Install and Start

1. Install Xcode from the Mac App Store.
2. Open Xcode once and complete any requested component installation.
3. In Terminal, run:

   ```sh
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   open -a Simulator
   ```

4. Wait for a simulated iPhone to finish starting.
5. From the Coach Score project folder, run:

   ```sh
   flutter devices
   flutter run -d <simulator-device-id>
   ```

Use the exact simulator ID printed by `flutter devices`.

See the [complete Flutter environment guide](complete-flutter-environment-setup.md#optional-part-6-set-up-ios-on-macos)
for CocoaPods and troubleshooting details.

