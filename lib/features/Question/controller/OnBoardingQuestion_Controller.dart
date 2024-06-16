import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesis3/navigation_menu.dart';

class OnBoardingQuestionController extends GetxController {
  static OnBoardingQuestionController get instance=>Get.find();

  ///Variables
  final pageController= PageController();
  Rx<int> currentPageIndex=0.obs;
  String? firstQuestionAnswer; // Variable para almacenar la respuesta de la primera pregunta
  String? secondQuestionAnswer; // Variable para almacenar la respuesta de la primera pregunta
  // Variable para rastrear si se ha guardado la respuesta de la primera pregunta
  RxBool isFirstQuestionAnswered = false.obs;



  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value=index;
    pageController.jumpTo(index);
  }


  void nextPage() {
    if (currentPageIndex.value == 2) {
      // Navegación a la siguiente página o acción después de completar el cuestionario
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpTo(2.toDouble());
  }

  // Método para almacenar la respuesta de la primera pregunta
  void saveFirstQuestionAnswer(String answer) async {
    try {
      print('Guardando respuesta de la primera pregunta: $answer');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstQuestionAnswer', answer);
      print('Respuesta de la primera pregunta guardada en SharedPreferences.');
      firstQuestionAnswer = answer;
      isFirstQuestionAnswered.value = true;
    } catch (e) {
      print('Error al guardar la respuesta en SharedPreferences: $e');
    }
  }

}