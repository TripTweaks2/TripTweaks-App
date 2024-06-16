import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/custom_shapes/containers/RoundedContainer.dart';
import 'package:tesis3/common/widgets/image_text_widget/TourImageText.dart';
import 'package:tesis3/common/widgets/images/RoundedImage.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';

import '../../../../features/travel/models/tour_model.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../texts/BrandTitleWithVerifiedIcon.dart';
import '../favorite_icon/FavoriteIcon.dart';

class PlaceTouristCardHorizontal extends StatelessWidget {
  const PlaceTouristCardHorizontal({super.key, required this.tour});

  final TourModel tour;
  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return Container(
      width: 310,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.placeImageRadius),
        color: dark ? AppColors.darkerGrey : AppColors.softGrey
      ),
      child: Row(
        children: [
          RoundedContainer(
            height: 120,
            padding: EdgeInsets.all(Sizes.sm),
            backgroundColor: dark ? AppColors.dark : AppColors.white,
            child: Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: RoundedImage(isNetworkImage: true,imageUrl: tour.thumbnail,applyImageRadius: true),
                ),
                ///Favorite Icon Button
                Positioned(
                    top: 0,
                    right: 0,
                    child: FavoriteIcon( tourId: tour.id)),
              ],
            ),
          ),
          SizedBox(
            width: 172,
            child: Padding(padding: EdgeInsets.only(top: Sizes.sm,left: Sizes.sm),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TourTitleText(title: tour.title,smallSize: true),
                      const SizedBox(height: Sizes.spaceBtwItems/2),
                      BrandTitleWithVerifiedIcon(title: tour.typeModel!.name),
                    ],
                  )
                ],
              )
              ),
          ),

        ],
      ),
    );
  }
}
