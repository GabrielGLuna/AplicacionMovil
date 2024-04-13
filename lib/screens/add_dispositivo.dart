import 'package:flutter/material.dart';

class Add_dispositivoScreen extends StatelessWidget {
  const Add_dispositivoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar(title: Text("Añadir dispositivo"),);
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: Text("Nombre del dueño:")),
            SizedBox(
              height: 50,
              width: 350,
              child: TextField(
              decoration: InputDecoration(
                label: Text("Ingresa el nombre"),
              ),
              ),
            ),
            SizedBox(
              height: 50,
              child: Text("Nombre del dispositivo:"
              )),
            SizedBox(
              width: 350,
              child: TextField(
              decoration: InputDecoration(
                label: Text("Ingresa el nombre"),
                border: InputBorder.none
              ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}