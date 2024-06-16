import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class QuestionV2Controller extends GetxController {
  final searchPlaceController = TextEditingController();
  GlobalKey<FormState> questionV2FormKey = GlobalKey<FormState>();
  var suggestions = <String>[].obs;
  var selectedLocation = Rx<Location?>(null);

  Future<void> getSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&region=pe&key=AIzaSyBBKmww5PM0o7wdf48ibmyI4Ogpkxcol3g'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['predictions'] != null) {
          suggestions.value = (data['predictions'] as List)
              .map((result) => result['description'] as String)
              .toList();
          print(suggestions);
        } else {
          suggestions.clear();
          print('No results found in the response');
        }
      } else {
        print('Failed to load suggestions: ${response.statusCode}');
        suggestions.clear();
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      suggestions.clear();
    }
  }

  // Define un método para mostrar la alerta
  void showLocationAlert() {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text('No se pudieron obtener las coordenadas. Por favor, sé más específico con la ubicación.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Cierra el diálogo
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  // Tu método para obtener las coordenadas
  Future<void> getCoordinates(String address) async {
    try {
      print(address);
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        selectedLocation.value = locations.first;
        print('Coordinates: ${selectedLocation.value}');
      } else {
        showLocationAlert(); // Muestra la alerta si no se encuentran coordenadas
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
      showLocationAlert(); // Muestra la alerta si hay un error
    }
  }
}