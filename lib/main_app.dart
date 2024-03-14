import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:multigeo/screens/login.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}