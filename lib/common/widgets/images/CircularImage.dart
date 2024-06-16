import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../utils/constants/sizes.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = Sizes.sm,
    this.isNetworkImage = false
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (HelperFunctions.isDarkMode(context) ? AppColors.black : AppColors
                .white),
        borderRadius: BorderRadius.circular(100),
      ),
      // BoxDecoration
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
            ?  CachedNetworkImage(
              fit:fit,
              //color:overlayColor,
              imageUrl: image,
              progressIndicatorBuilder: (context,url,downloadProgress) => const ShimmerEffect(width: 55, height: 55),
              errorWidget: (context,url,error) => const Icon(Icons.error),
          )// Image
          : Image(
            fit: fit,
            image: AssetImage(image),
            color: overlayColor,
          ),
        ),
      ), // Center
    );
  }
}
