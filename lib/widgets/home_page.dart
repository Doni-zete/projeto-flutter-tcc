import 'package:cripto_github/pages/configuracao_page.dart';
import 'package:cripto_github/pages/cotacao_page.dart';
import 'package:cripto_github/pages/lista_moedas_page.dart';
import 'package:cripto_github/repositories/saldo_moeda_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          CotacaoPage(),
          const ListaMoedaPage(),
          ConfiguracaoPage(nomes: const [], porcentagens: const []),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        selectedLabelStyle: const TextStyle(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.currency_exchange_sharp,
            ),
            label: 'Cotação',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'Lista de Moedas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.savings_sharp,
            ),
            label: 'Saldo',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
