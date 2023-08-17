import 'package:cripto_github/pages/cotacao_page.dart';
import 'package:cripto_github/pages/home_page.dart';
import 'package:cripto_github/pages/login_page.dart';
import 'package:cripto_github/pages/registrar_page.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        '/registrar': (context) => RegistroPage(),
        '/cotacao': (context) => CotacaoPage(),
      },
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    );
  }
}
