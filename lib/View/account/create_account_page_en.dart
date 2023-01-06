import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/View/account/login_page.dart';
import 'package:flutter_application_1/View/calendar.dart';
import 'package:flutter_application_1/model/account.dart';
import 'package:flutter_application_1/utils/authentication.dart';
import 'package:flutter_application_1/utils/firestore/user_firestore.dart';

class CreateAccountPageEn extends StatefulWidget {
  const CreateAccountPageEn({super.key});

  @override
  State<CreateAccountPageEn> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPageEn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passCheckController = TextEditingController();

  bool _checkpass1 = true;
  bool _checkpass2 = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Welcome to Goal Focus!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'UserName',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: TextField(
                                controller: usernameController,
                                maxLength: 20,
                                decoration: const InputDecoration(
                                    hintText: 'Your Name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text(
                              'UserID',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: TextField(
                                controller: userIdController,
                                maxLength: 20,
                                decoration: const InputDecoration(
                                    hintText: 'Alphanumeric only'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                maxLength: 16,
                                obscureText: _checkpass1,
                                controller: passController,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_checkpass1
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _checkpass1 = !_checkpass1;
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                          ),
                          Expanded(
                            child: SizedBox(
                              child: TextField(
                                  maxLength: 16,
                                  obscureText: _checkpass2,
                                  controller: passCheckController,
                                  decoration: InputDecoration(
                                    hintText: 'Type password again',
                                    suffixIcon: IconButton(
                                      icon: Icon(_checkpass2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _checkpass2 = !_checkpass2;
                                        });
                                      },
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                            builder: (context) =>
                                                const LoginPage()));
                                  }),
                            const TextSpan(text: ' if you have an account'),
                          ])),
                    ),
                  ),
                ],
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
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (userIdController.text.isNotEmpty &&
                    usernameController.text.isNotEmpty &&
                    passController.text == passCheckController.text) {
                  var result = await Authentication.signUp(
                      email: emailController.text, pass: passController.text);
                  if (result is UserCredential) {
                    Account newAccount = Account(
                        id: result.user!.uid,
                        name: usernameController.text,
                        userId: userIdController.text);
                    // ignore: no_leading_underscores_for_local_identifiers
                    var _result = await UserFirestore.setUser(newAccount);
                    if (_result == true) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const Calendar())));
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
