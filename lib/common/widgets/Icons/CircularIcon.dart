import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../utils/constants/colors.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    this.widht,
    this.height,
    this.size=Sizes.lg,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final double? widht,height,size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor!=null
            ?backgroundColor!:HelperFunctions.isDarkMode(context)
            ? AppColors.black.withOpacity(0.9)
            :AppColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(onPressed: onPressed,icon: Icon(icon,color: color,size: size)),
    );
  }
}
