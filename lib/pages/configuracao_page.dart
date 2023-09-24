import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cripto_github/repositories/saldo_moeda_repository.dart';

class ConfiguracaoPage extends StatelessWidget {
  final List<String> nomes;
  final List<double> porcentagens;
  ConfiguracaoPage({required this.nomes, required this.porcentagens});

  @override
  Widget build(BuildContext context) {
    // Acesse o usuário atualmente autenticado
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        title: const Text('Saldo'),
        centerTitle: true,
      ),
      body: FutureBuilder<double>(
        // Substitua esta função pelo método que recupera o saldo do Firestore
        future: _getSaldoFromFirestore(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se os dados ainda estão sendo carregados, exiba um indicador de carregamento
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Se ocorreu um erro ao carregar os dados, exiba uma mensagem de erro
            return const Center(child: Text('Erro ao carregar o saldo'));
          } else {
            // Se os dados foram carregados com sucesso, exiba o saldo
            final double saldo = snapshot.data ?? 0.0;
            return _buildSaldoWidget(saldo);
          }
        },
      ),
    );
  }

  Widget _buildSaldoWidget(double saldo) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Saldo Total:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'R\$ ${saldo.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 320.0,
            child: ElevatedButton(
              onPressed: () {
                // Lógica para sair do aplicativo
                // Use SystemNavigator.pop() para encerrar o aplicativo
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF79413),
              ),
              child: const Text(
                'Sair do Aplicativo',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<double> _getSaldoFromFirestore(User? user) async {
    if (user == null) {
      return 0.0;
    }

    try {
      final userId = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('moedas')
          .get();

      double saldoTotal = 0.0;
      for (final doc in querySnapshot.docs) {
        final moedaData = doc.data() as Map<String, dynamic>;
        final valor = moedaData['valor'] as double;
        saldoTotal += valor;
      }

      return saldoTotal;
    } catch (e) {
      print('Erro ao buscar dados do Firestore: $e');
      return 0.0;
    }
  }
}
