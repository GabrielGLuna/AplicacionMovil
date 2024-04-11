import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum UserRole {admin, user, superAdmin}

class RegisterProvider extends ChangeNotifier{
   final FirebaseAuth _auth  = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FirebaseStorage _storage = FirebaseStorage.instance;


 //RegisterProvider(){
 // chekSign();
 //}
 Future<void> registroUser({
  required String username,
  required String email,
  required String password,
  required UserRole rol,
  required String birth,
  required String age,
  required String  token,
  required String createAt,
  required File? image,
 // required Function onSuccess,
  required Function(String) onError,
 }) async{
  try{
    //Convertir el username a minusculas
    final String usernameLowerCase = username.toLowerCase();

    // verificar si el ususario ya existe
    final bool userExist = await checkUserExist(usernameLowerCase);
    if(userExist){
      onError('El usuario ya existe');
      return;
    }

    //verificar las credenciales
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
       password: password);
    final User user = userCredential.user!;
    final String userid = user.uid;

    //subir la imagen al storage
    String imageUrl = '';
    if(image != null){
      String direction = 'users/$username/$userid.jpg';
    }

    //guardar los datos
    final userDatos = {
      'id' : userid,
      'username': username,
      'username_lowercase': usernameLowerCase,
      'password' : password,
      'email' : email,
      'rol' : rol,
      'birth' : birth,
      'age' : age,
      'token' : token,
      'image': imageUrl,
      'createAt':createAt,
    };
    await _firestore.collection('users').doc(userid).set(userDatos);

  }on FirebaseAuthException catch(e){
  if(e.code == 'weak-password'){
    onError('La contraseña es muy debil');
  }else if(e.code == 'email-already-in-use'){
    onError('el email ya esta en uso');
  }else{
    onError(e.toString());
  }
  
  }
  catch (e) {
    onError("Error al registrar al usuario");
  }
  
 }
 //metodo para verificar si el usuario ya  existe
 Future<bool> checkUserExist(String username) async{
  final QuerySnapshot result = await _firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
  return result.docs.isNotEmpty;
 }

 //metodo para guardar la imagen en el storage y obtener la url
 Future<String> uploadImage(String ref, File file) async{
  final UploadTask uploadTask = _storage.ref(ref).child(ref).putFile(file);
  final TaskSnapshot taskSnapshot = await uploadTask;
  final String url = await taskSnapshot.ref.getDownloadURL();
  return url;
 }
}