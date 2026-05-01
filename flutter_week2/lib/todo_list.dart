import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _controller = TextEditingController();
  // ----- To Do List -----
  List toDoList = [
    ['Code With sis', false],
    ['Learn Flutter', false],
    ['Drink Coffee', false],
    ['Explore Firebase', false],
  ];

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text("TODO List"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (BuildContext context, index) {
            return TodoListWidget(
              taskName: toDoList[index][0],
              taskComplete: toDoList[index][1],
            );
          },
        ),
      ),
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
                    hintText: "Add a new task",
                    contentPadding: EdgeInsets.symmetric(
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
              child: Icon(Icons.add, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}

//  ----------- TodoListWidget -----------
class TodoListWidget extends StatelessWidget {
  const TodoListWidget({
    super.key,
    required this.taskName,
    required this.taskComplete,
  });
  final String taskName;
  final bool taskComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Text(
            taskName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              decoration: taskComplete ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
        ),
      ),
    );
  }
}
