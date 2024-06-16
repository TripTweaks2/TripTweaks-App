import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/features/travel/models/type_Model.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/images_string.dart';
import '../../../../utils/constants/sizes.dart';
import '../../custom_shapes/containers/RoundedContainer.dart';
import '../../images/CircularImage.dart';
import '../../texts/BrandTitleWithVerifiedIcon.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key, required this.showBorder, this.onTap, required this.type,
  });

  final TypeModel type;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark=HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding: const EdgeInsets.all(Sizes.sm),
        showBorder: true,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            Flexible(child: CircularImage(isNetworkImage: true,image: type.image,backgroundColor: Colors.transparent,overlayColor: isDark? AppColors.white:AppColors.black)),
            const SizedBox(height: Sizes.spaceBtwItems/2),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandTitleWithVerifiedIcon(title: type.name,textSizes: TextSizes.large),
                  Text(
                    '${type.toursCount ?? 0} categorias',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
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
