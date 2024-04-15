import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multigeo/provider/login_provider.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/screens/login/registration/register_page.dart';
import 'package:multigeo/services/local_storage.dart';

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
  // Puedes agregar más reglas de validación aquí según tus necesidades.
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

  //logearse
  void onformLogin(
    String usernameOrEmail,
    String password,
    context,
  ) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if(_formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      final String usernameOrEmailLower = usernameOrEmail.toLowerCase();
      loginProvider.loginUser(
      usernameOrEmail: usernameOrEmailLower,
      password: password,
      onSucces: () async {
        //verificar si el usuario ha verificado su correo electrónico
        User? user = FirebaseAuth.instance.currentUser;
        if(user != null && user.emailVerified){
          setState(() {
            _isLoading = false;
          });
          dynamic userData = await loginProvider.getUserData(user.email!);
          //guardar datos de local
          await LocalStorage().saveUserData(_emailOrEmailController.text, _passwordController.text);
          //guardar estado de inicio de sesion
          await LocalStorage().setIsSignedIn(true);
          //cambiar estado de autenticacion
          loginProvider.checkAuthState();
          //navegar al inicio
          Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DispositivosScreen(userData : userData

                    )),
                  );


        } else{
          setState(() {
            _isLoading = false;
          });
          await showDialog(context: context,
           builder: (context){
            return AlertDialog(
              title: const Text('Verifica tu correo'),
              content: const Text("Por favor verifica tu correo para continuar"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("aceptar"))
              ],
            );
           });
        }
      },
      onError: (String error){
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context, error.toString());
      }
      );
    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 1, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            ),
            child: const Center(
              child: Text('Login', style: TextStyle(color:  Colors.blueAccent, fontSize: 30, fontWeight: FontWeight.bold),),
          ),
      ),
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
                suffixIcon: IconButton(onPressed: () {
                  // Lógica para borrar el contenido del campo de correo
                  _emailOrEmailController.clear();
                  }, icon: const Icon(Icons.cancel, color: Colors.grey),
                 ),
                ),            
                controller: _emailOrEmailController ,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un correo válido';
                    }
                    if (!value.contains('@')) {
                      return 'Ingrese una dirección de correo válida';
                    }
                    return null; // No hay errores
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "******",
                    labelText: "Ingrese su contraseña",
                    suffixIcon: IconButton(
                      icon:  Icon(
                      _isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                    ),
                    onPressed: (){
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    }
                   )),
                   controller: _passwordController,
                   keyboardType: TextInputType.visiblePassword,
                   obscureText: _isObscure,
                   validator: _passwordValidator,
                  ),
                  const SizedBox( height: 20),
                   _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                // Lógica para validar y enviar el formulario
                                onformLogin(
                                  _emailOrEmailController.text,
                                  _passwordController.text,
                                   context);
                              },
                              child: const Text('Iniciar sesión'),
                            ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿No tienes cuenta?"),
                      TextButton(
                        onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                        }, 
                        child: const Text("Registrate"))
                    ],
                  )
              ],
              ),
          ),
        ),
      ),
      ],
      )
    );
  }
}