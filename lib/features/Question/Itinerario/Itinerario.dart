import 'package:cloud_firestore/cloud_firestore.dart';

class Itinerario {
  final String id;
  final String name;
  final List<String> places;
  final String hour;

  Itinerario({
    required this.id,
    required this.name,
    required this.places,
    required this.hour,
  });

  factory Itinerario.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Itinerario(
        id: snapshot.id,
      name: data['name'] ?? '',
      places: List<String>.from(data['places'] ?? []),
      hour:  data['hour'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'places': places,
      'hour': hour
    };
  }

  static Itinerario empty() => Itinerario(id: '', name: '', places: [], hour: '');

}