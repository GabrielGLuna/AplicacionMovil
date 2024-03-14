

import 'package:flutter/material.dart';
import 'package:multigeo/screens/registrodispositivo.dart';
import 'package:multigeo/theme/app_theme.dart';

class RegistroUsuario extends StatelessWidget {
  const RegistroUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Registro'),),
      body:   Center(
        child: Column(
          children: <Widget>[
             const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Nombre'),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(border: InputBorder.none, labelText: 'Ingrese su nombre'),
                  )
                ],
              )
            ),
            const SizedBox(height: 15,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Email'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none, labelText: 'Ingrese su correo electronico'))
                ],
              )
            ),
            const SizedBox(height: 15,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Contraseña'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none,))
                ],
              )
            ),
            const SizedBox(height: 15,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Confirma tu contraseña'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none))
                ],
              )
            ),
            const SizedBox(height: 15,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Telefono'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none,))
                ],
              )
            ),
            
const SizedBox(height: 15,),
SizedBox(
  width: 200,
  child: registrodispositivo(context)
  )
          ],
        ),
      ),
    );
  }

  FloatingActionButton registrodispositivo(BuildContext context) => FloatingActionButton( 
    backgroundColor: AppTheme.boton3,
    onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistroDispositivo()),
                  );
                },
                  child: const Text("Registrar", style: TextStyle(color: Colors.white),), );
}