import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/constants/routes.dart';
import 'package:todolist/enums/menu_action.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/services/crud/tasks_service.dart';
import 'package:todolist/services/utilities/dialogs/logout_dialog.dart';
import 'package:todolist/services/utilities/dialogs/show_message.dart';
import 'package:todolist/views/login_view.dart';
import 'package:todolist/constants/colors.dart' as my_colors;

import 'package:todolist/views/tasks/tasks_list_view.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  late final TasksService _tasksService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _tasksService = TasksService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        backgroundColor: my_colors.kSecondaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createTaskRoute);
              },
              icon: const Icon(
                Icons.add,
              )),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              if (value == MenuAction.logout) {
                final choice = await showLogOutDialog(
                    context, "Are you sure you want to log out?");
                if (choice == false) {
                  return;
                } else if (choice == true) {
                  await AuthService.firebase().logOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false,
                    );
                  }
                }
              } else if (value == MenuAction.info) {
                await showMessageDialog(
                    context,
                    "Please note that, tasks are daily, meaning that they are removed within a 24-hour period of being added.",
                    "Information");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                // row has two children icon and a text
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Text("Log Out"),
                  ],
                ),
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.info,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                    ),
                    SizedBox(width: 6),
                    Text('Info'),
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 53),
            elevation: 2,
          ),
        ],
      ),
      body: FutureBuilder(
          future: _tasksService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _tasksService.allTasks,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allTasks = snapshot.data as List<DataBaseTask>;
                          if (allTasks.any((task) => task.deadline != null)) {
                            for (DataBaseTask task in allTasks) {
                              DateTime deadline = DateTime.parse(task.deadline!);
                              if (deadline.isBefore(DateTime.now()) || deadline.isAtSameMomentAs(DateTime.now())) {
                                _tasksService.deleteTask(id: task.id);
                              }
                            }
                          }
                          return TasksListView(
                            tasks: allTasks,
                            onDeleteTask: (task) async {
                              await _tasksService.deleteTask(id: task.id);
                            },
                            onTap: (task) async {
                              Navigator.of(context).pushNamed(
                                createTaskRoute,
                                arguments: task,
                              );
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
