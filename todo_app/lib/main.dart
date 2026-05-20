import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TodoListScreen()));

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // 1. List to store tasks
  List<String> tasks = ["Learn Flutter", "Finish Assignment"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tasks"), backgroundColor: Colors.teal),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => ListTile(title: Text(tasks[index])),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 2. Navigation to Screen 2 and waiting for data
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );

          // 3. Updating state if data is received
          if (result != null) {
            setState(() {
              tasks.add(result);
            });
          }
        },
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: "Task Name")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _controller.text),
              child: Text("Save Task"),
            )
          ],
        ),
      ),
    );
  }
}