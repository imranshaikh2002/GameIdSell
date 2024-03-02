import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamezone/Dialogs/show_error_dialog.dart';
import 'package:gamezone/constants/routes.dart';
import 'package:gamezone/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                CustomTextField(
                  controller: emailController,
                  hintText: "Enter your Email",
                  secureText: false,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Enter your Password",
                  secureText: true,
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
                      final email = emailController.text;
                      final password = passwordController.text;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = FirebaseAuth.instance.currentUser;
                        if (user?.emailVerified ?? false) {
                          navigator.pushNamedAndRemoveUntil(
                            mainPageScreenRoute,
                            (route) => false,
                          );
                        } else {
                          navigator.pushNamed(
                            verifyEmailScreenRoute,
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showErrorDialog(
                            context,
                            "User not founded",
                          );
                        } else if (e.code == 'wrong-password') {
                          showErrorDialog(
                            context,
                            "Wrong Credentials",
                          );
                        } else {
                          showErrorDialog(
                            context,
                            "Authentication Error",
                          );
                        }
                      } catch (e) {
                        showErrorDialog(
                          context,
                          e.toString(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Login",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {}, child: const Text("Forgot password?"))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(registerScreenRoute);
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                  },
                  child: const Text("Resend Email Verification"),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
