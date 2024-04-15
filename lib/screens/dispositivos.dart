import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multigeo/provider/login_provider.dart';
import 'package:multigeo/screens/mapa.dart';
import 'package:multigeo/theme/app_theme.dart';
import 'package:multigeo/provider/dispositivo.dart';
import 'package:provider/provider.dart';

class DispositivosScreen extends StatefulWidget {
  const DispositivosScreen({Key? key}) : super(key: key);

  @override
  _DispositivosScreenState createState() => _DispositivosScreenState();
}

class _DispositivosScreenState extends State<DispositivosScreen> {
  List<Dispositivo> dispositivos = [];

  @override
  void initState() {
    super.initState();
    Provider.of<LoginProvider>(context, listen: false).getDispositivosUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    List<Dispositivo> dispositivos = Provider.of<LoginProvider>(context).dispositivos;

    return Scaffold(
      appBar: AppBar(title: const Text('Dispositivos')),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          final dispositivo = dispositivos[index];
          return DispositivoCard(dispositivo: dispositivo);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarAgregarDispositivoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarAgregarDispositivoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AgregarDispositivoDialog(
          onGuardar: (dispositivo) async {
          final user = FirebaseAuth.instance.currentUser;
              final dispositivosRef = FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('dispositivos');
              await dispositivosRef.add({
                'nombre': dispositivo.nombre,
                'propietario': dispositivo.propietario,
                'usuario_email': user?.email,
              });
            setState(() {
              dispositivos.add(dispositivo);
            });
          },
        );
      },
    );
  }
}


class DispositivoCard extends StatelessWidget {
  final Dispositivo dispositivo;

  const DispositivoCard({Key? key, required this.dispositivo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(dispositivo.nombre),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _navigateToMap(context, dispositivo);
            },
            child: Text("Rastrear a ${dispositivo.propietario}"),
          ),
        ],
      ),
    );
  }

  void _navigateToMap(BuildContext context, Dispositivo dispositivo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapaScreen(dispositivo: dispositivo)),
    );
  }
}

class AgregarDispositivoDialog extends StatelessWidget {
  final Function(Dispositivo) onGuardar;

  const AgregarDispositivoDialog({Key? key, required this.onGuardar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nombreDispositivo = '';
    String propietario = '';

    return AlertDialog(
      title: Text('Agregar Dispositivo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => nombreDispositivo = value,
            decoration: InputDecoration(labelText: 'Nombre del Dispositivo'),
          ),
          TextField(
            onChanged: (value) => propietario = value,
            decoration: InputDecoration(labelText: 'Propietario'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final nuevoDispositivo = Dispositivo(
              nombre: nombreDispositivo,
              propietario: propietario,
            );

            onGuardar(nuevoDispositivo);

            Navigator.of(context).pop();
          },
          child: Text('Guardar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
