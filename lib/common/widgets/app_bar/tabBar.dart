import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/device/device_utility.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

class tabBar extends StatelessWidget implements PreferredSizeWidget{
  const tabBar({super.key, required this.tabs});

  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? AppColors.black:AppColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: AppColors.primaryElement,
        labelColor: HelperFunctions.isDarkMode(context) ? AppColors.white : AppColors.primaryElement,
        unselectedLabelColor: AppColors.darkerGrey,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}
