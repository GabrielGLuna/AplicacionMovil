import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _ubicacion = CameraPosition(
    target: LatLng(19.319064, -97.919678),
    zoom: 14.4746,
  );

  static const CameraPosition _rastreador = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(19.319064, -97.919678),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_rastreador));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gabriel"),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _ubicacion,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        }
        ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _goToTheLake, 
      label: const Text('Rastrear!'),
      icon: const Icon(Icons.directions_boat),
    ),
    );
  }
}
