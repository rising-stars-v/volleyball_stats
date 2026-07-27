# Coach Score Student Developer Tutorial

This guide is for 8th grade students who want to understand the Coach Score app
and learn how to contribute small new features.

Coach Score is a Flutter app for volleyball coaches. During a match, a coach can
pick a player, tap an action such as a serve or attack, and see a custom score
summary later. The app works offline, so it does not need a server while a coach
is using it.

## What You Will Learn

By the end of this tutorial, you should be able to:

- Run the app on your computer.
- Explain the main folders in the project.
- Follow how one volleyball action becomes part of a match summary.
- Make a small feature change.
- Run checks before sharing your work.

## Before You Start

You need:

- Flutter installed.
- A code editor such as IntelliJ IDEA, Android Studio, or VS Code.
- A terminal.
- This project opened on your computer.

To check that Flutter is available, run:

```sh
flutter doctor
```

If Flutter is installed correctly, you should see a report from Flutter. Some
warnings can be okay, but ask a mentor if you see errors you do not understand.

## Run The App

From the project folder, install the app packages:

```sh
flutter pub get
```

Then run the app in Chrome:

```sh
flutter run -d chrome
```

Try these actions in the app:

1. Open the roster and look at the players.
2. Start or resume a match.
3. Select a player.
4. Tap a scoring action.
5. Open the match summary.

## Project Map

Think of the project like a school building. Each folder has a job.

```text
lib/
  app/              App shell and shared app state
  core/             Scoring summaries, CSV tools, and export logic
  data/
    models/         Player, rule, match, and event definitions
    repositories/   Save/load interface and implementations
    storage/        Browser and device storage
  features/         App screens
test/               Automated checks
store/              Screenshots and recordings for store listings
tooling/            Helper scripts
```

The most useful files for a new contributor are:

- `lib/app/app_state.dart`: coordinates app actions such as adding players,
  starting matches, recording events, and refreshing the screen.
- `lib/core/match_summary.dart`: calculates scores from recorded match events.
- `lib/features/scoring/scoring_screen.dart`: shows the live scoring screen.
- `lib/features/reports/reports_screen.dart`: shows match summary information.
- `test/core/match_summary_test.dart`: tests score summary behavior.

## Important App Ideas

### Player

A player has a jersey number, a display name, and an active/inactive status.

Example: `#7 Jordan`

### Rule Action

A rule action is something the coach can tap during a match.

Examples:

- Good serve: positive points
- Attack error: negative points
- Block: positive points

### Match Event

A match event is one recorded action during a match.

Example:

```text
Jordan made a good serve in set 1, worth +2 points.
```

The app saves raw events instead of only saving final totals. This is important
because old matches should still make sense even if scoring rules change later.

### Voided Event

The app uses a void-based undo. That means a mistake is marked as voided instead
of being deleted. Summary reports ignore voided events, but the original event
history is still preserved.

## Follow One Feature: Recording A Score

When a coach records a score, this is the path through the app:

1. The coach selects a player on the scoring screen.
2. The coach taps an action button.
3. `scoring_screen.dart` calls `appState.recordEvent(...)`.
4. `app_state.dart` asks the repository to save the event.
5. The app refreshes the current match events.
6. `match_summary.dart` calculates totals from events that are not voided.
7. The report screen displays the updated summary.

This is a good pattern to remember:

```text
screen tap -> AppState method -> repository save/load -> summary calculation -> screen update
```

## How To Make A Small Contribution

Start with small, visible changes. Good first tasks include:

- Rename a label to make it clearer.
- Improve an empty message when there is no match.
- Add a small number to a summary screen.
- Add a test for score calculation.
- Improve spacing or button text on one screen.

Avoid big changes at first, such as changing the database, adding accounts, or
adding cloud sync. Those are harder and can break more parts of the app.

## First Practice Task: Add A Total Event Count

Goal: show how many non-voided events are included in a match summary.

This is a good beginner feature because it teaches data, loops, tests, and UI.

### Step 1: Understand The Summary Code

Open:

```text
lib/core/match_summary.dart
```

Find the `MatchSummary` class. It stores the final numbers that reports can use.

Find `MatchSummaryCalculator`. It loops through events and ignores events where:

```dart
event.isVoided
```

That means your total event count should count only events that are not voided.

### Step 2: Add The Data

Add a new field to `MatchSummary`:

```dart
final int totalEventCount;
```

Then update the constructor so it requires the new value:

```dart
required this.totalEventCount,
```

In `MatchSummaryCalculator.calculate`, create a counter:

```dart
var totalEventCount = 0;
```

Inside the loop for non-voided events, increase it:

```dart
totalEventCount += 1;
```

When returning `MatchSummary`, include:

```dart
totalEventCount: totalEventCount,
```

### Step 3: Add Or Update A Test

Open:

```text
test/core/match_summary_test.dart
```

Add a test that checks:

- Normal events are counted.
- Voided events are not counted.

The important idea is:

```text
If there are 3 events and 1 is voided, totalEventCount should be 2.
```

### Step 4: Show It On The Report Screen

Open:

```text
lib/features/reports/reports_screen.dart
```

Find where the summary numbers are displayed. Add the new total event count near
the other match summary numbers.

Use clear text, such as:

```text
Recorded actions
```

### Step 5: Check Your Work

Run:

```sh
dart format .
flutter analyze
flutter test
```

Your contribution is ready when all three commands pass.

## How To Read Flutter Code

Flutter screens are built from widgets. A widget is a piece of the screen.

Common widgets in this app:

- `Scaffold`: a full page layout.
- `AppBar`: the top bar.
- `Text`: words on the screen.
- `IconButton`: a button with an icon.
- `FilledButton`: a main action button.
- `ListView`: a scrollable list.
- `Column`: items stacked from top to bottom.
- `Row`: items arranged from left to right.

When reading a screen file, start with the `build` method. That method describes
what the user sees.

## How To Ask For Help

When you get stuck, write down:

- What you were trying to do.
- What file you changed.
- What command you ran.
- The exact error message.
- What you expected to happen.

Good help request:

```text
I added totalEventCount to MatchSummary. flutter analyze says the constructor is
missing totalEventCount in one place. I checked match_summary.dart but I do not
know which other file creates MatchSummary.
```

Less useful help request:

```text
It broke.
```

## Contribution Checklist

Before sharing your work, check:

- The app still runs.
- The feature works when you try it.
- The code is formatted with `dart format .`.
- `flutter analyze` passes.
- `flutter test` passes.
- You can explain your change in two or three sentences.

## Suggested Student Projects

Beginner:

- Make an empty state message clearer.
- Add a helpful tooltip to an icon button.
- Add a small summary label.
- Add or improve one test.

Intermediate:

- Add a roster search field.
- Add a report filter for one set.
- Add a player detail summary.
- Improve CSV import error messages.

Advanced:

- Add a new export field.
- Add a new report section.
- Add a safer confirmation step for an important action.
- Improve storage behavior while keeping old data working.

## Project Rule

Make one small change at a time. Run the checks. Then make the next change.

Small changes are easier to understand, easier to test, and easier for teammates
to review.
