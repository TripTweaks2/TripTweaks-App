import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/SuccesScreen/SuccesScreen.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key,this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()=>AuthenticationRepository.instance.logout(), icon:const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Column(
              children: [
                ///Image
                Image(image: const AssetImage(Images.animation1),width: HelperFunctions.screenWidth()*0.6),
                const SizedBox(height: Sizes.spaceBtwSection,),
                ///Title y Subtitles
                Text(Texts.confirmEmail,style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
                const SizedBox(height: Sizes.spaceBtwItems,),
                Text(email ?? '',style: Theme.of(context).textTheme.labelLarge,textAlign: TextAlign.center,),
                const SizedBox(height: Sizes.spaceBtwItems,),
                Text(Texts.confirmEmailSubtitle,style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
                const SizedBox(height: Sizes.spaceBtwSection,),
                ///Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.checkEmailVerificationStatus(),
                    child: const Text(Texts.continuar),),),
                const SizedBox(height: Sizes.spaceBtwItems,),
                SizedBox(width: double.infinity,child: TextButton(onPressed: ()=> controller.sendEmailVerification(),child: const Text(Texts.resendEmail),),),
              ],
            ),
        ),
      ),
    );
  }
}
