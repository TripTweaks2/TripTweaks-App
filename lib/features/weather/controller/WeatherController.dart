import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController {
  var weatherData2 = <Map<String, dynamic>>[].obs;
  var isLoadingWeather = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadWeather();
  }

  Future<void> loadWeatherData() async {
    await _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final position = await _determinePosition();
      if (position != null) {
        final data = await _fetchWeather(position.latitude, position.longitude);
        weatherData2.value = data;
      }
    } catch (e) {
      print('Error al obtener el clima: $e');
    } finally {
      isLoadingWeather.value = false;
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están permanentemente denegados.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Map<String, dynamic>>> _fetchWeather(double lat, double lon) async {
    final apiKey = '54a3ee3542b8302c4b3a7d926083b928';
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=es';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['list']);
    } else {
      throw Exception('Error al obtener los datos del clima');
    }
  }
}