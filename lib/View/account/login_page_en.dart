import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/View/account/create_account_page_en.dart';
import 'package:flutter_application_1/utils/firestore/user_firestore.dart';

import '../../utils/authentication.dart';
import '../calendar_en.dart';

class LoginPageEn extends StatefulWidget {
  const LoginPageEn({super.key});

  @override
  State<LoginPageEn> createState() => _LoginPageEnState();
}

class _LoginPageEnState extends State<LoginPageEn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _checkpass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
            child: Center(
                child: Text(
              'Welcome to Goal Focus!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      'Email',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: 'example@email.com'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      'Password',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        obscureText: _checkpass,
                        controller: passController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_checkpass
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _checkpass = !_checkpass;
                                });
                              },
                            ),
                            hintText: '8 to 16 alphanumeric'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: Center(
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: 'Click here',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CreateAccountPageEn()));
                          }),
                    const TextSpan(text: ' if you don\'t have an account'),
                  ])),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: const Size(200, 50)),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              var result = await Authentication.emailSignIn(
                  email: emailController.text, pass: passController.text);
              if (result is UserCredential) {
                if (result.user != null) {
                  // ignore: no_leading_underscores_for_local_identifiers
                  var _result = await UserFirestore.getUser(result.user!.uid);
                  if (_result == true) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const CalendarEn())));
                  }
                }
              }
            },
          ),
        ],
      ),
    ));
  }
}
