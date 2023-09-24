import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cripto_github/models/moeda.dart';
import 'package:cripto_github/widgets/altera_list_moeda.dart';
import 'package:cripto_github/repositories/moeda_repositoriy.dart';
import 'package:cripto_github/repositories/saldo_moeda_repository.dart';
import 'package:cripto_github/repositories/porcentagem_repositoriy.dart';
import 'package:cripto_github/pages/porcentagem_page.dart';
import 'package:uuid/uuid.dart';

class ListaMoedaPage extends StatefulWidget {
  const ListaMoedaPage({Key? key}) : super(key: key);

  @override
  State<ListaMoedaPage> createState() => _ListaMoedaPageState();
}

class _ListaMoedaPageState extends State<ListaMoedaPage> {
  String? userId;
  FirebaseAuth? auth;
  User? user;

  final TextEditingController moedaController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final MoedaRepository moedaRepository = MoedaRepository();
  final SaldoRepository saldoModel = SaldoRepository();
  double saldo = 0.0;
  double novoSaldo = 0.0;
  List<Moeda> listaMoeda = [];
  Moeda? deletedTodo;
  int? deletedTodoPos;

  String? errorText;
  final _uuid = Uuid();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    auth = FirebaseAuth.instance;
    user = auth?.currentUser;

    if (user != null) {
      userId = user?.uid;
      Future.delayed(Duration(seconds: 1), () {
        moedaRepository.getMoedaList(userId!).then((value) {
          setState(() {
            listaMoeda = value;
            isLoading = false;
          });
          calcularPorcentagens();
          novoSaldo = calcularSaldo();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7A00),
        title: const Text('Lista de moedas'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: moedaController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicionar Criptomoeda',
                          hintText: 'Ex: btc',
                          errorText: errorText,
                        ),
                        style:
                            const TextStyle(color: Colors.amber, fontSize: 13),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: valorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor R\$ Criptomoeda',
                        hintText: 'Ex: 1000.00',
                        errorText: errorText,
                      ),
                      style: const TextStyle(color: Colors.amber, fontSize: 13),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              isLoading
                  ? CircularProgressIndicator()
                  : Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (Moeda todo in listaMoeda)
                            AlteraListMoeda(
                              todo: todo,
                              onDelete: onDelete,
                              onEditi: onEditi,
                            ),
                        ],
                      ),
                    ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Você possui ${listaMoeda.length} moeda'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: showDeleteTudo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 240, 7, 26),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    ),
                    child: Text('Remover tudo'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String text = moedaController.text;
                      String valor = valorController.text;

                      if (text.isEmpty || valor.isEmpty) {
                        setState(() {
                          errorText = 'Preencha ambos os campos';
                        });
                        return;
                      }

                      setState(() {
                        Moeda newMoeda = Moeda(
                          id: _uuid.v4(),
                          title: text,
                          valor: double.parse(valor),
                          dateTime: DateTime.now(),
                        );
                        listaMoeda.add(newMoeda);
                        errorText = null;
                        double novoSaldo = calcularSaldo();
                        errorText = null;
                      });
                      moedaController.clear();
                      valorController.clear();
                      moedaRepository.saveMoedaList(userId!, listaMoeda);
                      calcularPorcentagens();
                      saldoModel.atualizarSaldo(novoSaldo);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffF79413),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    ),
                    child: Text('Adicionar'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      List<double> valores =
                          listaMoeda.map((moeda) => moeda.valor).toList();
                      List<String> nomes =
                          listaMoeda.map((moeda) => moeda.title).toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PorcentagemPage(
                            valores: valores,
                            nomes: nomes,
                          ),
                        ),
                      );
                    },
                    child: Text('Porcentagem'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Moeda todo) {
    deletedTodo = todo;
    deletedTodoPos = listaMoeda.indexOf(todo);
    setState(() {
      listaMoeda.remove(todo);
      //double novoSaldo = calcularSaldo();
      calcularPorcentagens();
    });
    moedaRepository.saveMoedaList(userId!, listaMoeda);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moeda ${todo.title} foi removido com sucesso'),
        action: SnackBarAction(
            label: 'Desfazer',
            textColor: const Color(0xff00d7f3),
            onPressed: () {
              setState(() {
                listaMoeda.insert(deletedTodoPos!, deletedTodo!);
              });
              moedaRepository.saveMoedaList(userId!, listaMoeda);
            }),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showDeleteTudo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover tudo'),
        content: Text('Você tem certeza que deseja remover tudo?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 18, 221, 109)),
              child: Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deletandoAllMoedas();
              },
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 235, 61, 4)),
              child: Text('Remover tudo'))
        ],
      ),
    );
  }

  void deletandoAllMoedas() {
    setState(() {
      listaMoeda.clear();
      //double novoSaldo = calcularSaldo();
      calcularPorcentagens();
    });
    moedaRepository.saveMoedaList(userId!, listaMoeda);
    saldoModel.atualizarSaldo(0.0);
  }

  void onEditi(Moeda todo, String newTitle, double newValue) {
    setState(() {
      int index = listaMoeda.indexOf(todo);

      if (index != -1) {
        Moeda editedMoeda = Moeda(
          id: todo.id,
          title: newTitle,
          valor: newValue,
          dateTime: DateTime.now(),
        );

        listaMoeda[index] = editedMoeda;
        saldoModel.atualizarSaldo(novoSaldo);
        calcularPorcentagens();
      }
    });
    moedaRepository.saveMoedaList(userId!, listaMoeda);
  }

  double calcularSaldo() {
    double saldoTotal = 0.0;
    for (Moeda moeda in listaMoeda) {
      saldoTotal += moeda.valor;
    }
    saldo = saldoTotal;
    return saldoTotal;
  }

  void calcularPorcentagens() {
    double saldoTotal = calcularSaldo();
    List<double> novasPorcentagens = [];

    for (Moeda moeda in listaMoeda) {
      double porcentagem = (moeda.valor / saldoTotal) * 100.0;
      novasPorcentagens.add(porcentagem);
    }

    Provider.of<PorcentagemRepository>(context, listen: false)
        .atualizarPorcentagens(novasPorcentagens.cast<double>());
  }
}
