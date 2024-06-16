import 'package:flutter/cupertino.dart';
import 'package:tesis3/utils/constants/colors.dart';

class ShadowStyle{
  static final verticalPlaceShadow = BoxShadow(
    color:AppColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );


  static final horizontalPlaceShadow = BoxShadow(
      color:AppColors.darkGrey.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0, 2)
  );


  static final verticalPlaceShadow2 = BoxShadow(
      color:AppColors.darkGrey.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 2,
      offset: const Offset(0, 2)
  );

}