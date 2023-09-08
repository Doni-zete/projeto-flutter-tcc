import 'dart:convert';
import "package:cripto_github/models/moeda.dart";
import 'package:shared_preferences/shared_preferences.dart';

const moedaListKey = 'moeda_list';

class MoedaRepository {
  late SharedPreferences sharedPreferences;

// CARREGANDO A LISTA MOEDA
  Future<List<Moeda>> getMoedaList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(moedaListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Moeda.fromJson(e)).toList();
  }

// SALVANDO A MOEDA EM UMA LISTA;
  void saveMoedaList(List<Moeda> listaMoeda) {
    final List<Map<String, dynamic>> jsonList =
        listaMoeda.map((todo) => todo.moedaJson()).toList();
    final String jsonString = json.encode(jsonList);
    sharedPreferences.setString('moeda_list', jsonString);
    print(jsonString);
  }
}
