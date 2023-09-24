import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Moeda {
  Moeda({
    required this.id, // Adicionar o campo 'id'
    required this.title,
    required this.valor,
    required this.dateTime,
  });

  Moeda.fromJson(Map<String, dynamic> json)
      : id = json['id'], 
        title = json['title'],
        valor = json['valor'] != null ? json['valor'].toDouble() : 0.0,
        dateTime = DateTime.parse(json['datetime']);

  String id; 
  String title;
  double valor;
  DateTime dateTime;

  Map<String, dynamic> moedaJson() {
    return {
      'id': id, 
      'title': title,
      'valor': valor,
      'datetime': dateTime.toIso8601String()
    };
  }
}
