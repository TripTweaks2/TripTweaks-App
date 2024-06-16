import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_function.dart';

class OnBoardingQuestionNextButton extends StatelessWidget {
  const OnBoardingQuestionNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return Positioned(
        right: Sizes.defaultSpace,
        bottom: DeviceUtils.getBottomNavigationBarHeight() -30,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor: dark? AppColors.primaryElement : Colors.black),
          child: const Icon(Iconsax.arrow_right_3),
        )
    );
  }
}