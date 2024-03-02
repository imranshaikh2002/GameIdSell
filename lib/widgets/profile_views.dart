import 'package:flutter/material.dart';

class ProfileButtons extends StatelessWidget {
  final Text text;
  final Icon icon;
  final Function() func;
  const ProfileButtons({
    Key? key,
    required this.text,
    required this.icon,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.all(
          8,
        ),
        margin: const EdgeInsets.all(
          8,
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
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: icon,
            ),
            text,
          ],
        ),
      ),
    );
  }
}
