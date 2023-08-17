import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'de4cd560-617e-4737-8a3a-487d0a668c3d';
const String requestBaseUrl =
    "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest";

Future<Map<dynamic, dynamic>?> getData(String coinId) async {
  String request =
      "$requestBaseUrl?symbol=$coinId&convert=USD&CMC_PRO_API_KEY=$apiKey";

  http.Response response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    // Decodificar o JSON da resposta
    Map<dynamic, dynamic> data = json.decode(response.body);

    // Verificar se a resposta contém os dados esperados
    if (data.containsKey('data') &&
        data['data'] is Map<String, dynamic> &&
        data['data'].containsKey(coinId) &&
        data['data'][coinId] is Map<String, dynamic> &&
        data['data'][coinId].containsKey('quote') &&
        data['data'][coinId]['quote'] is Map<String, dynamic> &&
        data['data'][coinId]['quote']['USD'] is Map<String, dynamic> &&
        data['data'][coinId]['quote']['USD'].containsKey('price')) {
      // Retorna os dados obtidos
      return data;
    } else {
      print('Dados ausentes ou em formato inválido na resposta da API.');
      return null;
    }
  } else {
    print('Falha ao carregar os dados: ${response.statusCode}');
    return null;
  }
}