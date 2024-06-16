import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/Icons/CircularIcon.dart';
import '../../../utils/constants/colors.dart';
import '../ItinerarioController/ItineraryFavoritesController.dart';

class ItineraryFavoriteIcon extends StatelessWidget {
  const ItineraryFavoriteIcon({Key? key, required this.itineraryId}) : super(key: key);

  final String itineraryId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItineraryFavoritesController());
    return Obx(
          () => CircularIcon(
        icon: controller.isFavorite(itineraryId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavorite(itineraryId) ? AppColors.error : null,
        onPressed: () => controller.toggleFavoriteItinerary(itineraryId),
      ),
    );
  }
}