# Lesson 5: Run Coach Score

## Why This Matters

Now you will run a real project. Your goal is to explore it as a user before
thinking about code changes.

## Download the Project

From your projects folder, run:

```sh
git clone https://github.com/rising-stars-v/volleyball_stats.git
cd volleyball_stats
code .
```

If the repository already exists, do not clone a second copy. Open its folder
and confirm that you see `pubspec.yaml`, `lib`, and `test`.

## Install Packages and Run

```sh
flutter pub get
flutter run -d chrome
```

The first run may take several minutes. Keep the terminal open while the app is
running.

## Explore the Main Workflow

Use only fictional practice data:

1. Open the roster.
2. Start or resume a match.
3. Select a player.
4. Record several actions.
5. Undo one action.
6. Open the match summary.

Do not only ask, “Does it work?” Also ask, “Was it easy to understand?”

## Stop and Verify

Press `q` in the running terminal, then run:

```sh
dart format .
flutter analyze
flutter test
```

Do not change project files merely to make an unexplained error disappear.
Record the first useful error and ask for help.

## Checkpoint

- [ ] Coach Score opens in Chrome.
- [ ] I completed the main workflow.
- [ ] I can identify one easy moment and one confusing moment.
- [ ] I ran the three verification commands.

## What Comes Next

Continue to [Lesson 6: HCI With Everyday Apps](06-hci-with-everyday-apps.md).

