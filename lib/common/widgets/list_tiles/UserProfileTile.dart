import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images_string.dart';
import '../images/CircularImage.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final controller=UserController.instance;
    return Obx((){
      final isNetworkImage = controller.user.value.profilePicture.isNotEmpty;
      final image = isNetworkImage ? controller.user.value.profilePicture : Images.user;
      return ListTile(
        leading: CircularImage(
          image: image,
          width: 50,
          height: 50,
          padding: 0,
          isNetworkImage: isNetworkImage,
        ),
        title: Text(controller.user.value.fullName,style: Theme.of(context).textTheme.headlineSmall!.apply(color:AppColors.white)),
        subtitle: Text(controller.user.value.email,style: Theme.of(context).textTheme.bodyMedium!.apply(color:AppColors.white)),
        trailing: IconButton(onPressed: onPressed,icon: const Icon(Iconsax.edit,color: AppColors.white,),),

      );
    });
  }
}
