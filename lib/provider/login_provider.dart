import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multigeo/provider/dispositivo.dart';

enum AuthStatus { notAuthentication, chacking, authenticated }

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Dispositivo> dispositivos = [];

  AuthStatus authStatus = AuthStatus.notAuthentication;

  Future<void> loginUser({
    required String usernameOrEmail,
    required String password,
    required Function(List<Dispositivo>) onSucces,
    required Function(String) onError,
  }) async {
    try {
      authStatus = AuthStatus.chacking;
      notifyListeners();
      // Ingreso con usuario
      final String usernameOrEmailLowerCase = usernameOrEmail.toLowerCase();
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: usernameOrEmailLowerCase)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        final String email = result.docs.first.get('email');
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        final dispositivos = await getDispositivos(userCredential.user!);
        onSucces(dispositivos);
        return;
      }
      // Para el ingreso con email
      final QuerySnapshot resultEmail = await _firestore.collection('users').where('email', isEqualTo: usernameOrEmailLowerCase).limit(1).get();
      if (resultEmail.docs.isNotEmpty) {
        final String email = resultEmail.docs.first.get('email');
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        final dispositivos = await getDispositivos(userCredential.user!);
        onSucces(dispositivos);
        return;
      }
      onError('No se encontró usuario o email ingresados');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong.password') {
        onError('Usuario o contraseña incorrecta');
      } else {
        onError(e.toString());
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verificar el estado del usuario
  void checkAuthState() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        authStatus = AuthStatus.notAuthentication;
      } else {
        authStatus = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  // Obtener datos del usuario
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();

    if (result.docs.isNotEmpty) {
      final userData = result.docs[0].data();
      return userData;
    }
    return '';
  }

  // Método para obtener dispositivos de un usuario
  Future<List<Dispositivo>> getDispositivos(User user) async {
    try {
      final dispositivosSnapshot = await _firestore.collection('users').doc(user.uid).collection('dispositivos').get();
      final dispositivos = dispositivosSnapshot.docs
          .map((doc) => Dispositivo(
                nombre: doc['nombre'],
                propietario: doc['propietario'],
              ))
          .toList();
      return dispositivos;
    } catch (e) {
      // Manejo de errores
      return []; // En caso de error, devolver una lista vacía
    }
  }
  Future<void> getDispositivosUsuarioActual() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final dispositivosSnapshot = await _firestore.collection('users').doc(user.uid).collection('dispositivos').get();
        dispositivos = dispositivosSnapshot.docs
            .map((doc) => Dispositivo(
                  nombre: doc['nombre'],
                  propietario: doc['propietario'],
                ))
            .toList();
        notifyListeners(); // Notificar a los widgets que dependen de la lista de dispositivos
      }
    } catch (e) {
      print('Error al recuperar dispositivos: $e');
    }
  }
}
