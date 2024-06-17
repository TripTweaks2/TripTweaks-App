import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tesis3/features/Questionv2/ItinerarioPlaceV2Model.dart';

import '../../Question/Itinerario/Itinerario.dart';
import '../../personalization/controllers/user_controller.dart';
import '../../travel/controllers/category_controller.dart';
import '../ItineraryRepository/ItineraryRepository.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';


class ItinerarioController extends GetxController{
  var itinerarios = <Itinerario>[].obs;
  RxList<ItinerarioV2> itinerariosV2 = <ItinerarioV2>[].obs;
  final itinerarioRepository = ItinerarioRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  @override
  void onInit() {
    super.onInit();
    Get.put(UserController());
    Get.put(CategoryController());
    fetchItinerariosV2();
  }

  // Método para notificar la actualización de la lista de itinerarios
  void notifyItinerariosUpdated() {
    update(); // Notificar a los widgets que dependen de este controlador que necesitan actualizarse
  }

  Future<List<Itinerario>>? fetchItinerarios() async {
    final controller = UserController.instance;
    final userId = controller.user.value.id;
    print("userId" + userId);
    final fetchedItinerarios = await itinerarioRepository.fetchItinerariosByUserId(userId) ?? [];
    if (fetchedItinerarios.isNotEmpty) {
      itinerarios.value = fetchedItinerarios;
    } else {
      print('No se encontraron itinerarios para el usuario.');
    }
    return fetchedItinerarios;
  }

  void addItinerario(Itinerario itinerario) {
    itinerarios.add(itinerario);
  }

  void addItinerarioV2(ItinerarioV2 itinerarioV2){
    itinerariosV2.add(itinerarioV2);
  }

  Future<void> generarItinerarios(List<String> selectedOptions) async {
    print(selectedOptions.first);
    final controller = UserController.instance;
    final controller1 = CategoryController.instance;
    final tours = await controller1.getCategoryTour(categoryId: selectedOptions.first);

    if (tours.isNotEmpty) {
     print("aca");
     final random = Random();
     final horaActual = DateTime.now();
     final itinerario = Itinerario(
       id: controller.user.value.id,
       name: 'Itinerario ${random.nextInt(1000)}',
       places: tours.map((tour) => tour.title).toList(),
       hour: '${horaActual.hour}:${horaActual.minute}',
     );

     addItinerario(itinerario);
     await itinerarioRepository.saveItinerario(itinerario);
    } else {
      print('No se encontraron tours para la categoría seleccionada.');
    }
  }

  String generateTime(int index) {
    // Define el intervalo de tiempo entre cada lugar en minutos
    const int intervaloMinutos = 60;

    // Define la hora de inicio en minutos desde la medianoche
    const int horaInicioMinutos = 9 * 60;  // 9:00 AM

    // Calcula la hora para el lugar actual sumando el índice multiplicado por el intervalo
    final int minutosDesdeInicio = horaInicioMinutos + (index * intervaloMinutos);

    // Convertir los minutos a horas y minutos
    final int hora = minutosDesdeInicio ~/ 60;
    final int minuto = minutosDesdeInicio % 60;

    // Formatea la hora y el minuto en formato de hora HH:MM
    return '$hora:${minuto.toString().padLeft(2, '0')}';
  }


