import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';

import '../../../../utils/helpers/helper_function.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key,required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=>Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              ///Image
              Image(image: const AssetImage(Images.animation1),width: HelperFunctions.screenWidth()*0.6),
              const SizedBox(height: Sizes.spaceBtwSection,),
              ///Title y Subtitles
              Text(email,style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center),
              const SizedBox(height: Sizes.spaceBtwItems,),
              Text(Texts.changePasswordTitle,style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
              const SizedBox(height: Sizes.spaceBtwItems,),
              Text(Texts.changePasswordSubtitle,style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
              const SizedBox(height: Sizes.spaceBtwSection,),
              ///Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: ()=>Get.offAll(()=>const LoginScreen()),child: const Text(Texts.done),),
              ),
              const SizedBox(height: Sizes.spaceBtwItems,),
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: ()=>ForgetPasswordController.instance.resendPasswordResetEmail(email),child: const Text(Texts.resendEmail),),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
