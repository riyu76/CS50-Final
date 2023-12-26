import 'package:flutter/material.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/services/crud/tasks_service.dart';
import 'package:todolist/services/utilities/generics/get_arguments.dart';
import 'package:todolist/constants/colors.dart' as my_colors;

class CreateUpdateTaskView extends StatefulWidget {
  const CreateUpdateTaskView({super.key});

  @override
  State<CreateUpdateTaskView> createState() => _CreateUpdateTaskViewState();
}

class _CreateUpdateTaskViewState extends State<CreateUpdateTaskView> {
  DataBaseTask? _task;
  late final TasksService _tasksService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _tasksService = TasksService();
    _textController = TextEditingController();
    super.initState();
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DataBaseTask> createOrGetExistingTask(BuildContext context) async {
    // get the task from the argument(task) passed to the widget from the previous screen
    final widgetTask = context.getArgument<DataBaseTask>();

    if (widgetTask != null) {
      _task = widgetTask;
      _textController.text = widgetTask.text;
      return widgetTask;
    }

    // checks if the task already exist incase it does, return the task
    final existingTask = _task;
    if (existingTask != null) {
      return existingTask;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    // returns a DataBaseUser with an email and an id with the user's email
    final owner = await _tasksService.getUser(email: email);
    final newTask = await _tasksService.createTask(owner: owner);
    _task = newTask;
    return newTask;
  }

  void _deleteTaskIfTextIsEmpty() {
    final task = _task;
    if (_textController.text.isEmpty && task != null) {
      _tasksService.deleteTask(id: task.id);
    }
  }

  void _textControllerListener() async {
    final task = _task;
    // devtools.log(task.toString());
    if (task == null) {
      return;
    }
    // causing error
    final text = _textController.text;
    await _tasksService.updateTask(task: task, text: text);
  }

  void _saveTaskIfTextNotEmpty() async {
    final task = _task;
    final text = _textController.text;
    if (task != null && text.isNotEmpty) {
      await _tasksService.updateTask(
        task: task,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteTaskIfTextIsEmpty();
    _saveTaskIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Task"),
          backgroundColor: my_colors.kSecondaryColor,
        ),
        body: FutureBuilder(
          future: createOrGetExistingTask(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // get the latest informantion returned by the future which in this case applies to createNewTask
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your task...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
