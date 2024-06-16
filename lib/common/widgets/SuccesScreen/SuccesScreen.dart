import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tesis3/common/styles/SpacingStyle.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';

import '../../../utils/constants/images_string.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_string.dart';
import '../../../utils/helpers/helper_function.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image,title,subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight*2,
          child: Column(
            children: [
              ///Image
              Lottie.asset(image,width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: Sizes.spaceBtwSection,),
              ///Title y Subtitles
              Text(title,style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
              const SizedBox(height: Sizes.spaceBtwItems,),
              Text(subtitle,style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
              const SizedBox(height: Sizes.spaceBtwSection,),
              ///Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: ()=> Get.to(()=>const LoginScreen()),child: const Text(Texts.continuar),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
