import 'package:cripto_github/api/coin_api.dart';
import 'package:flutter/material.dart';

class CotacaoPage extends StatefulWidget {
  @override
  State<CotacaoPage> createState() => _CotacaoPageState();
}

class _CotacaoPageState extends State<CotacaoPage> {
  final coinController = TextEditingController();
  final quantityController = TextEditingController();
  String coinId = '';
  double coinValueInUSD = 0;
  double quantity = 0;
  String? coinImageUrl;
  String errorMessage = '';

  void _getCoinValue() async {
    coinId = coinController.text.toUpperCase();
    Map<String, dynamic>? data = await getData(coinId);
    String? coinImage = await getCoinImage(coinId);

    if (data != null) {
      setState(() {
        coinValueInUSD = data['data'][coinId]['quote']['USD']['price'] ?? 0.0;
        quantity = double.parse(quantityController.text);
        coinImageUrl = coinImage;
        errorMessage = '';
      });
    } else {
      setState(() {
        coinValueInUSD = 0;
        quantity = 0;
        coinImageUrl = null;
        errorMessage = coinId.isNotEmpty
            ? 'Valor não encontrado ou inválido.'
            : ''; // Define a mensagem de erro apenas se o usuário digitou algo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        title: const Text('Cotação'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (coinImageUrl != null)
                Image.network(
                  coinImageUrl!,
                  width: 100,
                  height: 100,
                ),
              const SizedBox(height: 30),
              TextField(
                controller: coinController,
                decoration: const InputDecoration(
                  labelText: "Digite o símbolo da criptomoeda",
                  labelStyle: TextStyle(color: Colors.amber),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.amber, fontSize: 20.0),
                onChanged: (value) => coinId = value,
                onSubmitted: (value) => _getCoinValue(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: "Digite a quantidade de criptomoeda",
                  labelStyle: TextStyle(color: Colors.amber),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.amber, fontSize: 20),
                onChanged: (value) => quantity = double.tryParse(value) ?? 0,
                onSubmitted: (value) => _getCoinValue(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _getCoinValue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF79413),
                ),
                child: const Text(
                  'Buscar valor em USD',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                errorMessage.isNotEmpty
                    ? errorMessage
                    : coinValueInUSD > 0
                        ? 'Valor em USD: \$${(coinValueInUSD * quantity).toStringAsFixed(2)}'
                        : '',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
