import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

class Loaders{
  static successSnackBar({required title,message ='',duration = 3}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: AppColors.primaryElement,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(100),
      icon: const Icon(Iconsax.check,color: AppColors.white),
    );
  }

  static warningSnackBar({required title,message =''}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.teal,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2,color: AppColors.white),
    );
  }

  static errorSnackBar({required title,message =''}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2,color: AppColors.white),
    );
  }

  static customToast({required message}){
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: HelperFunctions.isDarkMode(Get.context!) ? AppColors.darkerGrey.withOpacity(0.9) : AppColors.grey.withOpacity(0.9)
            ),
            child: Center(child: Text(message,style: Theme.of(Get.context!).textTheme.labelLarge)),
          ))
    );
  }


}