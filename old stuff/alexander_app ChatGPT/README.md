# Alexander Technique Prompts App

## Overview

This simple cross‑platform mobile application is built with **React Native** using the **Expo** toolchain. It delivers random Alexander Technique prompts as **local notifications** and provides a dedicated section for **longer lessons** based on published guidance. The lessons summarise key principles such as mindful body awareness, lengthening the spine and ergonomic posture【211788931891446†L96-L110】.

Local notifications are supported on both iOS and Android. Expo abstracts away the complexities of dealing directly with APNs or FCM, making push configuration easier【799044027329686†L90-L100】. The app schedules notifications locally on the device, so it doesn’t require a back‑end server.

## Setup Instructions

1. **Install Node.js and npm** if you haven’t already. See <https://nodejs.org/> for downloads.
2. **Install the Expo CLI** globally:

   ```bash
   npm install -g expo-cli
   ```

3. **Navigate to the project directory**:

   ```bash
   cd alexander_app
   ```

4. **Install project dependencies**:

   ```bash
   npm install
   ```

5. **Start the Expo development server**:

   ```bash
   npm start
   ```

   This will launch the Expo DevTools in your browser and display a QR code in the terminal.

6. **Run on your device**:

   - **iPhone**: Install the **Expo Go** app from the App Store. Open Expo Go and use the built‑in QR scanner to scan the QR code from the terminal. The app will load on your device.
   - **Android**: Install **Expo Go** from Google Play. Use it to scan the QR code.
   - **Web or emulator**: In Expo DevTools, click “Run on web” or “Run on Android/iOS simulator” if you have an emulator set up.

7. **Grant notification permissions** when prompted. Without permission, the app cannot schedule or display notifications.

8. **Use the app**:
   - Press **“Schedule Random Prompts”** to schedule a handful of notifications for the remainder of the day. Each notification is chosen randomly from the defined list of prompts.
   - Press **“Go to Lessons”** to read longer explanations of the Alexander Technique principles, with citations included.

## Customising Prompts and Timing

The array of prompts lives in `App.js`. Each entry includes a `title` and `body`. You can add or modify prompts by editing this array.

The `scheduleRandomNotifications()` function schedules five notifications by default between **09:00** and **21:00**. You can adjust the `count` parameter in the button handler or modify the start/end hours to suit your routine.

## Building Standalone Apps

To generate standalone binaries that you can distribute or upload to app stores, use Expo’s build commands:

- **iOS:**

  ```bash
  expo build:ios
  ```

  You will need an Apple Developer account to sign the app.

- **Android:**

  ```bash
  expo build:android
  ```

These commands bundle the JavaScript and assets into a native app. Follow the prompts in the terminal to complete the process.

## Citations

The lessons in `App.js` derive from a 7‑step guide to effortless posture published by Alexander Technique London. Key recommendations include cultivating mindful body awareness and letting the neck be free to allow the head to go forward and up【211788931891446†L96-L110】, using the sit‑bones to support yourself when sitting【211788931891446†L111-L122】, recognising that posture is a dynamic movement requiring regular breaks【211788931891446†L140-L144】 and optimising workstation ergonomics【211788931891446†L145-L150】.