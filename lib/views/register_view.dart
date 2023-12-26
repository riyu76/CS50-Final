import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/services/auth/auth_exceptions.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/views/login_view.dart';
import 'dart:developer' as devtools show log;
import 'package:todolist/views/verify_email_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      body: Column(
        children: [
          const Icon(
            Icons.lock_open,
            size: 200,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'Register',
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
                      borderSide: BorderSide(color: Colors.blue, width: 2))),
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
              if (password.length >= 8) {
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const VerifyEmailView(),
                      ),
                      (route) => false,
                    );
                  }
                } on WeakPasswordAuthException {
                  devtools.log("Weak password");
                  const snackBar = SnackBar(
                    content: Text('Weak Password'),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } on EmailAlreadyInUseAuthException {
                  devtools.log('Email already in use');
                  const snackBar = SnackBar(
                    content: Text('Email already in use'),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } on InvalidEmailAuthException {
                  devtools.log('Invalid Email');
                  const snackBar = SnackBar(
                    content: Text('Invalid Email'),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } on GenericAuthException {
                  devtools.log('Authentication failed');
                  const snackBar = SnackBar(
                    content: Text('Authentication failed'),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              } else {
                devtools.log('Password should be at least 8 characters long');
                const snackBar = SnackBar(
                  content:
                      Text('Password should be at least 8 characters long'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 150),
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
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const LoginView(),
                ),
                (route) => false,
              );
            },
            child: const Text('Already have an account? Click Here!'),
          )
        ],
      ),
    );
  }
}
