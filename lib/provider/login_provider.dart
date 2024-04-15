
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus{notAuthentication, chacking, authenticated}
class LoginProvider extends ChangeNotifier{
 final FirebaseAuth _auth  = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 AuthStatus authStatus = AuthStatus.notAuthentication;

 Future<void> loginUser({
  required String usernameOrEmail,
  required String password,
  required Function onSucces,
  required Function(String) onError
 }) async{
  try{
    authStatus = AuthStatus.chacking;
    notifyListeners();
    //ingreso con user
    final String usernameOrEmaiLowerCase =usernameOrEmail.toLowerCase();
    final QuerySnapshot result = await _firestore.collection('users').where('username_lowercase', isEqualTo: usernameOrEmaiLowerCase).limit(1).get();
    if(result.docs.isNotEmpty){
      final String email =result.docs.first.get('email');
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      onSucces();
      return;
    }
     //para el ingreso con email
    final QuerySnapshot resultEmail = await _firestore.collection('users').where('email', isEqualTo: usernameOrEmaiLowerCase).limit(1).get();
    
     if (resultEmail.docs.isNotEmpty){
     final String email = resultEmail.docs.first.get('email');
     final UserCredential userCredential = 
      await _auth.signInWithEmailAndPassword(email: email, password: password);
     onSucces();
     return;
     }

     onError('No se encontrò usuario o email  ingresados');
  }on FirebaseAuthException catch(e){
    if(e.code == 'user-not-found' || e.code == 'wrong.password'){

    onError('Usuario o contraseña inncorrecta');
    }else{
      onError(e.toString());
    }
  }
  catch(e){
    onError(e.toString());
  }
 }

 //verificar el estado del usuario
 void checkAuthState(){
  _auth.authStateChanges().listen((User? user) {
   if(user == null){
    authStatus = AuthStatus.notAuthentication;
   } else{
    authStatus = AuthStatus.authenticated;
   }
   notifyListeners();
   });
 }


 //obtener datos del usuario
 Future<dynamic> getUserData(String email) async{
  final QuerySnapshot<Map<String, dynamic>> result = await _firestore
  .collection('users')
  .where('email', isEqualTo: email)
  .limit(1)
  .get();

  if(result.docs.isNotEmpty){
   final userData = result.docs[0].data();
   return userData;
  }
  return '';

 }
}