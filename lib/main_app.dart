import 'package:flutter/material.dart';
import 'package:multigeo/screens/dispositivos.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DispositivosScreen(),
    );
  }
}