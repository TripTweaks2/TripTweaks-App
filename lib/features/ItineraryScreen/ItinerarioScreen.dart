import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/ItineraryScreen/widgets/ItineraryFavoriteIcon.dart';
import 'package:tesis3/features/Questionv2/ItinerarioPlaceV2Model.dart';
import 'package:tesis3/features/Questionv2/QuestionV2.dart';
import 'package:tesis3/utils/constants/colors.dart';

import '../../common/widgets/Icons/CircularIcon.dart';
import '../../common/widgets/app_bar/appBar.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../../localization/GeolocationController.dart';
import '../../localization/MapLocalization.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/images_string.dart';
import '../../utils/helpers/cloud_helper_function.dart';
import '../Question/Itinerario/Itinerario.dart';
import '../Question/screens/Question.dart';
import '../Questionv2/ItineraryDetailsScreen.dart';
import 'ItinerarioController/ItinerarioController.dart';
import 'ItinerarioController/ItineraryFavoritesController.dart';
import 'ItineraryRepository/ItineraryRepository.dart';

class ItinerarioScreen extends StatelessWidget {
  final ItinerarioController itinerarioController = Get.put(ItinerarioController());
  final ItineraryFavoritesController itineraryFavoritesController=Get.put(ItineraryFavoritesController());
  final GeolocationController geolocationController = Get.put(GeolocationController());

