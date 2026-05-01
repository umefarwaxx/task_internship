import 'package:flutter/material.dart';
import 'package:flutter_week2/todo_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetstateCounterPage extends StatefulWidget {
  const SetstateCounterPage({super.key});

  @override
  State<SetstateCounterPage> createState() => _SetstateCounterPageState();
}

class _SetstateCounterPageState extends State<SetstateCounterPage> {
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  void _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
  }

  int _counter = 0;

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _saveCounter();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter App',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _counter.toString(),
              style: TextStyle(fontSize: 90, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetCounter();
                  },
                  child: Icon(Icons.restore),
                ),
                ElevatedButton(
                  onPressed: () {
                    _incrementCounter();
                  },
                  child: Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    _decrementCounter();
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            ),
            SizedBox(height: 80),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoListPage()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text(
                "Go to Task App",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
