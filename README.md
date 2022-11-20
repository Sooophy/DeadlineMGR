# Deadline Manager

This is the final project of Duke ECE564 F22 course.

Team Members: Sophie Shi, Tianjun Mo, Jinyi Xie

For more details, please see [Google Docs](https://docs.google.com/document/d/1p4swxZ8kndHcXNgQTuRm10pHnKqNCB5oeElfsutgZBc/edit)

## Calendar

Calendar view is built with the help of this tutorial: https://www.youtube.com/watch?v=jBvkFKhnYLI

## Firebase

Sync between devices demo: https://drive.google.com/file/d/1iKjoxApPIIkFu_pGanktD_6zHsT3MeLb/view

In this project, we use Firebase Realtime Database to persist user data on the cloud and sync for users' different devices in realtime. We use Keychain to sync user credentials between devices, which works on real devices.

If you want to test the data syncing between devices (e.g., different iPhone, iPad) on simulators, here is the solution:

1. Run the application on the iPhone simulator, and it will automatically create an anonymous user and save it to the Keychain database.
2. Keychain database is an SQLite database, so go to `~/Library/Developer/CoreSimulator/Devices/{iPhone_Device_ID}/data/Library/Keychains` and find the database files (all files). Copy them to the `~/Library/Developer/CoreSimulator/Devices/{iPad_Device_ID}/data/Library/Keychains` directory, and the credentials will be copied to the iPad simulator.
3. Run the iPad simulator, then the data will always be in sync through Firebase Realtime Database.

## Apple Watch

We use WatchConnectivity to sync events. Each time when the watch app launched, it will fetch the event data from iPhone.
