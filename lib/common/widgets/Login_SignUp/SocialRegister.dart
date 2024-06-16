import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/authentication/controllers/login/login_controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images_string.dart';
import '../../../utils/constants/sizes.dart';

class SocialRegisters extends StatelessWidget {
  const SocialRegisters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(LogInController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () =>controller.googleSignIn(),
            icon: const Image(
                width: Sizes.iconMd,
                height: Sizes.iconMd,
                image: AssetImage(Images.google)
            ),
          ),
        )
      ],
    );
  }
}
