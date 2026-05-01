import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskManage extends StatefulWidget {
  const TaskManage({super.key});

  @override
  State<TaskManage> createState() => _TaskManageState();
}

class _TaskManageState extends State<TaskManage> {
  final _controller = TextEditingController();

  List<List<dynamic>> toDoList = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // -------- LOAD DATA --------
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedList = prefs.getStringList('TODO_LIST');

    if (savedList != null) {
      setState(() {
        toDoList = savedList.map<List<Object>>((item) {
          final parts = item.split('|');
          return [parts[0], parts[1] == 'true'];
        }).toList();
      });
    }
  }

  // -------- SAVE DATA --------
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> stringList = toDoList
        .map((task) => "${task[0]}|${task[1]}")
        .toList();

    await prefs.setStringList('TODO_LIST', stringList);
  }

  // -------- CHECKBOX --------
  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveData();
  }

  // -------- ADD TASK --------
  void saveNewTask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      toDoList.add(<Object>[_controller.text.trim(), false]);
      _controller.clear();
    });

    saveData();
  }

  // -------- DELETE --------
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveData();
  }

  // -------- ADD TASK DIALOG (NEW) --------
  void createNewTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter task..."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                saveNewTask();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade300,

      // -------- CUSTOM APP BAR --------
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createNewTaskDialog,
          ),
        ],
      ),

      // -------- BODY --------
      body: SafeArea(
        child: toDoList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 90,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "You're All Set!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Start by adding a new task",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index) {
                  return TodoListWidget(
                    taskName: toDoList[index][0],
                    taskComplete: toDoList[index][1],
                    onChanged: (value) => checkBoxChanged(index),
                    deleteFunction: (context) => deleteTask(index),
                  );
                },
              ),
      ),

      // -------- FLOATING INPUT (OPTIONAL KEEP) --------
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Quick add task...",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              backgroundColor: Colors.white,
              child: const Icon(Icons.add, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }
}

// -------- ITEM WIDGET --------

//  ----------- TodoListWidget -----------
class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    super.key,
    required this.taskName,
    required this.taskComplete,
    required this.onChanged,
    required this.deleteFunction,
  });
  final String taskName;
  final bool taskComplete;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                side: BorderSide.none,
                // side: BorderSide(color: Colors.white, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                value: taskComplete,
                onChanged: onChanged,
                activeColor: Colors.white,
                checkColor: Colors.deepOrange,
                fillColor: WidgetStateProperty.all<Color?>(Colors.white),
              ),
              Text(
                taskName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: taskComplete ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
