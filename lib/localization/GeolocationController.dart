import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeolocationController extends GetxController {
  var isGeolocationEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGeolocationState();
  }

  Future<void> loadGeolocationState() async {
    final prefs = await SharedPreferences.getInstance();
    isGeolocationEnabled.value = prefs.getBool('isGeolocationEnabled') ?? false;
  }

  Future<void> saveGeolocationState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGeolocationEnabled', value);
    isGeolocationEnabled.value = value;
  }
}

class NotificationController extends GetxController {
  var areNotificationsEnabled = false.obs;

  // Método para guardar el estado de las notificaciones en SharedPreferences
  Future<void> saveNotificationState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('areNotificationsEnabled', value);
  }

  // Método para cargar el estado de las notificaciones desde SharedPreferences
  Future<void> loadNotificationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isEnabled = prefs.getBool('areNotificationsEnabled');
    if (isEnabled != null) {
      areNotificationsEnabled.value = isEnabled;
    }
  }
}