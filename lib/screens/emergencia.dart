
import 'package:flutter/material.dart';

class EmergenciaScreen extends StatelessWidget {
  const EmergenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiGeo')),
      body: const Column(
        children: <Widget>[
          
          Column(
            children: <Widget>[
              Text('Se a mandado el mensaje de emergencia')
            ],
          )
        ]
        ),
    );
  }
}