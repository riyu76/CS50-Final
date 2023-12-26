import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/main.dart';
import 'package:todolist/services/auth/auth_exceptions.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/views/register_view.dart';
import 'dart:developer' as devtools show log;

import 'package:todolist/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Column(
        children: [
          const Icon(
            Icons.lock_outline,
            size: 200,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'Login',
            textScaleFactor: 2.4,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _email,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your Email',
                labelText: 'Email',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  }
                } else {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const VerifyEmailView(),
                      ),
                      (route) => false,
                    );
                  }
                }
                devtools.log('Login --> Home page');
              } on InvalidLoginCredentialsAuthException {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid Login Credentials")));
                }
              } on GenericAuthException catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login failed")));
                }
              }
            },
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 155),
              ),
              shape: MaterialStatePropertyAll(
                ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(17),
                  ),
                ),
              ),
              backgroundColor: MaterialStatePropertyAll(Color(0xffcb2614)),
            ),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const RegisterView(),
                ),
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register Now!'),
          ),
        ],
      ),
    );
  }
}
