import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/Login_SignUp/FormDivider.dart';
import 'package:tesis3/features/authentication/screens/SignUp/widgets/SignUpForm.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';

import '../../../../common/widgets/Login_SignUp/SocialRegister.dart';
import '../../../../utils/helpers/helper_function.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(Texts.signTitle,style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Sizes.spaceBtwSection),
              ///Form
              const SignUpForm(),
              const SizedBox(height: Sizes.spaceBtwSection),
              ///Divider
              FormDivider(
                dividerText:Texts.orSignUpWith.capitalize!
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
              ///Footer
              const SocialRegisters(),
              const SizedBox(height: Sizes.spaceBtwSection),

            ],
          ),
        ),
      ),
    );
  }
}

