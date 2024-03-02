import 'package:flutter/material.dart';
import 'package:gamezone/widgets/textfield.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: const Text(
          "Add Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Column(
                  children: [
                    Text(
                      "Hey Imran!!!!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hope you enjoy our service",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SellerDetailTextField(
                  controller: _emailController,
                  hintText: "Enter your Email",
                  secureText: false,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 15,
                ),
                SellerDetailTextField(
                  controller: _passwordController,
                  hintText: "Enter your Password",
                  secureText: true,
                  keyboard: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                SellerDetailTextField(
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Register",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