  Future<void> generarItinerariosV2(Location? selectedLocation, List<String> selectedTypes) async {
    if (selectedLocation == null || selectedTypes.isEmpty) {
      print('Error: Falta información para generar itinerarios');
      return;
    }

    final controller = UserController.instance;

    final apiKey = 'AIzaSyBBKmww5PM0o7wdf48ibmyI4Ogpkxcol3g';
    final radius = 7000;

    final url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${selectedLocation.latitude},${selectedLocation.longitude}'
        '&radius=$radius'
        '&types=${selectedTypes.join('|')}'
        '&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];

      if (results.isEmpty) {
        // Si no hay resultados, volvemos a llamar a la función con los parámetros modificados
        return await generarItinerariosV2(selectedLocation, ['tourist_attraction']);
      }


      final List<PlaceItinerary> places = [];
      for (var i = 0; i < results.length; i++) {
        final result = results[i];
        final geometry = result['geometry'];
        final location = geometry['location'];
        final name = result['name'];
        final dynamic latValue = location['lat'];
        final double lat = latValue != null ? (latValue is int ? latValue.toDouble() : (latValue as double)) : 0.0;

        final dynamic lngValue = location['lng'];
        final double lng = lngValue != null ? (lngValue is int ? lngValue.toDouble() : (lngValue as double)) : 0.0;

        final dynamic ratingValue = result['rating'];
        final double rating = ratingValue != null ? (ratingValue is int ? ratingValue.toDouble() : (ratingValue as double)) : 0.0;

        final types = result['types'];

        final photos = result['photos'] != null && result['photos'].isNotEmpty
            ? result['photos'][0]
            : null;

        final photoReference = photos != null ? photos['photo_reference'] ?? '' : '';
        final uuid = Uuid();
        final id = uuid.v4();

        final day = (i ~/ 6) + 1; // Calcula el día, asumiendo 6 lugares por día
        final time = generateTime(i % 6); // Genera la hora dentro del rango del día


        final placeItinerary = PlaceItinerary(
          name: name,
          rating: rating,
          latitude: lat,
          longitude: lng,
          types: List<String>.from(types ?? []),
          photo_reference: photoReference,
          time: time,
          id: id,
          day: day,
        );

        places.add(placeItinerary);
      }

      final random = Random();
      final DateTime horaActual = DateTime.now();
      final String fechaConHora = DateFormat('dd/MM/yyyy - HH:mm').format(horaActual);


      final itinerario = ItinerarioV2(
        idUser: controller.user.value.id,
        name: 'Itinerario ${random.nextInt(1000)}',
        places: places,
        hour: fechaConHora,
        idItinerario: '', // Vacío por ahora, se asignará después de guardarlo en Firestore
      );

      // Ahora puedes usar el itinerario como desees
      print('Itinerario generado:');
      print(itinerario.toJson());


      // Añadimos el itinerario a la lista de itinerarios locales
      addItinerarioV2(itinerario);
      await itinerarioRepository.saveItinerarioV2(itinerario);
    } else {
      print('Error al realizar la solicitud: ${response.statusCode}');
    }
  }

  Future<List<ItinerarioV2>>? fetchItinerariosV2() async {
    final controller = UserController.instance;
    final userId = controller.user.value.id;
    final fetchedItinerarios = await itinerarioRepository.fetchItinerariosV2ByUserId(userId) ?? [];
    if (fetchedItinerarios.isNotEmpty) {
      itinerariosV2.value = fetchedItinerarios;
    } else {
      print('No se encontraron itinerarios para el usuario.');
    }
    return fetchedItinerarios;
  }

  Future<void> eliminarLugarDeItinerarioV2(String lugarId) async {
    try {
      // Filtrar los lugares del itinerario para eliminar el lugar específico
      final nuevosItinerarios = <ItinerarioV2>[];
      for (var itinerario in itinerariosV2) {
        final nuevosLugares = itinerario.places.where((place) => place.id != lugarId).toList();
        final nuevoItinerario = ItinerarioV2(
          idUser: itinerario.idUser,
          name: itinerario.name,
          places: nuevosLugares,
          hour: itinerario.hour,
          idItinerario: itinerario.idItinerario,
        );
        nuevosItinerarios.add(nuevoItinerario);
      }

      // Actualizar la lista de itinerarios en el estado del controlador
      itinerariosV2.value = nuevosItinerarios;

      // Actualizar los itinerarios en Firestore (si es necesario)
      // Aquí deberías actualizar tus datos en Firestore según sea necesario

      print('Lugar eliminado del itinerario correctamente');
    } catch (e) {
      print('Error al eliminar el lugar del itinerario: $e');
    }
  }

  Future<void> fetchRecommendedItinerarios({
    required double latitud,
    required double longitud,
    required String categoria,
  }) async {
    final url = Uri.parse(
      'https://triptweaks-backend.onrender.com/recommend?LATITUD=$latitud&LONGITUD=$longitud&CATEGORIA=$categoria',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final controller = UserController.instance;
      final List<PlaceItinerary> places = [];

      for (var i = 0; i < data.length; i++) {
        final place = data[i];
        final uuid = Uuid();
        final id = uuid.v4();
        final day = (i ~/ 6) + 1; // Calcula el día, asumiendo 6 lugares por día
        final time = generateTime(i % 6); // Genera la hora dentro del rango del día

        final placeItinerary = PlaceItinerary(
          name: place['NOMBRE'],
          rating: 0.0, // No hay rating en la respuesta, así que se pone 0.0
          latitude: place['LATITUD'],
          longitude: place['LONGITUD'],
          types: [place['CATEGORIA']],
          photo_reference: '', // No hay foto en la respuesta, así que se deja vacío
          time: time,
          id: id,
          day: day,
        );

        places.add(placeItinerary);
      }

      final random = Random();
      final DateTime horaActual = DateTime.now();
      final String fechaConHora = DateFormat('dd/MM/yyyy - HH:mm').format(horaActual);

      final itinerario = ItinerarioV2(
        idUser: controller.user.value.id,
        name: 'Itinerario ${random.nextInt(1000)}',
        places: places,
        hour: fechaConHora,
        idItinerario: '', // Vacío por ahora, se asignará después de guardarlo en Firestore
      );

      // Añadimos el itinerario a la lista de itinerarios locales
      addItinerarioV2(itinerario);
      await itinerarioRepository.saveItinerarioV2(itinerario);
    } else {
      print('Error al obtener recomendaciones: ${response.statusCode}');
    }
  }
}