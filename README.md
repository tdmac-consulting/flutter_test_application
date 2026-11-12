# flutter_test_application

## Introduction

This project was a learning tool for getting to know dart syntax, and flutter project structure. This project was written both manually and with the assistance of Copilot. I used AI to introduce me to the ways in which I can achieve things I know how to do in other tech stacks, in this specific tech stack.

## App purpose

The app started as a playground for me to understand how dart and flutter work. Over time I realised I was working with more and more complicated calculations so I decided that a good test project would be to build a calculator

This app is a reproduction of the iOS basic calulator app's functionality. While it is not an exact copy, the key was to replicate the core calculation functionality so that I would be exposed to different types of number manipulation including the difference between working with integers and decimals (doubles) in dart.

The key learnings from this project were:

- How to start a flutter project
- How to work on a flutter project locally
- How the dart syntax works
- How the flutter project directory is structured
- How to modify the UI of a flutter project
- How to write and implement utility functions
- How to manage state
- How unit tests are written and used in a flutter project

Some additional learnings from this were how to display large numbers using scientifc notation and localising number strings.

## Getting Started

### Prerequisites

- Install the Flutter SDK and add `flutter` to your `PATH`.
- Install Xcode and its command-line tools for macOS development.

Verify the setup and address any relevant issues reported by:

```bash
flutter doctor
```

Enable the macOS desktop target if it is not already enabled:

```bash
flutter config --enable-macos-desktop
```

### Run the app

From the cloned repository's project directory, fetch dependencies and run the macOS app:

```bash
cd flutter_test_application
flutter pub get
flutter run -d macos
```

If your terminal is already in the project directory, omit the `cd` command. Use `flutter devices` to confirm that Flutter detects the macOS target.


### Important note

The android and iOS versions of this app are untested


## Keyboard support

The calculator accepts hardware keyboard input on desktop and on mobile devices
with a connected keyboard. Use digits, `+`, `-`, `*`, `/`, and `.` to enter
calculations; press Enter or `=` to calculate. Backspace deletes the last
character, Escape or Delete clears the calculator, F9 toggles the sign, and
`%` applies percentage.
