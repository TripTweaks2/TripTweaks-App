import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';

import '../../../../../common/widgets/Icons/CircularIcon.dart';
import '../../../../../common/widgets/app_bar/appBar.dart';
import '../../../../../common/widgets/itinerary_cart/cart_menu_icon.dart';
import '../../../../../localization/MapLocalization.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_string.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(UserController());
    return TAppBar(title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Texts.homeAppBarTitle,style: Theme.of(context).textTheme.labelMedium!.apply(color: AppColors.grey)),
        Obx((){
            if(controller.profileLoading.value){
              return const ShimmerEffect(width: 80, height: 15);
            } else{
              return Text(controller.user.value.fullName,style: Theme.of(context).textTheme.headlineSmall!.apply(color: AppColors.white));
            }
          }),
      ],
    ),
    );
  }
}
