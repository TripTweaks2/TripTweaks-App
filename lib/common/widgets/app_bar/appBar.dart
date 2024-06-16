import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/device/device_utility.dart';

import '../../../utils/helpers/helper_function.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar({
    super.key,
    this.title,
    this.showBackArrow=false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: showBackArrow
              ? IconButton(onPressed: ()=>Get.back(), icon: Icon(Iconsax.arrow_left,color:dark ?AppColors.white:AppColors.dark))
              :leadingIcon!=null ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon)):null,
          title: title,
          actions: actions,
        )
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());


}
