import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesis3/features/Question/controller/OnBoardingQuestion_Controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_function.dart';

class OnBoardingQuestionDotNavigation extends StatelessWidget {
  const OnBoardingQuestionDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    final controller=Get.put(OnBoardingQuestionController());
    return Positioned(
      bottom: DeviceUtils.getBottomNavigationBarHeight() - 30,
      left: Sizes.defaultSpace,
      child: SmoothPageIndicator(
          count: 3,
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          effect: ExpandingDotsEffect(activeDotColor: dark ? AppColors.light:AppColors.dark ,dotHeight: 6)),);
  }
}
