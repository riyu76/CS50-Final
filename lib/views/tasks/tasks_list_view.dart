import 'package:flutter/material.dart';
import 'package:todolist/services/crud/tasks_service.dart';
import 'package:todolist/services/utilities/dialogs/delete_dialog.dart';

// a callback is a way to make sure a function has finsished before running the next function
// this is usually done be passing the other function as a paramter to the first funcion

// create a new function type
typedef TaskCallback = void Function(DataBaseTask task);

class TasksListView extends StatelessWidget {
  final List<DataBaseTask> tasks;
  // creates a new function that takes DataBaseTask Type as an arguement and returns a void
  final TaskCallback onDeleteTask;
  final TaskCallback onTap;

  const TasksListView({
    super.key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          onTap: () {
            onTap(task);
          },
          title: Text(
            task.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(
                  context, 'Are you sure you want to delete this task?');
              if (shouldDelete == true) {
                onDeleteTask(task);
              } else {
                //empty
              }
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        );
      },
    );
  }
}
