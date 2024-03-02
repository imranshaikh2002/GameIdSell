import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool secureText;
  final TextInputType keyboard;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.secureText,
      required this.keyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: secureText,
      keyboardType: keyboard,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class SellerDetailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool secureText;
  final TextInputType keyboard;
  const SellerDetailTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.secureText,
      required this.keyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: -1.5,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: secureText,
        keyboardType: keyboard,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

Widget contactTextField(title, n, controller, {textarea = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(95, 164, 154, 154),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        hintText: "Enter $title",
        labelText: title,
        border: InputBorder.none,
      ),
      maxLines: textarea ? 5 : 1,
    ),
  );
}
