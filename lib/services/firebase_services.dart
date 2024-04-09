import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {

FirebaseFirestore db = FirebaseFirestore.instance;

//funcion que trae la informacion
Future<List<Map<String, dynamic>>> getLatLong() async {
  List<Map<String, dynamic>> ubicacion = [];

  CollectionReference collectionReferenceUbicacion = db.collection('Ubicacion');

  QuerySnapshot queryUbicacion = await collectionReferenceUbicacion.get();

  for (var documento in queryUbicacion.docs) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    if (data['Lat'] is num && data['Long'] is num) {
      ubicacion.add({
        'Lat': data['Lat'],
        'Long': data['Long'],
      });
    }
  }

  return ubicacion;
}
  
}