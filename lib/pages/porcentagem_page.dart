import 'package:flutter/material.dart';

class PorcentagemPage extends StatelessWidget {
  final List<double> valores;
  final List<String> nomes;

  PorcentagemPage({required this.valores, required this.nomes});

  @override
  Widget build(BuildContext context) {
    if (valores.isEmpty) {
      // Lida com o caso em que a lista de valores está vazia
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF7A00),
          title: const Text('Porcentagem'),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Nenhum valor disponível para calcular porcentagem.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    double total = valores.reduce((value, element) => value + element);
    List<double> porcentagens =
        valores.map((valor) => (valor / total) * 100).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7A00),
        title: const Text('Porcentagem'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: false,
            expandedHeight: 100.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width *
                    0.5, // Defina a largura desejada aqui
                child: Text(
                  'Total: 100%',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30), // Ajuste aqui
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 2), // Espaçamento vertical
                        Text(
                          '${nomes[index].toUpperCase()}: ${porcentagens[index].toStringAsFixed(2)}%',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: valores.length,
            ),
          ),
        ],
      ),
    );
  }
}