  @override
  Widget build(BuildContext context) {
    final emptyWidget = AnimationLoaderWidget(
      text: 'La lista de itinerarios está vacía...',
      animation: Images.pencil,
      showAction: true,
      actionText: 'Agreguemos algo',
      onActionPressed: () => Get.off(() => const NavigationMenu()),
    );

    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Itinerarios',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lista'), // Pestaña para la lista de itinerarios
              Tab(text: 'Mis Itinerarios'), // Pestaña para los itinerarios favoritos
            ],
          ),
          actions: [
            CircularIcon(
              icon: Iconsax.add,
              onPressed: () {
                if (!geolocationController.isGeolocationEnabled.value) {
                  // Si la geolocalización está desactivada, muestra un diálogo de alerta
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Geolocalización desactivada'),
                        content: Text('Para usar esta función, debes activar la geolocalización.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra la alerta
                              // Redirige al NavigationMenu después de cerrar la alerta
                              Get.offAll(() => NavigationMenu());
                              // Establece el índice del menú en 3 (índice de SettingClass) después de un pequeño retraso
                              Future.delayed(Duration(milliseconds: 100), () {
                                Get.find<NavigationController>().selectedIndex.value = 3;
                              });
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Si la geolocalización está activada, navega a la pantalla OnboardingScreen
                  Get.to(OnboardingScreen());
                }
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña de la lista de itinerarios
            Obx(() {
              // Llamar a fetchItinerariosV2 al construir la pantalla
              itinerarioController.fetchItinerariosV2();
              final itinerarios = itinerarioController.itinerariosV2;
              if (itinerarios.isEmpty) {
                return Center(child: emptyWidget);
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await itinerarioController.fetchItinerariosV2();
                  },
                  child: ListView.builder(
                    itemCount: itinerarios.length,
                    itemBuilder: (context, index) {
                      var itinerario = itinerarios[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryElement),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itinerario.name,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    ItineraryFavoriteIcon(itineraryId: itinerario.idItinerario), // Icono de corazón
                                    IconButton(
                                      icon: Icon(Icons.edit), // Icono de lápiz
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              String newName = itinerario.name; // Nuevo nombre del itinerario
                                              return AlertDialog(
                                                title: Text('Editar Nombre de Itinerario'),
                                                content: TextField(
                                                  onChanged: (value) {
                                                    newName = value; // Actualiza el nuevo nombre a medida que el usuario escribe
                                                  },
                                                  decoration: InputDecoration(hintText: 'Nuevo nombre'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Cierra el diálogo emergente sin guardar cambios
                                                    },
                                                    child: Text('Cancelar'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      try {
                                                        await ItinerarioRepository.instance.updateItineraryNameInFirebase(itinerario.idItinerario, newName);
                                                        itinerario.name = newName;
                                                        Navigator.of(context).pop();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Nombre del itinerario actualizado correctamente'),
                                                          ),
                                                        );
                                                      } catch (error) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Error al actualizar el nombre del itinerario: $error'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text('Guardar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                    ),
                                    IconButton(
                                      icon: Icon(Iconsax.close_circle), // Icono de x de Iconsax
                                      onPressed: () async {
                                        final confirmacion = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Eliminar itinerario'),
                                            content: Text('¿Estás seguro de que deseas eliminar este itinerario?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false), // No eliminar el itinerario
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(true), // Confirmar eliminación del itinerario
                                                child: Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                        // Si el usuario confirma la eliminación del itinerario
                                        if (confirmacion == true) {
                                          try {
                                            // Eliminar el itinerario de Firebase
                                            await ItinerarioRepository.instance.deleteItineraryFromFirebase(itinerario.idItinerario);
                                            // Actualizar la lista de itinerarios en la pantalla ItinerarioScreen
                                            Get.find<ItinerarioController>().fetchItinerariosV2();
                                            Get.find<ItinerarioController>().notifyItinerariosUpdated();
                                            // Mostrar un mensaje de éxito
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Itinerario eliminado exitosamente'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (error) {
                                            // Mostrar un mensaje de error si falla la eliminación
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error al eliminar el itinerario: $error'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hora: ${itinerario.hour}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(() => ItineraryDetailsScreen(itinerario: itinerario));
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }),
            Obx(() {
                final emptyWidgetItinerary = AnimationLoaderWidget(
                  text: 'La lista de itinerarios favoritos está vacía...',
                  animation: Images.pencil,
                  showAction: true,
                  actionText: 'Agreguemos algo',
                  onActionPressed: () => Get.off(() => const NavigationMenu()),
                );

                final loader = const Center(child: CircularProgressIndicator());

                return FutureBuilder(
                  future: itineraryFavoritesController.favoritesItinerarios(),
                  builder: (context, snapshot) {
                    // Check the state of the snapshot and return a widget if applicable
                    final widget = CloudHelperFunction.checkMultiRecordState(
                      snapshot: snapshot,
                      loader: loader,
                      nothingFound: emptyWidgetItinerary,
                    );
                    if (widget != null) return widget;

                    // Continue with the normal FutureBuilder logic
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final itinerarios = snapshot.data as List<ItinerarioV2>;
                      if (itinerarios.isEmpty) {
                        return Center(child: emptyWidget);
                      } else {
                        return ListView.builder(
                          itemCount: itinerarios.length,
                          itemBuilder: (context, index) {
                            final itinerario = itinerarios[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryElement),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              itinerario.name,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ),
                                          ItineraryFavoriteIcon(itineraryId: itinerario.idItinerario), // Icono de corazón
                                          IconButton(
                                            icon: Icon(Icons.edit), // Icono de lápiz
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  String newName = itinerario.name; // Nuevo nombre del itinerario
                                                  return AlertDialog(
                                                    title: Text('Editar Nombre de Itinerario'),
                                                    content: TextField(
                                                      onChanged: (value) {
                                                        newName = value; // Actualiza el nuevo nombre a medida que el usuario escribe
                                                      },
                                                      decoration: InputDecoration(hintText: 'Nuevo nombre'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Cierra el diálogo emergente sin guardar cambios
                                                        },
                                                        child: Text('Cancelar'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            await ItinerarioRepository.instance.updateItineraryNameInFirebase(itinerario.idItinerario, newName);
                                                            itinerario.name = newName;
                                                            Navigator.of(context).pop();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                content: Text('Nombre del itinerario actualizado correctamente'),
                                                              ),
                                                            );
                                                          } catch (error) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text('Error al actualizar el nombre del itinerario: $error'),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Text('Guardar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Iconsax.close_circle), // Icono de x de Iconsax
                                            onPressed: () async {
                                              final confirmacion = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Eliminar itinerario'),
                                                  content: Text('¿Estás seguro de que deseas eliminar este itinerario?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false), // No eliminar el itinerario
                                                      child: Text('Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true), // Confirmar eliminación del itinerario
                                                      child: Text('Eliminar'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              // Si el usuario confirma la eliminación del itinerario
                                              if (confirmacion == true) {
                                                try {
                                                  // Eliminar el itinerario de Firebase
                                                  await ItinerarioRepository.instance.deleteItineraryFromFirebase(itinerario.idItinerario);
                                                  // Actualizar la lista de itinerarios en la pantalla ItinerarioScreen
                                                  Get.find<ItinerarioController>().fetchItinerariosV2();
                                                  Get.find<ItinerarioController>().notifyItinerariosUpdated();
                                                  // Mostrar un mensaje de éxito
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Itinerario eliminado exitosamente'),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );
                                                } catch (error) {
                                                  // Mostrar un mensaje de error si falla la eliminación
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Error al eliminar el itinerario: $error'),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Hora: ${itinerario.hour}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Get.to(() => ItineraryDetailsScreen(itinerario: itinerario));
                                },
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                );
              }),
            // Contenido de la pestaña de itinerarios favoritos
            // Aquí puedes implementar la lógica para mostrar los itinerarios favoritos
            // Contenido de la pestaña de itinerarios favoritos

          ],
        ),
      ),
    );
  }
}