import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multigeo/services/local_storage.dart';
import 'package:multigeo/services/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multigeo/provider/login_provider.dart';
import 'package:multigeo/provider/register_provider.dart';
import 'package:multigeo/screens/login/login/login_page.dart';
import 'package:provider/provider.dart';


void main() async {
  Intl.defaultLocale = 'es_ES';
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  await LocalStorage().init();
  final isLogged = LocalStorage().getIsLoggedIn();
  //configiracion de localizacion predeterminada
  runApp(
     MainApp(isLogged: isLogged)
    );
}
class MainApp extends StatelessWidget {
  final bool isLogged;
  // ignore: use_super_parameters
  const MainApp({Key? key, required this.isLogged}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false,create: (_)=> LoginProvider()),
        ChangeNotifierProvider(lazy: false,create: (_)=> RegisterProvider())
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          Locale('es', 'ES'),
          Locale('en', 'US')
        ],
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
