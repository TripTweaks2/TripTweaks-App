import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/texts/BrandTitleText.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/enums.dart';

import '../../../utils/constants/sizes.dart';

class BrandTitleWithVerifiedIcon extends StatelessWidget {
  const BrandTitleWithVerifiedIcon({
    super.key, required this.title, this.maxLines=1,
    this.textColor, this.iconColor = AppColors.primaryElement, this.textAlign = TextAlign.center, this.textSizes = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor,iconColor;
  final TextAlign? textAlign;
  final TextSizes textSizes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: BrandTitleText(title: title,color: textColor,maxLines: maxLines,textAlign: textAlign,textSizes: textSizes)),
        const SizedBox(height: Sizes.xs),
        const Icon(Iconsax.verify5,color: AppColors.primaryElement,size: Sizes.iconXs)

      ],
    );
  }
}