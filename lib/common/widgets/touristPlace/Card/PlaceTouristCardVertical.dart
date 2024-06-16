import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/custom_shapes/containers/RoundedContainer.dart';
import 'package:tesis3/common/widgets/texts/BrandTitleWithVerifiedIcon.dart';
import 'package:tesis3/features/travel/controllers/tour/TourController.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/features/travel/screens/tour_detail/tour_detail.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../styles/ShadowStyle.dart';
import '../../Icons/CircularIcon.dart';
import '../../images/RoundedImage.dart';
import '../../texts/PlaceTitleText.dart';
import '../../texts/SubInformationPlaceText.dart';
import '../favorite_icon/FavoriteIcon.dart';

class PlaceTouristCardVertical extends StatelessWidget {
  const PlaceTouristCardVertical({super.key,required this.tour});

  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    final controller=TourController.instance;
    final dark=HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: ()=>Get.to(()=>TourDetail(tour: tour)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalPlaceShadow],
          borderRadius: BorderRadius.circular(Sizes.placeImageRadius),
          color: dark ? AppColors.darkerGrey:AppColors.white
        ),
        child: Column(
          children: [
            ///Image
            RoundedContainer(
              height: 130,
              padding: const EdgeInsets.all(Sizes.sm),
              backgroundColor: dark? AppColors.dark: AppColors.light,
              child: Stack(
                children: [
                  RoundedImage(imageUrl: tour.thumbnail,applyImageRadius: true,isNetworkImage: true),
                  ///Favorite Icon Button
                  Positioned(
                      top: 0,
                      right: 0,
                      child: FavoriteIcon( tourId: tour.id)),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems/2),
            ///Details Image
            Padding(padding: const EdgeInsets.only(left: Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlaceTitleText(title: tour.title,smallSize: true),
                  const SizedBox(height: Sizes.spaceBtwItems/2),
                  BrandTitleWithVerifiedIcon(title: tour.typeModel!.name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SubInformationPlaceText(text: 'Información'),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Sizes.cardRadiusMd),
                            bottomRight: Radius.circular(Sizes.placeImageRadius)
                          )
                        ),
                        child: const SizedBox(
                            width: Sizes.iconLg*0.8,
                            height: Sizes.iconLg*0.8,
                            child: Icon(Iconsax.add,color: AppColors.white)),
                      )
                    ],
      
                  )
      
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




