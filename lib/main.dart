import 'package:flutter/material.dart';
import 'package:todolist/constants/routes.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/views/login_view.dart';
import 'package:todolist/views/register_view.dart';
import 'package:todolist/views/tasks/create_update_tasks_view.dart';
import 'package:todolist/views/tasks/tasks_view.dart';
import 'package:todolist/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black))),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white))),
      colorScheme: const ColorScheme.dark(background: Color(0xff121212)),
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      tasksRoute: (context) => const TasksView(),
      createTaskRoute: (context) => const CreateUpdateTaskView(),
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const TasksView();
                } else {
                  return const LoginView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
