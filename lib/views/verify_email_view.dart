import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/services/auth/auth_service.dart';
import 'package:todolist/views/register_view.dart';
import 'package:todolist/constants/colors.dart' as my_colors;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Verify Email')),
        backgroundColor: my_colors.kSecondaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "We've sent you an email verification. please open it to verify your account.",
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "If you haven't received a verification email yet. press the button below",
                  textAlign: TextAlign.center,
                )),
            TextButton(
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 110),
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
              child: const Text('Send email verification'),
            ),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const RegisterView(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: const Text('Go back'))
          ],
        ),
      ),
    );
  }
}
