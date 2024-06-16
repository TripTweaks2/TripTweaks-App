import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceItinerary {
  final String id; // Agregar el campo id
  final String name;
  final double rating;
  final double latitude;
  final double longitude;
  final List<String> types;
  final String photo_reference;
  final String time;
  final int day;

  PlaceItinerary({
    required this.name,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.types,
    required this.photo_reference,
    required this.time,
    required this.id,
    required this.day
  });

  factory PlaceItinerary.fromJson(Map<String, dynamic> json) {
    return PlaceItinerary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: json['rating'] ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      types: List<String>.from(json['types'] ?? []),
      photo_reference:  json['photo_reference'] ?? '',
      time: json['time'] ?? '',
      day: json['day'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'types': types,
      'photo_reference': photo_reference,
      'time':time,
      'day': day,
    };
  }
}

class ItinerarioV2 {
  final String idUser;
  String name;
  final List<PlaceItinerary> places;
  final String hour;
  String idItinerario;

  ItinerarioV2({
    required this.idUser,
    this.idItinerario = '', // Ahora es opcional con un valor por defecto
    required this.name,
    required this.places,
    required this.hour,
  });

  factory ItinerarioV2.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if(snapshot.data() != null) {
      final data = snapshot.data()!;
      return ItinerarioV2(
        idUser: data['idUser'] ?? '',
        name: data['name'] ?? '',
        places: List<PlaceItinerary>.from(data['places'].map((place) => PlaceItinerary.fromJson(place)) ?? []),
        hour: data['hour'] ?? '',
        idItinerario: snapshot.id,
      );
    }
    else {
      throw Exception("Información de itinerario vacío");
    }

  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'places': places.map((place) => place.toJson()).toList(),
      'hour': hour,
      'idItinerario':idItinerario,
      'idUser':idUser
    };
  }

  static ItinerarioV2 empty() => ItinerarioV2(idUser: '', name: '', places: [], hour: '', idItinerario: '');
}