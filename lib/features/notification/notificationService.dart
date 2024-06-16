import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../weather/controller/WeatherController.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final WeatherController weatherController = Get.put(WeatherController());

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher', // Asegúrate de tener un ícono válido aquí
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleDailyWeatherNotifications() async {
    await weatherController.loadWeatherData(); // Asegúrate de que los datos del clima estén cargados
    if (weatherController.weatherData2.isNotEmpty) {
      final currentWeather = weatherController.weatherData2[0];
      final weatherDescription = currentWeather['weather'][0]['description'];
      print(weatherDescription);
      final temperature = currentWeather['main']['temp'];
      print(temperature);

      final DateTime now = DateTime.now();
      final DateTime tenAM = DateTime(now.year, now.month, now.day, 10, 0);
      final DateTime ninePMTomorrow = DateTime(now.year, now.month, now.day + 1, 21, 0);

      if (tenAM.isAfter(now)) {
        await showNotification(
          0,
          'Clima - TripTweaks',
          'El clima es $weatherDescription con una temperatura de $temperature°C',
          tenAM,
        );
      }

      await showNotification(
        1,
        'Clima - TripTweaks',
        'El clima es $weatherDescription con una temperatura de $temperature°C',
        ninePMTomorrow,
      );
    }
  }
}