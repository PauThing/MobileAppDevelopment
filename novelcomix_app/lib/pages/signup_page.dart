import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:novelcomix_app/design/font_style.dart';
import 'package:novelcomix_app/pages/login_page.dart';
import 'package:novelcomix_app/widgets/textfieldWidget.dart';
import '../design/background_image.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmTextController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool passwordConfirmed() {
    if (_passwordTextController.text.trim() ==
        _confirmTextController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future addDetails(String uid, String username, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'username': username,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        child: Center(
                          child: Text(
                            'NovelComix',
                            style: signinTitle,
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: signupTitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Container(
                        child: forTextField("Username", Icons.person, false,
                            _usernameTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField(
                            "Email", Icons.email, false, _emailTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField("Password", Icons.lock, true,
                            _passwordTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField("Confirm Password", Icons.lock,
                            true, _confirmTextController),
                      ),

                      SizedBox(
                        height: 80,
                      ),

                      //Sign Up Button
                      Container(
                        height: 45,
                        width: 250,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF731942)),
                          onPressed: () {
                            String username = _usernameTextController.text;
                            String email = _emailTextController.text;
                            String password = _passwordTextController.text;

                            if (email.isEmpty ||
                                password.isEmpty ||
                                username.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Registration Failed'),
                                  content:
                                      const Text('Please fill in all details.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return; // Stop further execution
                            } else if (!passwordConfirmed()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ensure your password'),
                                  content: const Text(
                                      'Please make sure the password and confirm password are the same.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            //register new user with email and password
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text)
                                .then((userCredential) {
                              String uid = userCredential.user!.uid;
                              addDetails(uid, _usernameTextController.text,
                                  _emailTextController.text);

                              //To notify the user account have created
                              final snackbar = SnackBar(
                                content: Text(
                                    "Yay, Account Created!\nWelcome $username"),
                                action: SnackBarAction(
                                    label: 'OK', onPressed: () {}),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            }).catchError((error) {
                              //Error occurred when register
                              String errorMessage = '';

                              if (error is FirebaseAuthException) {
                                if (error.code == 'email-already-in-use') {
                                  // Email is already registered
                                  errorMessage =
                                      'Email is already registered. Please use a different email.';
                                } else if (error.code == 'weak-password') {
                                  // Weak Password entered
                                  errorMessage =
                                      'Password is too weak. Please use a different password.';
                                } else if (error.code == 'invalid-email') {
                                  // Invalid email entered
                                  errorMessage = 'Please use a valid email.';
                                } else {
                                  // Other FirebaseAuthException errors
                                  errorMessage =
                                      'An Error Occurred\nError: ${error.code.toString()}';
                                }
                              } else {
                                // Other errors
                                errorMessage = error.code.toString();
                              }

                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title:
                                            const Text("Registration Failed"),
                                        content: Text(errorMessage),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ));
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle,
                          ),
                          label: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            LoginPage.routeName,
                          );
                        },
                        child: const Text(
                          "Already have an account? Click here.",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
