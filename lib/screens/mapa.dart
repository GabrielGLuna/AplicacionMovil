import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multigeo/services/firebase_services.dart';



class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  FirebaseServices _firebaseServices = FirebaseServices(); // Instancia de FirebaseServices

  CameraPosition? _ubicacion;
  CameraPosition? _rastreador;

  Set<Marker> _marcador = {};

  @override
  void initState() {
    super.initState();
    _loadCameraPositions();
  }

Future<void> _loadCameraPositions() async {
  Map<String, dynamic> ubicacion = await _firebaseServices.getLatLong();
  print('Ubicacion: $ubicacion');
  if (ubicacion.isNotEmpty) {
    double lat = double.parse(ubicacion['Lat']);
    double long = double.parse(ubicacion['Long']);
    print('Latitud: $lat, Longitud: $long');

    setState(() {
      _ubicacion = CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.4746,
      );

      _rastreador = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
    });
  }
}


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    if (_rastreador != null) {
      await controller.animateCamera(CameraUpdate.newCameraPosition(_rastreador!));

      setState((){
        _marcador.add(
          Marker(
            markerId: MarkerId(_rastreador!.target.toString()),
            position: _rastreador!.target,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gabriel"),
      ),
      body: _ubicacion != null
          ? GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _ubicacion!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _marcador,
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Rastrear!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}