import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/Models/register_user.dart';
import 'package:gamezone/constants/routes.dart';
import 'package:gamezone/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/user.jpg",
                    height: 150,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Enter your Email",
                    secureText: false,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter your Password",
                    secureText: true,
                    keyboard: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    hintText: "Enter your username",
                    secureText: false,
                    keyboard: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 43,
                    width: 500,
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        final username = _usernameController.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          final registerData = RegisterUser(
                            uid: userCredential.user!.uid,
                            username: username,
                            email: email,
                          );

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(
                                registerData.toMap(),
                              );

                          final user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          navigator.pushNamedAndRemoveUntil(
                            loginScreenRoute,
                            (route) => false,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showErrorDialog(context, "Weak password");
                          } else if (e.code == 'email-already-in-use') {
                            showErrorDialog(context, "Email Already in use");
                          } else if (e.code == 'invalid-email') {
                            showErrorDialog(context, "Invalid Email");
                          } else {
                            showErrorDialog(context, "Authentication Error");
                          }
                        } catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Register",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have a account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(loginScreenRoute);
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
