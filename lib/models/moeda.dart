import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Moeda {
  Moeda({
    required this.title,
    required this.valor, // Adicionar o campo 'valor'
    required this.dateTime,
  });

  Moeda.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        valor = json['valor'] != null ? json['valor'].toDouble() : 0.0,
        dateTime = DateTime.parse(json['datetime']);

  String title;
  double valor; // Adicionar o campo 'valor'
  DateTime dateTime;

  Map<String, dynamic> moedaJson() {
    return {'title': title, 'valor': valor, 'datetime': dateTime.toIso8601String()};
  }
}
