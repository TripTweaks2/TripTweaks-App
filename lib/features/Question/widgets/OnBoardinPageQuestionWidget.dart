import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var answers = <List<String>>[[''], ['']];
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  void nextPage(List<String> selectedOptions) {
    answers[currentPage.value] = selectedOptions;
    currentPage++;
    pageController.nextPage(duration: Duration(milliseconds: 500),
        curve: Curves.ease);
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage--;
      pageController.previousPage(duration: Duration(milliseconds: 500),
          curve: Curves.ease);
    }
  }
}