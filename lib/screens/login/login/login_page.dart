import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final TextEditingController _emailOrEmailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

bool _isObscure = true;
bool _isLoading = false;

static String? token;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text('Vamos')],)
    );
  }
}