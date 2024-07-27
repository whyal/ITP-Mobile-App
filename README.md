# 2024 ITP-Mobile App Project

## Description

A simple flutter application that displays pitch and roll data from MPU6050 sensors.

## Prerequisites

Following through Flutter documentation will get you the list of tools used for the project.
- [Flutter](https://docs.flutter.dev/get-started/install/windows/mobile)
- Android Studio
- VS Code

## Installation of dependencies

Open the project repo on VS Code and run this command in its terminal to install all packages 
needed for the project. You need to ensure you're in the same directory as the project.

```sh
flutter pub get
```

## Android Emulator setup

This project uses Emulator from Android Studio specifically **Pixel 3a API 34**.

## Running of Application

Once you've installed all the required tools and dependencies, you need to select the Android Emulator
as the targeted device to run the project. After which you can press **F5** to start the project.

## Sidenotes

With the MPU6050 sensors, the project will only display *NA* for all the values of pitch and roll.