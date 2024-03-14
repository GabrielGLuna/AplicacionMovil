import 'package:flutter/material.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/theme/app_theme.dart';

class RegistroDispositivo extends StatelessWidget {
  const RegistroDispositivo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Dispositivo'),),
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
            const SizedBox(height: 10,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Numero de Serie'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none, labelText: 'Ingrese su correo electronico'))
                ],
              )
            ),
            const SizedBox(height: 10,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Nummero de SIM'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none,))
                ],
              )
            ),
            const SizedBox(height: 10,),
            const Text('Botón de Emergencia'),
            const SizedBox(height: 10,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Numero de Telefono'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none, labelText: 'Telefono al que se le mandará el mensaje'))
                ],
              )
            ),
            const SizedBox(height: 10,),
            const SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Mensaje a enviar'),
                  SizedBox(height: 10,),
                  TextField(decoration: InputDecoration(border: InputBorder.none,))
                ],
              )
            ),
            
const SizedBox(height: 10,),
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
                    MaterialPageRoute(builder: (context) =>  DispositivosScreen()),
                  );
                },
                  child: const Text("Registrar", style: TextStyle(color: Colors.white),), );
}