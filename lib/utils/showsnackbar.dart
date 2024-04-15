import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black38,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "Mon8"
        ),
      ),
    )
  );
}