import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  Box? todoBox;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box('todoBox');
  }

  void _addTodo(String title) {
    final newTodo = {
      'title': title,
      'isCompleted': false,
    };
    setState(() {
      todoBox?.add(newTodo);
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      todoBox?.deleteAt(index);
    });
  }

  void _toggleCompletion(int index) {
    final todo = todoBox?.getAt(index);
    todo['isCompleted'] = !todo['isCompleted'];
    setState(() {
      todoBox?.putAt(index, todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List with Hive'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Add a To-Do',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _addTodo(_controller.text);
                _controller.clear();
              }
            },
            child: const Text('Add To-Do'),
          ),
          Expanded(
            child: todoBox != null && todoBox!.isNotEmpty
                ? ListView.builder(
                    itemCount: todoBox!.length,
                    itemBuilder: (context, index) {
                      final todo = todoBox!.getAt(index);
                      return ListTile(
                        title: Text(
                          todo['title'],
                          style: TextStyle(
                            decoration: todo['isCompleted']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Checkbox(
                          value: todo['isCompleted'],
                          onChanged: (_) {
                            _toggleCompletion(index);
                          },
                        ),
                        onLongPress: () {
                          _deleteTodo(index);
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('No tasks added yet'),
                  ),
          ),
        ],
      ),
    );
  }
}
