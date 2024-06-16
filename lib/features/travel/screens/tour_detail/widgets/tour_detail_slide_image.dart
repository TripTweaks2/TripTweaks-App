import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/touristPlace/favorite_icon/FavoriteIcon.dart';
import 'package:tesis3/features/travel/controllers/tour/images_controller.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

import '../../../../../common/widgets/Icons/CircularIcon.dart';
import '../../../../../common/widgets/app_bar/appBar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/CurvedEdgeWidget.dart';
import '../../../../../common/widgets/images/RoundedImage.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/images_string.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    super.key, required this.tour
  });

  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);

    final controller=Get.put(ImagesController());
    final images=controller.getAllProductImages(tour);
    return CurvedEdgeWidget(
      child: Container(
        color: dark?AppColors.darkerGrey:AppColors.light,
        child: Stack(
          children: [
            SizedBox(height: 400,child: Padding(
              padding: const EdgeInsets.all(Sizes.placeImageRadius * 2),
              child: Center(child: Obx( () {
                final image= controller.selectedProductImage.value;
                return GestureDetector(
                  onTap: () => controller.showEnlargedImage(image),
                  child: CachedNetworkImage(
                      imageUrl:image,
                      progressIndicatorBuilder: (_,__,downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, color: AppColors.primaryElement)),
                );}
              )),
            )),
            Positioned(
              right: 0,
              bottom: 30,
              left: Sizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                    itemCount: images.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder:(_,__) => const SizedBox(width: Sizes.spaceBtwItems),
                    itemBuilder:(_,index)=> Obx(
                      () {
                        final imageSelected = controller.selectedProductImage.value == images[index];
                        return RoundedImage(
                            width:80,
                            isNetworkImage: true,
                            imageUrl: images[index],
                            padding: const EdgeInsets.all(Sizes.sm),
                            backgroundColor: dark?AppColors.dark:AppColors.white,
                            onPressed: ()=>controller.selectedProductImage.value = images[index],
                            border:Border.all(color: imageSelected ? AppColors.primaryElement : Colors.transparent),
                        );
                      }
                    )
                ),
              ),
            ),
            TAppBar(
              showBackArrow: true,
              actions: [
                FavoriteIcon( tourId: tour.id),
              ],
            )
          ],
        ),
      ),
    );
  }
}
