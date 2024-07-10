

import 'package:flutter/material.dart';
import 'package:untitled5/Cubit/Cubit.dart';

class AddTaskDialog extends StatelessWidget {
  // final Future<void> Function({required String title, required String description}) insertToDatabase;
  //
  // AddTaskDialog({required this.insertToDatabase});
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: ()  {
            AppCubit.get(context).insertToDatabase(
              title: _titleController.text,
              description: _descriptionController.text,
            );
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

}
