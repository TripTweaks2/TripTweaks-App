import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/common/widgets/images/CircularImage.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../texts/BrandTitleText.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor=AppColors.white,
    this.backgroundColor=AppColors.white,
    this.isNetworkImage=true,
    this.onTap,
  });

  final String image,title;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: Sizes.spaceBtwItems),
        child: Column(
          children: [
            CircularImage(
                image: image,
                fit: BoxFit.fitWidth,
                padding: Sizes.sm * 1.4,
                isNetworkImage: isNetworkImage,
                backgroundColor: backgroundColor,
                overlayColor: HelperFunctions.isDarkMode(context) ? AppColors.light : AppColors.dark,
            ),
            ///Text
            const SizedBox(height: Sizes.spaceBtwItems/2),
            SizedBox( width: 55,
                child: BrandTitleText(title: title, color: textColor)
            )
          ],
        ),
      ),
    );
  }
}
