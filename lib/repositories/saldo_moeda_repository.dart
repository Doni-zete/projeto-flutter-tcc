import 'package:cripto_github/models/moeda.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaldoRepository extends ChangeNotifier {
  double _saldo = 0.0;
  static const _saldoKey = 'saldo_key'; // Chave para armazenar o saldo

  SaldoRepository() {
    _loadSaldo(); // Carregar o saldo salvo anteriormente ao criar o modelo
  }

  double get saldo => _saldo;

  void atualizarSaldo(double novoSaldo) {
    _saldo = novoSaldo;
    _saveSaldo(); // Salvar o novo saldo no SharedPreferences
    notifyListeners();
  }

  // Carregar o saldo salvo anteriormente
  Future<void> _loadSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    final saldo = prefs.getDouble(_saldoKey);
    if (saldo != null) {
      _saldo = saldo;
      notifyListeners();
    }
  }

  // Salvar o saldo no SharedPreferences
  Future<void> _saveSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_saldoKey, _saldo);
  }

  // Adicionar um método para calcular o saldo total a partir de uma lista de moedas
  double calcularSaldoTotal(List<Moeda> moedas) {
    double saldoTotal = 0.0;
    for (Moeda moeda in moedas) {
      saldoTotal += moeda.valor;
    }
    return saldoTotal;
  }
}
