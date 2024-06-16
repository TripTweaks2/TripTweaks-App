import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'App.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/notification/notificationService.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'localization/GeolocationController.dart'; // Importación de timezone


Future <void> main() async {
  //Widgets Binding
  final WidgetsBinding widgetsBinding=WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  //Local Storage
  await GetStorage.init();


  // Inicialización de SharedPreferences
  await SharedPreferences.getInstance();

  //Splash until other items
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  // Inicialización del controlador de notificaciones
  final NotificationController notificationController = Get.put(NotificationController());
  await notificationController.loadNotificationState(); // Cargar el estado de las notificaciones

  final GeolocationController geolocationController =Get.put(GeolocationController());
  await geolocationController.loadGeolocationState();


  //Inicialización Firebase
  //Inicialización Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) async {
    Get.put(AuthenticationRepository());

    // Inicializar Firebase App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  });


  runApp(const MyApp());

  // Mostrar la notificación de bienvenida
  if (notificationController.areNotificationsEnabled.value) {
    final DateTime now = DateTime.now();
    await notificationService.showNotification(
      2,
      'Bienvenido',
      '¿A dónde viajas hoy? Agreguemos nuevo itinerario?',
      now.add(const Duration(seconds: 1)), // Muestra la notificación inmediatamente
    );

    await notificationService.scheduleDailyWeatherNotifications();
  }
}

