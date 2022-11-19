# Deadline Manager

This is the final project of Duke ECE564 F22 course.

Team Members: Sophie Shi, Tianjun Mo, Jinyi Xie

For more details, please see [Google Docs](https://docs.google.com/document/d/1p4swxZ8kndHcXNgQTuRm10pHnKqNCB5oeElfsutgZBc/edit)

## Calendar

Calendar view is built with the help of this tutorial: https://www.youtube.com/watch?v=jBvkFKhnYLI

## Firebase

In this project, we use Firebase Firestore to persist user data on the cloud and sync for users' different devices. We use Keychain to sync user credentials between devices, which works on real devices.  

If you want to test the data syncing between devices (e.g., iPhone and Apple Watch) on simulators, there is also a solution:
1. Run the application on the iPhone simulator, and it will automatically create an anonymous user and save it to the Keychain database.
2. Keychain database is an SQLite database, so go to `~/Library/Developer/CoreSimulator/Devices/{iPhone_Device_ID}/data/Library/Keychains` and find the database files (all files). Copy them to the `~/Library/Developer/CoreSimulator/Devices/{AppleWatch_Device_ID}/data/Library/Keychains` directory, and the credentials will be copied to the Apple Watch.
3. Run the Apple Watch simulator, then the data will always be in sync through Firebase Firestore.
