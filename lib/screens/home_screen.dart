import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiGeo')),
      body: const Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Nombre de Dispositivo'),
              Switch(value: false, onChanged: null)
            ],
          ),
          Column(
            children: <Widget>[
              FloatingActionButton(onPressed: null),
              FloatingActionButton(onPressed: null)
            ],
          )
        ]
        ),
    );
  }
}