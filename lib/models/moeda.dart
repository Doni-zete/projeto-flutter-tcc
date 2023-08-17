import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Moeda {
  Moeda({required this.title, required this.dateTime});

  Moeda.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);

  String title;
  DateTime dateTime;

  Map<String, dynamic> moedaJson() {
    return {'title': title, 'datetime': dateTime.toIso8601String()};
  }
}
