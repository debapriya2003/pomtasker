import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer & Task Tracker',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
        buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: PomodoroHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PomodoroHome extends StatefulWidget {
  @override
  _PomodoroHomeState createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  int workDuration = 25;
  int breakDuration = 5;
  int longBreakDuration = 15;
  int pomodorosBeforeLongBreak = 4;

  int completedPomodoros = 0;
  int totalPomodorosToday = 0;
  bool isWorkTime = true;
  bool isRunning = false;
  int timeLeft = 25 * 60; // in seconds

  Timer? timer;

  List<Map<String, dynamic>> tasks = [];
  String filter = "all";
  final TextEditingController taskController = TextEditingController();

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          t.cancel();
          onTimerComplete();
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    pauseTimer();
    setState(() {
      isWorkTime = true;
      completedPomodoros = 0;
      timeLeft = workDuration * 60;
    });
  }

  void onTimerComplete() {
    setState(() {
      isRunning = false;
      if (isWorkTime) {
        completedPomodoros++;
        totalPomodorosToday++;
        bool isLongBreak = completedPomodoros % pomodorosBeforeLongBreak == 0;
        isWorkTime = false;
        timeLeft = (isLongBreak ? longBreakDuration : breakDuration) * 60;
        showSnack("Time for a ${isLongBreak ? 'long ' : ''}break!");
      } else {
        isWorkTime = true;
        timeLeft = workDuration * 60;
        showSnack("Back to work!");
      }
    });
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  void addTask() {
    if (taskController.text.trim().isEmpty) return;
    setState(() {
      tasks.insert(0, {
        "id": DateTime.now().millisecondsSinceEpoch,
        "text": taskController.text.trim(),
        "completed": false,
        "pomodoros": 0
      });
      taskController.clear();
    });
  }

  void toggleTask(int id) {
    setState(() {
      final task = tasks.firstWhere((t) => t["id"] == id);
      task["completed"] = !task["completed"];
    });
  }

  void deleteTask(int id) {
    setState(() {
      tasks.removeWhere((t) => t["id"] == id);
    });
  }

  void clearCompleted() {
    setState(() {
      tasks.removeWhere((t) => t["completed"]);
    });
  }

  List<Map<String, dynamic>> get filteredTasks {
    if (filter == "active") return tasks.where((t) => !t["completed"]).toList();
    if (filter == "completed") return tasks.where((t) => t["completed"]).toList();
    return tasks;
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro Timer & Task Tracker", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // TIMER SECTION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(formatTime(timeLeft),
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: startTimer, child: const Text("Start")),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: pauseTimer, child: const Text("Pause")),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: resetTimer, child: const Text("Reset")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      settingInput("Work", workDuration, (v) {
                        setState(() {
                          workDuration = v;
                          if (isWorkTime) timeLeft = v * 60;
                        });
                      }),
                      settingInput("Break", breakDuration, (v) {
                        setState(() => breakDuration = v);
                      }),
                      settingInput("Long Break", longBreakDuration, (v) {
                        setState(() => longBreakDuration = v);
                      }),
                      settingInput("Before Long", pomodorosBeforeLongBreak, (v) {
                        setState(() => pomodorosBeforeLongBreak = v);
                      }),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TASK SECTION
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("$completedPomodoros / $totalPomodorosToday Pomodoros Today"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: const InputDecoration(
                              hintText: "Add a new task...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: addTask, child: const Text("Add")),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        filterBtn("All"),
                        filterBtn("Active"),
                        filterBtn("Completed"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: filteredTasks.map((task) {
                          return ListTile(
                            leading: Checkbox(
                              value: task["completed"],
                              onChanged: (_) => toggleTask(task["id"]),
                            ),
                            title: Text(task["text"],
                                style: TextStyle(
                                  decoration: task["completed"]
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                )),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteTask(task["id"]),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${tasks.where((t) => !t["completed"]).length} tasks left"),
                        TextButton(onPressed: clearCompleted, child: const Text("Clear Completed")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingInput(String label, int value, Function(int) onChanged) {
    final controller = TextEditingController(text: value.toString());
    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onSubmitted: (val) {
          if (val.isNotEmpty) {
            onChanged(int.parse(val));
          }
        },
      ),
    );
  }

  Widget filterBtn(String name) {
    final lower = name.toLowerCase();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => setState(() => filter = lower),
        style: OutlinedButton.styleFrom(
          backgroundColor: filter == lower ? Colors.black : Colors.white,
        ),
        child: Text(name,
            style: TextStyle(
              color: filter == lower ? Colors.white : Colors.black,
            )),
      ),
    );
  }
}
