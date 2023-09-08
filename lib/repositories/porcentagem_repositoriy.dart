import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PorcentagemRepository extends ChangeNotifier {
  List<double> _porcentagens = [];
  static const _porcentagensKey =
      'porcentagens_key'; // Chave para armazenar as porcentagens

  PorcentagemRepository() {
    _loadPorcentagens(); // Carregar as porcentagens salvas anteriormente ao criar o modelo
  }

  List<double> get porcentagens => _porcentagens;

  void atualizarPorcentagens(List<double> novasPorcentagens) {
    _porcentagens = novasPorcentagens;
    _savePorcentagens(); // Salvar as novas porcentagens no SharedPreferences
    notifyListeners();
  }

  // Carregar as porcentagens salvas anteriormente
  Future<void> _loadPorcentagens() async {
    final prefs = await SharedPreferences.getInstance();
    final porcentagens =
        prefs.getStringList(_porcentagensKey)?.map((percentage) {
      return double.tryParse(percentage) ?? 0.0;
    }).toList();
    if (porcentagens != null) {
      _porcentagens = porcentagens;
      notifyListeners();
    }
  }

  // Salvar as porcentagens no SharedPreferences
  Future<void> _savePorcentagens() async {
    final prefs = await SharedPreferences.getInstance();
    final stringPorcentagens = _porcentagens.map((percentage) {
      return percentage.toString();
    }).toList();
    await prefs.setStringList(_porcentagensKey, stringPorcentagens);
  }
}
