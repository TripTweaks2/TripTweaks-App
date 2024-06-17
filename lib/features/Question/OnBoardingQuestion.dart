import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesis3/features/ItineraryScreen/ItinerarioController/ItinerarioController.dart';

import '../../common/widgets/app_bar/appBar.dart';
import '../../localization/GeolocationController.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/images_string.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';
import '../../utils/popups/fullScreenLoader.dart';
import '../Questionv2/PlaceTypeSelectionPage.dart';
import '../Questionv2/QuestionV2.dart';

class RecommendationScreen extends StatefulWidget {
  final bool showBackArrow;

  const RecommendationScreen({Key? key, this.showBackArrow = true}) : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<List<String>> answers = [[''], ['']];
  int currentPage = 0;
  PageController _pageController = PageController();
  Location? selectedLocation;
  List<String> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    Get.put(ItinerarioController());
    Get.put(GeolocationController());
  }

  void updateSelectedLocation(Location? newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  void updateSelectedTypes(List<String> newSelectedTypes) {
    setState(() {
      selectedTypes = newSelectedTypes;
    });
  }

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
        actions: [
          if (!widget.showBackArrow)
            TextButton(
              onPressed: () {
                Get.find<GeolocationController>().isGeolocationEnabled.value = true;
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
                  onNextPage: onNextPage,
                  updateSelectedLocation: updateSelectedLocation,
                  selectedTypes: selectedTypes,
                  updateSelectedTypes: updateSelectedTypes,
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
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                ),
                child: Text(
                  'Atrás',
                  style: TextStyle(
                    color: currentPage > 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentPage == 0) {
                    nextPage();
                  } else {
                    if (selectedTypes.isNotEmpty) {
                      print("selectedTypes");
                      print(selectedLocation);
                      print(selectedTypes);

                      FullScreenLoader.openLoadingDialog('Generando un nuevo itinerario ...', Images.login);

                      Get.find<ItinerarioController>().fetchRecommendedItinerarios(
                        latitud: selectedLocation!.latitude,
                        longitud: selectedLocation!.longitude,
                        categoria: selectedTypes.join('|'),
                      ).then((_) {
                        Get.find<ItinerarioController>().notifyItinerariosUpdated();
                        FullScreenLoader.stopLoading();

                        if (!widget.showBackArrow) {
                          Get.to(const NavigationMenu());
                        } else {
                          Get.back();
                        }
                      });
                    } else {
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