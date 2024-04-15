import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Asegúrate de importar el paquete ImagePicker

Future<File?> pickImageUser(BuildContext context) async {
  File? image;
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 50,
  );

  if (pickedFile != null) {
    // Asigna el archivo seleccionado a la variable image
    image = File(pickedFile.path);
  } 

  return image; // Devuelve el archivo seleccionado (o null si no se seleccionó ninguno)
}
