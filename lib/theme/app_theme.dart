import 'package:flutter/material.dart';

class AppTheme{
  AppTheme._();
  //declaracion de color 
  static const mainColor = Color.fromARGB(255, 35, 137, 233);
  static const backColor = Color.fromARGB(255, 242, 243, 245);
  static const boton1 = Color.fromARGB(255, 88, 62, 235);

  static const boton5 = Color.fromARGB(255, 233, 90, 24);
  static const boton6 = Color.fromARGB(255, 13, 248, 103);
  static const boton4 = Color.fromARGB(255, 248, 13, 13);
  

  static const color1 = Color.fromARGB(255, 235, 162, 66);
  static const color2 = Color.fromARGB(255, 121, 118, 115);
  static const color3 = Color.fromARGB(255, 230, 125, 21);



  static const boton2 = Color.fromARGB(255, 223, 88, 26);
  static const boton3 = Colors.blue;
  static const texto = Colors.black;

  
  

  static final ThemeData lightTheme = ThemeData(
    
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 42, 137, 215),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );


  static final ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
                backgroundColor:AppTheme.boton3,
                foregroundColor: AppTheme.texto,
                shadowColor: AppTheme.boton1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
                )
  );

  static final BoxDecoration myFondo = BoxDecoration(
    gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.lightBlue[100]!, Colors.white],
        ),
  );

  static const TextStyle nombreTextos =   TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textoBoton = TextStyle(
    fontSize: 15,
  );

       
 

}