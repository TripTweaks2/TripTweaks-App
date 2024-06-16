import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/features/travel/screens/typesTours/TypesTours.dart';

import '../../../features/travel/models/type_Model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images_string.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/containers/RoundedContainer.dart';
import '../touristPlace/Card/BrandCard.dart';

class BrandShowcase extends StatelessWidget {
  const BrandShowcase({
    required this.images,
    super.key, required this.typeModel,
  });

  final TypeModel typeModel;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => TypesTours(typeModel: typeModel)),
      child: RoundedContainer(
        showBorder: true,
        borderColor: AppColors.darkerGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(Sizes.md),
        margin: const EdgeInsets.only(bottom:Sizes.spaceBtwItems),
        child: Column(
            children:
            [
              //TIPOS
              BrandCard(showBorder: false, type: typeModel),
              const SizedBox(height: Sizes.spaceBtwItems),
              Row(
                children: images.map((image) => brandProductImageWidget(image, context)).toList(),
              )
            ]
        ),
      ),
    );
  }
}

Widget brandProductImageWidget(String image,context)
{
  return Expanded(
    child: RoundedContainer(
      height: 100,
      backgroundColor: HelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light,
      margin: const EdgeInsets.only(right: Sizes.sm),
      padding: const EdgeInsets.all(Sizes.md),
      child: CachedNetworkImage(
        fit:BoxFit.contain,
        imageUrl: image,
        progressIndicatorBuilder: (context,url,downloadProgress) => const ShimmerEffect(width: 100, height: 100),
        errorWidget: (context,url,error) => const Icon(Icons.error),
      ),
    ),
  );
}