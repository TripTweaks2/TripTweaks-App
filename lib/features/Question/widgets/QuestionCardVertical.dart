import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/travel/models/category_model.dart';

import '../../../common/styles/ShadowStyle.dart';
import '../../../common/widgets/Icons/CircularIcon.dart';
import '../../../common/widgets/custom_shapes/containers/RoundedContainer.dart';
import '../../../common/widgets/images/RoundedImage.dart';
import '../../../common/widgets/texts/PlaceTitleText.dart';
import '../../../common/widgets/texts/SubInformationPlaceText.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images_string.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';

class QuestionCardVertical extends StatelessWidget {
  const QuestionCardVertical({super.key, required this.categoryModel, required this.containerColor});

  final CategoryModel categoryModel;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return GestureDetector(
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            boxShadow:  [ShadowStyle.verticalPlaceShadow],
            borderRadius: BorderRadius.circular(Sizes.placeImageRadius),
            color: dark ? AppColors.darkerGrey:AppColors.white,
            border: Border.all(color: containerColor, width: 2),
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
                  RoundedImage(isNetworkImage: true, imageUrl: categoryModel.image,applyImageRadius: true),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems/2),
            ///Details Image
            Padding(
              padding: EdgeInsets.only(left: Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlaceTitleText(title: categoryModel.name,smallSize: true),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
