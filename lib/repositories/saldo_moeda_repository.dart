import 'package:cripto_github/models/moeda.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaldoRepository extends ChangeNotifier {
  double _saldo = 0.0;

  SaldoRepository() {
    _calculateSaldoFromFirestore();
  }

  double get saldo => _saldo;

  void atualizarSaldo(double novoSaldo) {
    _saldo = novoSaldo;
    notifyListeners();
  }

  // Método para calcular o saldo total a partir do Firestore
  Future<void> _calculateSaldoFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('moedas')
          .where('userId', isEqualTo: userId)
          .get();

      double saldoTotal = 0.0;
      for (final doc in querySnapshot.docs) {
        final moeda = Moeda.fromJson(doc.data() as Map<String, dynamic>);
        saldoTotal += moeda.valor;
      }

      _saldo = saldoTotal;
      notifyListeners();
    }
  }
}
