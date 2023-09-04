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

  void _getCoinValue() async {
    coinId = coinController.text.toUpperCase();
    Map<dynamic, dynamic>? data = await getData(coinId);

    if (data != null) {
      setState(() {
        coinValueInUSD = data['data'][coinId]['quote']['USD']['price'] ?? 0.0;
        quantity = double.parse(quantityController.text);
      });
    } else {
      setState(() {
        coinValueInUSD = 0;
        quantity = 0;
      });
      print('Falha ao obter os dados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7A00),
        title: const Text('CoinMarketCap API'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.monetization_on_outlined,
                  size: 120, color: Colors.orange),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getCoinValue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF79413),
                ),
                child: const Text('Buscar valor em USD'),
              ),
              const SizedBox(height: 24),
              Text(
                coinValueInUSD > 0
                    ? 'Valor em USD: \$${(coinValueInUSD * quantity).toStringAsFixed(2)}'
                    : 'Valor não encontrado ou inválido.',
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
