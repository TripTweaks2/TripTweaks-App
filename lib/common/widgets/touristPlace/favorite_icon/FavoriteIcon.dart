import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/utils/constants/colors.dart';

import '../../../../features/travel/controllers/tour/FavoritesController.dart';
import '../../Icons/CircularIcon.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({super.key, required this.tourId});

  final String tourId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    return Obx(()=>CircularIcon(
        icon: controller.isFavorite(tourId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavorite(tourId) ? AppColors.error : null,
        onPressed: ()=> controller.toggleFavoriteTour(tourId),
      )
    );
  }
}
