import 'package:flutter/material.dart';
import 'package:cripto_github/models/moeda.dart';
import 'package:cripto_github/widgets/altera_list_moeda.dart';
import '../repositories/moeda_repositoriy.dart';

class ListaMoedaPage extends StatefulWidget {
  const ListaMoedaPage({Key? key}) : super(key: key);

  @override
  State<ListaMoedaPage> createState() => _ListaMoedaPageState();
}

class _ListaMoedaPageState extends State<ListaMoedaPage> {
  final TextEditingController moedaController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final MoedaRepository moedaRepository = MoedaRepository();

  List<Moeda> listaMoeda = [];
  Moeda? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    moedaRepository.getMoedaList().then((value) {
      setState(() {
        listaMoeda = value;
      });
    });
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
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: valorController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor da Criptomoeda',
                        hintText: 'Ex: 1000.00',
                        errorText: errorText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Flexible(
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
                  Text('Você possui ${listaMoeda.length} moedas'),
                ],
              ),
              SizedBox(height: 10), // Espaço entre a frase e os botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: showDeleteTudo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 240, 7, 26),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          title: text,
                          valor: double.parse(valor),
                          dateTime: DateTime.now(),
                        );
                        listaMoeda.add(newMoeda);
                        errorText = null;
                      });
                      moedaController.clear();
                      valorController.clear();
                      moedaRepository.saveMoedaList(listaMoeda);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffF79413),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('Adicionar'),
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
    });
    moedaRepository.saveMoedaList(listaMoeda);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa ${todo.title} foi removido com sucesso'),
        action: SnackBarAction(
            label: 'Desfazer',
            textColor: const Color(0xff00d7f3),
            onPressed: () {
              setState(() {
                listaMoeda.insert(deletedTodoPos!, deletedTodo!);
              });
              moedaRepository.saveMoedaList(listaMoeda);
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
    });
    moedaRepository.saveMoedaList(listaMoeda);
  }

  void onEditi(Moeda todo, String newTitle) {
    setState(() {
      // Encontrar o índice do Todo na lista
      int index = listaMoeda.indexOf(todo);

      // Verificar se o índice é válido antes de prosseguir
      if (index != -1) {
        // Criar um novo objeto Moeda com o novo título
        Moeda editedMoeda = Moeda(
          title: newTitle,
          valor: todo.valor, // Manter o mesmo valor
          dateTime: DateTime.now(),
        );

        // Substituir a Moeda antiga pela nova Moeda na lista
        listaMoeda[index] = editedMoeda;
      }
    });
    moedaRepository.saveMoedaList(listaMoeda);
  }
}
