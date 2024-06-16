import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_function.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key, required this.text, this.icon=Iconsax.search_normal, this.showBackground=true, this.showBorder=true, this.onTap,this.padding=const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground,showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: DeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(Sizes.md),
          decoration: BoxDecoration(
              color: showBackground? dark ? AppColors.dark:AppColors.white:Colors.transparent,
              borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
              border: showBorder? Border.all(color: AppColors.grey):null
          ),
          child: Row(
            children: [
              Icon(icon,color: AppColors.darkerGrey),
              const SizedBox(width: Sizes.spaceBtwItems),
              Text(text,style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
      
        ),
      ),
    );
  }
}
