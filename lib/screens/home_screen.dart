import 'package:flutter/material.dart';
import 'package:multigeo/screens/emergencia.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiGeo')),
      body:  Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Nombre de Dispositivo'),
              Switch(value: false, onChanged: null)
            ],
          ),
          Column(
            children: <Widget>[
              const FloatingActionButton(onPressed: null),
              FloatingActionButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const  EmergenciaScreen()),
                  );
                },
              child: const Text('Boton de emergencia'),)
            ],
          )
        ]
        ),
    );
  }
}