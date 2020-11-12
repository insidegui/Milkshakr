# Milkshakr

### A sample app with Siri Intents and an App Clip

This project is the demo for my talks on Siri shortcuts and App Clips. It implements a simple milkshake-ordering app that allows you to add a Siri shortcut for a previous order and includes an App Clip where the user can purchase a milkshake.

The app also implements intents and intents UI extensions so you can finish a purchase using Siri without having to launch the app.

![](./Screenshots/SideBySide.png)

### Preparing the app to build locally

Run the script included in the root directory with `./fixbundleid.sh` in order to configure the project with a random bundle ID so that you don't need to change code signing settings manually.