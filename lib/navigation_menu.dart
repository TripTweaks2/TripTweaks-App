import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/Question/screens/Question.dart';
import 'package:tesis3/features/travel/screens/wishList/wishList.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import 'features/ItineraryScreen/ItinerarioScreen.dart';
import 'features/Question/OnBoardingQuestion.dart';
import 'features/authentication/screens/OnBoarding/OnBoarding.dart';
import 'features/personalization/screens/Settings/Settings.dart';
import 'features/travel/screens/home/home.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(NavigationController());
    final darkMode=HelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index)=> controller.selectedIndex.value=index,
          backgroundColor: darkMode? AppColors.black:AppColors.white,
          indicatorColor: darkMode?AppColors.white.withOpacity(0.1):AppColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Inicio"),
            NavigationDestination(icon: Icon(Iconsax.map), label: "Itinerario"),
            NavigationDestination(icon: Icon(Iconsax.heart), label: "Favoritos"),
            NavigationDestination(icon: Icon(Iconsax.setting_2), label: "Configuración"),
          ],
        ),
      ),
      body: Obx(()=> controller.screens[controller.selectedIndex.value]),
    );
  }
}


class NavigationController extends GetxController{
  final Rx<int> selectedIndex= 1.obs;

  final screens=[const HomeScreen(), ItinerarioScreen(),const FavoriteScreen(),SettingClass()];


}
