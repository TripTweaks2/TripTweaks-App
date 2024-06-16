import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/custom_shapes/containers/PrimaryHeaderContainer.dart';
import 'package:tesis3/common/widgets/images/CircularImage.dart';
import 'package:tesis3/common/widgets/list_tiles/SettingsMenuTile.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';

import '../../../../common/widgets/list_tiles/UserProfileTile.dart';
import '../../../../localization/GeolocationController.dart';
import '../../../notification/notificationService.dart';
import '../Profile/ProfileScreen.dart';
import 'FAQ/PreguntaYRespuesta.dart';

class SettingClass extends StatelessWidget {
  SettingClass({super.key});

  final GeolocationController geolocationController = Get.put(GeolocationController());
  final notificationController = Get.put(NotificationController());


  @override
  Widget build(BuildContext context) {
    bool isGeolocationEnabled = true;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Header
            PrimaryHeaderContainer(
                child: Column(
                  children: [
                    TAppBar(title: Text('Cuenta',style: Theme.of(context).textTheme.headlineMedium!.apply(color: AppColors.white))),
                    UserProfileTile(onPressed: ()=>Get.to(()=>const ProfileScreen())),
                    const SizedBox(height: Sizes.spaceBtwSection),
                  ],
                )
            ),
            ///Body
            Padding(
                padding: EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    const SectionHeading(title: 'Configuración de la App',showActionButton: false),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    SettingMenuTile(icon: Iconsax.location, title: 'Geolocalización',
                        subtitle: 'Consigue una recomendación de acuerdo a tu ubicación',
                      trailing: Obx(() => Switch(
                        value: geolocationController.isGeolocationEnabled.value,
                        onChanged: (value) async {
                          await geolocationController.saveGeolocationState(value);
                          if (!value) {
                            // Si el usuario desactiva la geolocalización, mostrar el diálogo
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Geolocalización desactivada'),
                                content: Text('Para usar el mapa interactivo y la generación de itinerarios, debes activar la geolocalización.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )),
                    ),
                    SettingMenuTile(
                      icon: Iconsax.notification,
                      title: 'Notificaciones',
                      subtitle: 'Personaliza tus notificaciones: clima y diario',
                      trailing: Obx(() => Switch(
                        value: notificationController.areNotificationsEnabled.value,
                        onChanged: (value) {
                          notificationController.areNotificationsEnabled.value = value;
                          notificationController.saveNotificationState(value);
                          if (value) {
                            // Si las notificaciones están habilitadas, programar las notificaciones del clima
                            NotificationService().scheduleDailyWeatherNotifications();
                          }
                          else {
                            // Si las notificaciones están deshabilitadas, mostrar una alerta
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Notificaciones Deshabilitadas'),
                                content: Text('Las notificaciones han sido deshabilitadas. Ya no recibirás alertas sobre el clima.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Cierra la alerta
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )),
                    ),
                    SettingMenuTile(icon: Iconsax.message_question, title: 'Preguntas Frecuentes',
                      subtitle: 'Encuentra respuestas a tus preguntas comunes',
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          // Aquí rediriges a la vista de preguntas frecuentes
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQScreen()),
                          );
                        },
                      ),
                    ),
                    ///Logout
                    const SizedBox(height: Sizes.spaceBtwSection),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: () {
                        Get.off(const LoginScreen()); // Utiliza Get.off() para ir a la pantalla de inicio de sesión
                      } ,child: const Text('Cerrar Sesión')),
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems*2.5),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}

