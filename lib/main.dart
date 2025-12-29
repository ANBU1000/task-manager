import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Task Manager',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TaskHomePage(),
    );
  }
}

class Task {
  String title;
  String priority;
  DateTime dueDate;

  Task({required this.title, required this.priority, required this.dueDate});
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final List<Task> tasks = [];

  final TextEditingController titleController = TextEditingController();
  String selectedPriority = 'Medium';
  DateTime selectedDate = DateTime.now();

  void addTask() {
    if (titleController.text.isEmpty) return;

    setState(() {
      tasks.add(Task(
        title: titleController.text,
        priority: selectedPriority,
        dueDate: selectedDate,
      ));
      titleController.clear();
      selectedPriority = 'Medium';
      selectedDate = DateTime.now();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Low':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: selectedPriority,
              items: ['High', 'Medium', 'Low']
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Due Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              child: const Text('Add Task'),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks added'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  priorityColor(task.priority),
                              child: Text(task.priority[0]),
                            ),
                            title: Text(task.title),
                            subtitle: Text(
                              'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
