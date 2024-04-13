import 'package:flutter/material.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/screens/login/login/login_page.dart';
import 'package:multigeo/screens/add_dispositivo.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Add_dispositivoScreen(),
    );
  }
}