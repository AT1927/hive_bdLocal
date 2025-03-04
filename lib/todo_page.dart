import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  Box? todoBox;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box('todoBox');
  }

  void _addTodo(String title, int quantity, String hour) {
    final newTodo = {
      'title': title,
      'quantity': quantity,
      'hour': hour,
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
        title: const Text('Lista de Medicamentos con Hive'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Medicamento',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _hourController,
              decoration: const InputDecoration(
                labelText: 'Hora',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _quantityController.text.isNotEmpty &&
                  _hourController.text.isNotEmpty) {
                _addTodo(
                  _titleController.text,
                  int.parse(_quantityController.text),
                  _hourController.text,
                );
                _titleController.clear();
                _quantityController.clear();
                _hourController.clear();
              }
            },
            child: const Text('Agregar Medicamento'),
          ),
          Expanded(
            child: todoBox != null && todoBox!.isNotEmpty
                ? ListView.builder(
                    itemCount: todoBox!.length,
                    itemBuilder: (context, index) {
                      final todo = todoBox!.getAt(index);
                      return ListTile(
                        title: Text(
                          '${todo['title']} - Cantidad: ${todo['quantity']} - Hora: ${todo['hour']}',
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
                    child: Text('No se han agregado medicamentos aún'),
                  ),
          ),
        ],
      ),
    );
  }
}
