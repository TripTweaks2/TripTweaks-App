import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tesis3/features/authentication/controllers/onBoarding/OnBoarding_Controller.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/widgets/OnBoardingDotNavigation.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/widgets/OnBoardingNextButton.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/widgets/OnBoardingPageWidget.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/widgets/SkipButton.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/text_string.dart';
import 'package:tesis3/utils/device/device_utility.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          ///Horizontal Scroll Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPageWidget(image: Images.onBoardingImages1,title: Texts.onBoardingTitle1,subtitle: Texts.onBoardingSubTitle1),
              OnBoardingPageWidget(image: Images.onBoardingImages2,title: Texts.onBoardingTitle2,subtitle: Texts.onBoardingSubTitle2),
              OnBoardingPageWidget(image: Images.onBoardingImages3,title: Texts.onBoardingTitle3,subtitle: Texts.onBoardingSubTitle3),
            ],
          ),
          ///Skip Button
          const SkipButton(),
          ///Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),
          ///CircularButton
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}





