import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/features/travel/models/category_model.dart';
import 'package:tesis3/utils/constants/colors.dart';

import '../../../localization/GeolocationController.dart';
import '../../../navigation_menu.dart';
import '../../../utils/constants/images_string.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../../utils/popups/fullScreenLoader.dart';
import '../../ItineraryScreen/ItinerarioController/ItinerarioController.dart';
import '../../ItineraryScreen/ItinerarioScreen.dart';
import '../../Questionv2/PlaceTypeSelectionPage.dart';
import '../../Questionv2/QuestionV2.dart';
import '../../travel/controllers/category_controller.dart';
import '../widgets/QuestionCardVertical.dart';

class OnboardingScreen extends StatefulWidget {

  final bool showBackArrow; // Nuevo parámetro

  const OnboardingScreen({Key? key, this.showBackArrow = true}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<List<String>> answers = [[''], ['']];
  int currentPage = 0;
  PageController _pageController = PageController();
  Location? selectedLocation;
  List<String> selectedTypes = []; // Agrega esto

  @override
  void initState() {
    super.initState();
    // Inicializa ItinerarioController aquí
    Get.put(ItinerarioController());
    Get.put(GeolocationController());

  }

  // Función de callback para actualizar selectedLocation
  void updateSelectedLocation(Location? newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  // Función de callback para actualizar selectedTypes
  void updateSelectedTypes(List<String> newSelectedTypes) {
    setState(() {
      selectedTypes = newSelectedTypes;
    });
  }

  // Método para pasar al siguiente paso
  void onNextPage(List<String> selectedTypes) {
    print(selectedTypes);
    setState(() {
      answers[1] = selectedTypes;
    });
    nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = HelperFunctions.isDarkMode(context);
    Get.find<GeolocationController>().isGeolocationEnabled.value = true;

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Preguntas'),
        showBackArrow: widget.showBackArrow,
        actions: [  // Agrega acciones adicionales al AppBar si es necesario
          if (!widget.showBackArrow)  // Si el botón de retroceso no se muestra, muestra la acción de "Skip"
            TextButton(
              onPressed: () {
                Get.find<GeolocationController>().isGeolocationEnabled.value = true;
                // Aquí activamos la geolocalización
                Get.offAll(() => const NavigationMenu());
              },
              child: const Text('Saltar'),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: Sizes.spaceBtwItems),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                QuestionVersion2(
                  onLocationSelected: (location) {
                    setState(() {
                      selectedLocation = location;
                    });
                    nextPage();
                  },
                ),
                PlaceTypeSelectionPage(
                  onNextPage: onNextPage, // Pasar el método onNextPage
                  updateSelectedLocation: updateSelectedLocation, // Agregar esta línea
                  selectedTypes: selectedTypes, // Pasar selectedTypes
                  updateSelectedTypes: updateSelectedTypes, // Agregar esta línea
                  selectedLocation: selectedLocation,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SmoothPageIndicator(
            count: 2,
            controller: _pageController,
            effect: ExpandingDotsEffect(
              activeDotColor: darkMode ? AppColors.light : AppColors.dark,
              dotColor: darkMode ? AppColors.dark : AppColors.light,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 ? previousPage : null,
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Color cuando el botón está deshabilitado
                ),
                child: Text(
                  'Atrás',
                  style: TextStyle(
                    color: currentPage > 0 ? Colors.white : Colors.grey, // Color del texto cuando el botón está deshabilitado
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentPage == 0) {
                    nextPage();
                  } else {
                    if (selectedTypes.isNotEmpty) {
                      print("selectedTypes"); // Imprime answers[1]
                      print(selectedLocation);
                      print(selectedTypes);

                      FullScreenLoader.openLoadingDialog('Generando un nuevo itinerario ...', Images.login);

                      Get.find<ItinerarioController>().generarItinerariosV2(selectedLocation, selectedTypes).then((_) {
                        Get.find<ItinerarioController>().fetchItinerariosV2(); // Actualizar los datos después de crear el itinerario
                        Get.find<ItinerarioController>().notifyItinerariosUpdated(); // Notificar a la pantalla ItinerarioScreen
                        FullScreenLoader.stopLoading();
                        // Verificar el valor de showBackArrow y navegar en consecuencia
                        if (!widget.showBackArrow) {
                          Get.to(const NavigationMenu());

                        } else {
                          Get.back(); // Regresar a la pantalla anterior (NavigationMenu)
                        }
                      });
                    } else {
                      // Muestra una alerta si no se han seleccionado tipos de lugar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alerta'),
                            content: Text('Por favor, selecciona al menos un tipo de lugar antes de continuar.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(currentPage < 1 ? 'Siguiente' : 'Finalizar'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  bool allAnswersSelected() {
    for (List<String> answer in answers) {
      if (answer.isEmpty) {
        return false;
      }
    }
    return true;
  }
}