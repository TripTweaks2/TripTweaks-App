import 'package:flutter/cupertino.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius= true,
    this.border,
    this.backgroundColor=AppColors.light,
    this.fit=BoxFit.contain,
    this.padding,
    this.borderRadius=Sizes.md,
    this.isNetworkImage=false,
    this.onPressed});


  final double? width,height;
  final String imageUrl ;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor ;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isNetworkImage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(border: border,color: backgroundColor,borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
          borderRadius: applyImageRadius?BorderRadius.circular(borderRadius):BorderRadius.zero,
          child: Image(fit: fit,image: isNetworkImage ? NetworkImage(imageUrl):AssetImage(imageUrl) as ImageProvider),
        ),
      ),
    );
  }
}
