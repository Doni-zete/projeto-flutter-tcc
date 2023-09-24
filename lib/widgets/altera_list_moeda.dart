import 'package:cripto_github/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AlteraListMoeda extends StatelessWidget {
  const AlteraListMoeda({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onEditi,
  }) : super(key: key);

  final Moeda todo;
  final Function(Moeda) onDelete;
  final Function(Moeda, String, double) onEditi;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: todo.title);
    TextEditingController valueController =
        TextEditingController(text: todo.valor.toString());

    return Slidable(
      actionExtentRatio: 0.20,
      actionPane: const SlidableStrechActionPane(),
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          caption: 'Deletar',
          onTap: () {
            onDelete(todo);
          },
        ),
        IconSlideAction(
          color: Color.fromARGB(255, 54, 177, 244),
          icon: Icons.edit,
          caption: 'Editar',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Editar moeda'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Novo título',
                        ),
                      ),
                      TextField(
                        controller: valueController,
                        decoration: InputDecoration(
                          labelText: 'Novo valor',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      String newName = nameController.text;
                      double newValue =
                          double.tryParse(valueController.text) ?? todo.valor;
                      onEditi(todo, newName, newValue);
                      Navigator.of(context).pop();
                    },
                    child: Text('Salvar'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.orange[200],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Alinha os elementos lado a lado
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    todo.title.toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                ' R\$ ${todo.valor.toString()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Adicionando a cor branca ao texto
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
