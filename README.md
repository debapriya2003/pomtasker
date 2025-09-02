

# ⏱️ Pomodoro Timer & Task Tracker (POMTASKER)

A **minimal Pomodoro Timer with task tracking** built entirely in **Flutter (single `main.dart` file)**.
This app helps you boost productivity using the **Pomodoro technique** while keeping track of tasks.

---

## ✨ Features

* ⏱ **Pomodoro Timer**

  * Start, Pause, Reset timer
  * Configurable **Work, Break, and Long Break durations**
  * Auto cycle between work and breaks
* ✅ **Task Manager**

  * Add, complete, and delete tasks
  * Filter tasks: **All / Active / Completed**
  * Clear all completed tasks
* 📊 **Pomodoro Counter**

  * Track daily completed Pomodoros
* 🎨 **Minimal 2D Flat UI**

  * White background + black 2px borders
  * Clean and distraction-free design
* 📱 **Responsive Layout**

  * Works on both Android & iOS
  * Auto-adjusts when keyboard opens

---

## 📂 Project Structure

```
/pomodoro_flutter
│── main.dart     # Single file app (timer + tasks)
│── README.md     # Documentation
```

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/debapriya2003/pomodoro_flutter.git
cd pomodoro_flutter
```

### 2. Run the app

```bash
flutter pub get
flutter run
```

### 3. Modify Timer Defaults (Optional)

Inside `main.dart`, you can change:

```dart
int workDuration = 25;       // default 25 min
int breakDuration = 5;       // default 5 min
int longBreakDuration = 15;  // default 15 min
int pomodorosBeforeLongBreak = 4;
```

---
---

## 💡 Future Improvements

* 🔔 Sound notifications (tick + alarm)
* 🌙 Dark mode toggle
* 📊 Statistics dashboard (weekly/monthly Pomodoro report)
* 💾 Save tasks & settings with persistent storage

---

## 🛠 Built With

* [Flutter](https://flutter.dev/) (Dart)
* **Single file app (main.dart)** – no extra dependencies

---

## 📜 License

This project is **open-source** and available under the [MIT License](LICENSE).

---
