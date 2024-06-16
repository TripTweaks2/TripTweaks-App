import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/features/authentication/controllers/onBoarding/OnBoarding_Controller.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: DeviceUtils.getAppBarHeight(),
        right: Sizes.defaultSpace,
        child: TextButton(onPressed: ()=>OnBoardingController.instance.skipPage(),child: const Text('Saltar'),));
  }
}