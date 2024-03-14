import 'package:flutter/material.dart';

class AppTheme{
  //declaracion de color 
  static const mainColor = Color.fromARGB(255, 148, 202, 252);
  static const backColor = Color.fromARGB(255, 242, 243, 245);
  static const boton1 = Color.fromARGB(255, 88, 62, 235);
  static const boton2 = Color.fromARGB(255, 223, 88, 26);
  static const boton3 = Color.fromARGB(255, 26, 184, 223);
  

  static final ThemeData lightTheme =  ThemeData.light().copyWith(
    scaffoldBackgroundColor: backColor,);
       
}