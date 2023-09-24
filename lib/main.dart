import 'package:cripto_github/repositories/porcentagem_repositoriy.dart';
import 'package:cripto_github/repositories/saldo_moeda_repository.dart';
import 'package:cripto_github/pages/cotacao_page.dart';
import 'package:cripto_github/pages/login_page.dart';
import 'package:cripto_github/pages/porcentagem_page.dart';
import 'package:cripto_github/pages/registrar_page.dart';
import 'package:cripto_github/widgets/home_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SaldoRepository>(
          create: (context) => SaldoRepository(),
        ),
        ChangeNotifierProvider(create: (_) => PorcentagemRepository()),
      ],
      child: GerenciadorCripto(),
    ),
  );
}

class GerenciadorCripto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/registrar': (context) => RegistroPage(),
       
      },
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    );
  }
}
