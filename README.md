# 📅 Deadline Manager

A personal deadline and task management iOS app built as the final project for **Duke ECE564 (Fall 2022)**.

> **Team Members:** Sophie Shi, Tianjun Mo, Jinyi Xie  

---

## ✨ Features

Stay focused on the present and prepared for the future:

- **What’s due today**: Stay on top of urgent tasks.
- **What’s due soon**: Plan ahead with upcoming deadlines.
- **Monthly and Daily Views**: See the big picture or drill down to the day.
- **Custom Tags**: Organize events with meaningful categories.
- **Sakai Integration**: Sync assignments automatically from Sakai.
- **Push Notifications**: Get notified before deadlines hit.
- **Calendar Sync**: Keep all your devices in sync with your schedule.
- **Location-aware Tasks**: Add event locations using built-in map search.
- **Apple Watch Support**: View and sync tasks directly from your wrist.
- **Quick Edit**: Just tap to view, update, or edit task details.

---

## 📆 Calendar

Calendar UI is based on this helpful [YouTube tutorial](https://www.youtube.com/watch?v=jBvkFKhnYLI).

---

## ☁️ Firebase Integration

We use **Firebase Realtime Database** to persist user data and sync it across devices in real time.  
User credentials are stored securely using **Keychain**, allowing seamless sync between a user's devices.

### 🔁 Test Device Sync (Simulators)

If you'd like to simulate syncing across multiple devices (e.g., iPhone and iPad simulators):

1. Run the app on the iPhone simulator. It will create an anonymous user and save credentials to Keychain.
2. Copy Keychain files from iPhone simulator:
```
~/Library/Developer/CoreSimulator/Devices/{iPhone_Device_ID}/data/Library/Keychains
```
3. Paste them into the iPad simulator directory:
```
~/Library/Developer/CoreSimulator/Devices/{iPad_Device_ID}/data/Library/Keychains
```
4. Launch the app on the iPad simulator. The data will now sync via Firebase.

📽️ **Demo**: [Syncing between devices](https://drive.google.com/file/d/1iKjoxApPIIkFu_pGanktD_6zHsT3MeLb/view)

---

## ⌚ Apple Watch Integration

We use **WatchConnectivity** to sync events between iPhone and Apple Watch.  
The watch app fetches event data from the paired iPhone on launch to ensure consistency.

---

## 📌 Project Highlights

- Built in Swift for iOS and WatchOS.
- Firebase-powered real-time sync.
- Intuitive UI/UX for productivity on the go.
- Real-world sync testing with simulators and real devices.

---

## 🧱 Data Model Overview

Deadline Manager uses a JSON-based local model to store and sync user events. Below are the key data structures:

### 🔹 `Event`

Represents a single task or assignment:

- `id`: Unique ID (UUID)
- `title`: Combined course and task name
- `created_at`: Creation timestamp
- `due_at`: Deadline (defaults to today at 23:59:59)
- `completed_at`: Optional completion timestamp
- `tag`: List of tags
- `desc`: Description (HTML)
- `location`: Optional location
- `is_completed`: Completion status
- `is_deleted`: Soft delete flag
- `source`: `Default` or `Sakai`
- `source_url`: Optional URL for external source
- `source_id`: External source ID
- `color`: Optional event color (default: blue)

### 🔸 `Source`

Event origin:
- `Default`
- `Sakai`

### 🔹 `SakaiSession`

Used for Sakai integration:
- `cookies`: Auth cookies
- `username`: Sakai username

### 🔸 `RecurrentEvent`

Wraps an `Event` with recurrence info:
- `start_time`: When the recurrence starts
- `end_time`: Optional end time
- `schedule`: Recurrence rule (via `EKRecurrenceRule`)

### 💾 Storage

All `Event` instances are stored in a local file: `events.json → [Event]

> For more details, see the [Project Documentation](https://docs.google.com/document/d/1p4swxZ8kndHcXNgQTuRm10pHnKqNCB5oeElfsutgZBc/edit)

---

## 📖 License

This project was created for educational purposes as part of Duke ECE564 and is not currently licensed for production use.

---

