import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(centerTitle:true ,title: const Text('Register', style: TextStyle(color: Colors.blue),)),
      body: const Center(
        child: Text('Register Page'),
      ),
    );
  }
}