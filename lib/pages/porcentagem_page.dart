import 'package:flutter/material.dart';
import 'package:cripto_github/models/moeda.dart'; // Certifique-se de importar corretamente o modelo Moeda

class PorcentagemMoedasPage extends StatelessWidget {
  final List<Moeda> listaMoeda; // Recebe a lista de moedas como parâmetro

  PorcentagemMoedasPage({required this.listaMoeda});

  @override
  Widget build(BuildContext context) {
    double totalValor = listaMoeda.fold(0, (total, moeda) => total + moeda.valor);

    return Scaffold(
      appBar: AppBar(
        title: Text('Porcentagem das Moedas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (Moeda moeda in listaMoeda)
              PorcentagemMoedaItem(
                moeda: moeda,
                totalValor: totalValor,
              ),
          ],
        ),
      ),
    );
  }
}

class PorcentagemMoedaItem extends StatelessWidget {
  final Moeda moeda;
  final double totalValor;

  PorcentagemMoedaItem({required this.moeda, required this.totalValor});

  @override
  Widget build(BuildContext context) {
    double porcentagem = (moeda.valor / totalValor) * 100;
    String porcentagemFormatada = porcentagem.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${moeda.title}: $porcentagemFormatada%'),
    );
  }
}
