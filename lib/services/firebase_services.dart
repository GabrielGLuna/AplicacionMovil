import 'package:firebase_database/firebase_database.dart';

class FirebaseServices {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  Future<Map<String, dynamic>> getLatLong(String nombreDispositivo) async {
    Map<String, dynamic> ubicacion = {};

    // Obtener la referencia a la ubicación en la base de datos
    DatabaseReference ubicacionReference =
        _databaseReference.child(nombreDispositivo);

    // Escuchar cambios en la ubicación una sola vez
    DataSnapshot dataSnapshot = (await ubicacionReference.once()).snapshot;
    var data = dataSnapshot.value;
    print('data: $data');
    if (data != null && data is Map<dynamic, dynamic>) {
      print('Data: $data');
      var latitud = data['latitud'];
      var longitud = data['longitud'];
      if (latitud != null && longitud != null) {
        ubicacion = {'Lat': latitud, 'Long': longitud};
      }
    }

    return ubicacion;
  }
}

