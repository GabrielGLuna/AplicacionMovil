import 'package:flutter/material.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/screens/reigstro.dart';

import 'package:multigeo/theme/app_theme.dart';

class Login extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Login({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bienvenido', style: TextStyle(fontSize: 20.0),),
            const SizedBox(
              height: 40.0,
            ),
            const Text('Email'),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              width: 250, 
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Ingresa tu correo electrónico',
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text('Contraseña'),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              width: 250, 
              child: TextField(  
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Ingresa tu contraseña',
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: 250.0,
              height: 40.0,
              child: iniciarsesion(context),
            ),
            const SizedBox(height: 30.0,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.facebook),
                Icon(Icons.golf_course),
                Icon(Icons.adjust),
              ],
            ),
            const SizedBox(height: 10.0,),
            
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Row(
                      children: [
                        Text('Quieres recuperar tu contraseña?'),
                        TextButton(onPressed: null, child: Text('Recuperala aquí'))
                      ],
                    ),
                     Row(
                      children: [
                        const Text('Eres nuevo?'),
                        registrousuario(context)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextButton registrousuario(BuildContext context) => TextButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistroUsuario()),
                  );
                }, child: const Text('Registrate aquí'));

  
  FloatingActionButton iniciarsesion(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: AppTheme.boton1,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DispositivosScreen()),
      );
    },
    child: const Text('Ingresar', style: TextStyle(color: Colors.white),),
  );
}

  }

