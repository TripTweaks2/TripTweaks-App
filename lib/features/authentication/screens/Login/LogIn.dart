import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/Login_SignUp/FormDivider.dart';
import 'package:tesis3/features/authentication/screens/Login/widgets/LoginForm.dart';
import 'package:tesis3/features/authentication/screens/Login/widgets/LoginHeader.dart';
import 'package:tesis3/common/widgets/Login_SignUp/SocialRegister.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';

import '../../../../common/styles/SpacingStyle.dart';
import '../../../../utils/helpers/helper_function.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              const SizedBox(height: Sizes.spaceBtwSection * 2),
              ///Logo,Title,Subtitle
              const LoginHeader(),
              ///Form
              const LoginForm(),
              ///Divider
              FormDivider(dividerText:Texts.orSignInWith.capitalize!),
              const SizedBox(height: Sizes.spaceBtwSection,),
              ///Footer
              const SocialRegisters()
            ],
          ),
        ),
      ),
    );
  }
}




