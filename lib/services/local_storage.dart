import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  late Box _userBox;

  Future<void> init() async {
    // Inicializar Hive
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Abrir la caja (Box) para almacenar datos de usuario
    _userBox = await Hive.openBox('userBox');
  }


//limpiar la caja
Future<void> clear() async {
  await _userBox.clear();
}

Future<void> saveUserData(String usernameOrEmail, String password) async {
  // Guardar datos de usuario en la caja
  await _userBox.put('usernameOrEmail', usernameOrEmail);
  await _userBox.put('password', password);
}

//getUserData
Future<dynamic> getUserData(String usernameOrEmail) async {
  // Obtener datos de usuario de la caja
  final String password =
      _userBox.get('password', defaultValue: '') as String;

  // Devolver datos de usuario
  return {
    'usernameOrEmail': usernameOrEmail,
    'password': password,
  };
}

String getEmailOrUsername(){
  //obtenr datos de usuario de la caja
  return _userBox.get('usernameOrEmail', defaultValue: '') as String;
}

String getPassWord(){
  //obtenr datos de usuario de la caja
  return _userBox.get('password', defaultValue: '') as String;
}

Future<void> setIsSignedIn( bool isSignedIn) async{
  //obtenr datos de usuario de la caja
  return _userBox.put('is_signedin', isSignedIn);
}

bool getIsSignedIn(){
  //obtenr datos de usuario de la caja
  return _userBox.get('is_signedin', defaultValue:false) as bool;
}

Future<void> deletIsSignedIn() async{
  //obtenr datos de usuario de la caja
  await _userBox.delete('is_signedin');
}
Future<void> setIsLoggedIn(bool isLoggedIn)async{
  //obtenr datos de usuario de la caja
  return _userBox.put('isLoggedIn', isLoggedIn);
}
bool getIsLoggedIn(){
  //obtenr datos de usuario de la caja
  return _userBox.get('isLoggedIn', defaultValue: false)as bool;
}
Future<bool> getIsFirstTime()async{
  //obtenr el valor de 'IsFirstTime' de la caja
  final bool IsFirstTime = 
    _userBox.get('isFirstTime', defaultValue: true) as bool;

    //si es la primera vez, actualiza el valor a false y devuelve el true
    if (IsFirstTime){
      await _userBox.put('isFirstTime', false);
      return true;
    }
    //si no es la primera vez devuelve false
    return false;
}

Future<void> savePageIndex(int index) async{
  await _userBox.put ('pageIndex', index);
}

int getPageIndex(){
  return _userBox.get('pageIndex', defaultValue: 0) as int;
}
} 