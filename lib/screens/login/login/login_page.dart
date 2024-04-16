import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multigeo/provider/login_provider.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/screens/login/registration/register_page.dart';
import 'package:multigeo/services/local_storage.dart';
import 'package:multigeo/theme/app_theme.dart';
import 'package:multigeo/utils/showsnackbar.dart';
import 'package:provider/provider.dart';
import '../../../services/push_notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String? _passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingrese una contraseña';
  }
  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null; // No hay errores
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  static String? token;

  @override
  void initState() {
    super.initState();
    token = PushNotificationService.token;
  }

  @override
  void dispose() {
    super.dispose();
    _emailOrEmailController.dispose();
    _passwordController.dispose();
  }

void onformLogin(String usernameOrEmail, String password, context) async {
  final loginProvider = Provider.of<LoginProvider>(context, listen: false);
  if (_formkey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });
    final String usernameOrEmailLower = usernameOrEmail.toLowerCase();
    loginProvider.loginUser(
      usernameOrEmail: usernameOrEmailLower,
      password: password,
      onSucces: (dispositivos) async {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          setState(() {
            _isLoading = false;
          });
          dynamic userData = await loginProvider.getUserData(user.email!);
          await LocalStorage().saveUserData(_emailOrEmailController.text, _passwordController.text);
          await LocalStorage().setIsSignedIn(true);
          loginProvider.checkAuthState();

          // Pasar userData y dispositivos a DispositivosScreen al navegar a esa pantalla
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DispositivosScreen(),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Verifica tu correo'),
                content: const Text("Por favor verifica tu correo para continuar"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Aceptar"),
                  )
                ],
              );
            },
          );
        }
      },
      onError: (String error) {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context, error.toString());
      },
    );
  } else {
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-app.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Inicio de Sesion', style: TextStyle(fontSize: 25),),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "user@example.com",
                            labelText: "Ingrese su correo o email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _emailOrEmailController.clear();
                              },
                              icon: const Icon(Icons.cancel, color: AppTheme.color2),
                            ),
                          ),
                          controller: _emailOrEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo válido';
                            }
                            if (!value.contains('@')) {
                              return 'Ingrese una dirección de correo válida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "******",
                            labelText: "Ingrese su contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppTheme.color2,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),

                          ),
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isObscure,
                          validator: _passwordValidator,
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              )
                            :  ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppTheme.boton1)
                              ),
                                onPressed: () {
                                  onformLogin(
                                    _emailOrEmailController.text,
                                    _passwordController.text,
                                    context,
                                  );
                                },
                                child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white),),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("¿No tienes cuenta?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text("Registrate", style: TextStyle(color: AppTheme.boton1),),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
