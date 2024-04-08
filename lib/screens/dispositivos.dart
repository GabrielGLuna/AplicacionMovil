import 'package:flutter/material.dart';
import 'package:multigeo/screens/mapa.dart';
import 'package:multigeo/theme/app_theme.dart';
class DispositivosScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Dispositivos'),),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
           SizedBox(
            width: 300,
            height: 200,
            child: dispositivocard(context)
            ),
          ],
        ),
      ),
    );
  }

  Card dispositivocard(BuildContext context) {
    return  Card(
           // ignore: avoid_unnecessary_containers
           child: Container(
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
               const  Text('Dispositivo 1'),
               const  SizedBox(height: 100,),
                SizedBox(
                  width: 300,
                  child: dispositivohome(context),
                ),
              ],
            ),)
           );
  }

  FloatingActionButton dispositivohome(BuildContext context) {
    return  FloatingActionButton(
                  backgroundColor: AppTheme.boton2,
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapaScreen()),
                  );
                },
                  child: const Text("Localizar a Gabriel", style: TextStyle(color: Colors.white),),                     
                  );
  }
}