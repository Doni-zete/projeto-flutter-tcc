import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'de4cd560-617e-4737-8a3a-487d0a668c3d';
const String requestBaseUrl =
    "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest";

Future<Map<String, dynamic>?> getData(String coinId) async {
  String request =
      "$requestBaseUrl?symbol=$coinId&convert=USD&CMC_PRO_API_KEY=$apiKey";

  http.Response response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    // Decodificar o JSON da resposta
    Map<String, dynamic> data = json.decode(response.body);

    // Verificar se a resposta contém os dados esperados
    if (data.containsKey('data') &&
        data['data'] is Map<String, dynamic> &&
        data['data'].containsKey(coinId) &&
        data['data'][coinId] is Map<String, dynamic> &&
        data['data'][coinId].containsKey('quote') &&
        data['data'][coinId]['quote'] is Map<String, dynamic> &&
        data['data'][coinId]['quote']['USD'] is Map<String, dynamic> &&
        data['data'][coinId]['quote']['USD'].containsKey('price')) {
      return data;
    }
  }

  return null;
}

Future<String?> getCoinImage(String coinId) async {
  String imageRequest =
      "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=$coinId&CMC_PRO_API_KEY=$apiKey";

  http.Response imageResponse = await http.get(Uri.parse(imageRequest));

  if (imageResponse.statusCode == 200) {
    Map<String, dynamic> imageData = json.decode(imageResponse.body);

    if (imageData.containsKey('data') &&
        imageData['data'] is Map<String, dynamic> &&
        imageData['data'].containsKey(coinId) &&
        imageData['data'][coinId] is Map<String, dynamic> &&
        imageData['data'][coinId].containsKey('logo') &&
        imageData['data'][coinId]['logo'] is String) {
      return imageData['data'][coinId]['logo'];
    }
  }

  return null;
}
