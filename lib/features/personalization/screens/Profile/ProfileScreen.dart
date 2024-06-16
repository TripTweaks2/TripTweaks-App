import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/common/widgets/images/CircularImage.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/features/personalization/screens/Profile/widgets/ChangeName.dart';
import 'package:tesis3/features/personalization/screens/Profile/widgets/ChangePhoneNumber.dart';
import 'package:tesis3/features/personalization/screens/Profile/widgets/ProfileMenu.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';

import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=UserController.instance;
    return Scaffold(
      appBar: TAppBar(showBackArrow: true,title: Text("Perfil")),
      ///Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage=controller.user.value.profilePicture;
                      final image=networkImage.isNotEmpty ? networkImage : Images.user;
                      return controller.imageUploading.value
                        ? const ShimmerEffect(width: 80, height: 80, radius: 80)
                        : CircularImage(image: image,width: 80,height: 80,isNetworkImage: networkImage.isNotEmpty);
                    }),
                    TextButton(onPressed: ()=> controller.uploadUserProfilePicture(), child: const Text('Cambiar Foto de Perfil')),

                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              const Divider(),
              const SizedBox(height: Sizes.spaceBtwItems),
              const SectionHeading(title: 'Información de Perfil',showActionButton: false),
              const SizedBox(height: Sizes.spaceBtwItems),
              ProfileMenu(title: "Nombre",value: controller.user.value.fullName,onPressed: () => Get.to(()=> const ChangeName())),
              ProfileMenu(title: "Nombre de Usuario",value: controller.user.value.username,onPressed: () {}),
              const SizedBox(height: Sizes.spaceBtwItems/2),
              const Divider(),
              const SizedBox(height: Sizes.spaceBtwItems),
              ProfileMenu(title: "Correo Electrónico",value: controller.user.value.email, onPressed: () {  }, showIcon: false),
              ProfileMenu(title: "Celular",value: controller.user.value.phoneNumber,onPressed: () => Get.to(()=> const ChangePhoneNumber())),
              const Divider(),
              const SizedBox(height: Sizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: ()=>controller.deleteAccountWarningPopup(),
                  child: const Text("Eliminar cuenta",style: TextStyle(color: Colors.red),),
                ),
              )
            ],
          ),),
      ),
    );
  }
}

