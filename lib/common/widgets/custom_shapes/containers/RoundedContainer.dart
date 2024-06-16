import 'package:flutter/cupertino.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.widht,
    this.height,
    this.padding,
    this.margin,
    this.child,
    this.showBorder=false,
    this.borderColor=AppColors.borderPrimary,
    this.backgroundColor=AppColors.white,
    this.radius=Sizes.cardRadiusLg
    });

  final double? widht;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder ;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder? Border.all(color: borderColor):null
      ),
      child: child,
    );
  }
}
