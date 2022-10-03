import 'dart:convert';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          const Text(
            'WATFUN',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset(
                'assets/img/appLogo.png',
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
